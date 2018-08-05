Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 7.mo177.mail-out.ovh.net ([46.105.61.149]:53714 "EHLO
        7.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbeHEUhi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Aug 2018 16:37:38 -0400
Received: from player771.ha.ovh.net (unknown [10.109.159.154])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 57AF4BB11E
        for <linux-wireless@vger.kernel.org>; Sun,  5 Aug 2018 20:32:08 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v5 0/3] Fix PTK rekey freezes and cleartext leaks
Date: Sun,  5 Aug 2018 20:31:21 +0200
Message-Id: <20180805183124.29921-1-alexander@wetzel-home.de> (sfid-20180805_203215_232820_BEE2D17C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series addresses a long standing issue how mac80211 handles
PTK rekeys. The current implementation can only work with SW crypto or
by chance, e.g. if there are no frames transmitted while the STAs are
rekeying or you hit just the right combination of cards/drivers.

Any ongoing transmission while rekeying will very likely freeze the
connection till the connection is rekeyed again or the user manually
reconnects. Without any indication why, even in a kernel trace.

The multiple ways how this can go wrong are outlined in the commit
message from the last patch in this series, but here a short overview:

The main culprit for that is encryption offloading to the card while
handling the PN (IV) in mac80211 without any synchronization in between.
This allows the replay detection code to account packets intended for
the old key against the new one, which sets the PN to a value which was
correct for the old key but will drop all packets send with a PN
belonging to the new key.
The solution is of course to make sure packets prepared for the old key
are never checked against the PN (IV) of the new key, thus preventing
the invalid carry over of the old PN value to the new key.

The issue is complicated by the fact that at last some drivers do not
expect to be asked to replace a key which may be actively in use for
transmitting packets. Ath9k is e.g. simply removing the key and then
sends out the queued packets in clear till the new key is installed.

As a conclusion we therefore have to assume that all drivers which do
not actively tell us that they can handle replacing an in-use key must
not be asked to do so. Unfortunately the rekey decision is solely the
responsibility of the userspace and when the kernel refuses to replace
a key those programs are suddenly exposed to an new error condition.
At least wpa_supplicant currently reacts badly to that and assumes the
PSK is wrong instead of simply reconnecting when trying that.

We also do not have an established way to inform the userspace that the
rekey operation is not supported and it must not use it.

As a way forward this patch series makes the needed changes to correctly
rekey connections and allowing the userspace to check if PTK rekeys can
be used at all. While enforcing this restriction would probably be ok
there are some constellations where it can work. So instead of reporting
an error back to the userspace we now only print out a warning and fall
back to a best-we-can-do approach to maintain backward compatibility.

Downside here is, that till the userspace catches up - or all drivers
are supporting the new API for in-use key replaces - users may still
suffer connection freezes and leak cleartext frames. But only a fraction
of what it would be without this patch.

It's also worth mentioning that most of the pitfalls reking a PTK key
has could have been avoided if the first IEEE 802.11 standards would
already have had the option introduced in the 2012 version, named
"Extended Key ID for Individually Addressed Frames". This basically
drills down to using key ID 0 and 1 for PTK keys (and shift GTKs to 2
and 3), allowing to rollover PTK keys the same way it has been
established for GTK keys.
Supporting this addition will be the ultimate solution for the issues,
but since it only can be used if both sides are supporting it we still
have to handle PTK keys only using the key ID 0.

Here a quick overview of the patches in the series:
1) nl80211: Add ATOMIC_KEY_REPLACE API
   This adds support for NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE
   to nl80211. We expect the userspace (hostap, wpa_supplicant, iwd ...)
   to check this flag and only rekey a connection when this flag is
   present. When the flag is not set a rekey has to be "emulated" by a
   full de-association and a reconnect if it can't be avoided by the
   userspace.

2) mac80211: Define new driver callback replace_key
   This is just adding the new driver callback replace_key in
   mac80211 the last patch of the set can then use when needed.
   It's needed to provide a clear demarcation line between old
   packets which absolutely must not be send out with new key and new
   ones which should use the new key.
   By giving the driver the option to directly replace a running key
   with a updated one many drivers should be able to implement an atomic
   switch which is either using the old or the new key, avoiding the
   headach how to prevent some packets to be send out unencrypted.

3) mac80211: Fix PTK rekey freezes and cleartext leaks
   This finally changes how mac80211 handles the rekey and starts using
   the replace_key and sets NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE for
   drivers using mac80211 for it. GTK rekey is basically unchanged and
   only PTK rekey fixed to allow replacing the key with it while receiving
   and sending packets with HW encryption offloading and the races this
   causes to be factored in.
   When the driver is not supporting replace_key the code still fix the
   cleartext packet leak in mac80211 and stops RX and TX aggregation to
   prevent those to freeze the connection but besides that falls back to
   the old - know to be broken - sequence for backward compatibility. In
   that case mac80211 will print our a error message, alerting users
   that they still could leak clear text packets and may experience
   connection freezes till they either disable rekey or upgrade the
   userspace. (There is currently no updated userspace available.)

Version history:
V5 Fix PTK rekey freezes and cleartext leaks
    - rewritten most of the cover letter to give a better overview
    - Make "HW installs key prior to mac80211" the default for all
      key installs. (Cleaner, better understandable code.)
    - best-we-can-do approach for drivers not implementing replace_key
      which should work for many drivers.

V4 Fix PTK rekey freezes and cleartext leaks
    - Switched over to a small patch series.
    - Allows insecure rekeys again for compatibility
    - Allows the userspace to check if rekeys are safe by extending
      nl80211.

V3 mac80211: Fix PTK rekey freezes and cleartext leaks
    Updates the mac80211 API. When the driver is implementing the new
    callback replace_key mac80211 allows PTK rekeys. If not it returns
    an error on key install to the requester.

V2 mac80211: Fix wlan freezes under load at rekey
    This fixes the issue in mac80211 only without API changes on a
    best-can-do approach. Drivers still can freeze the connection and if
    so have to be fixed.

V1 mac80211: Fix wlan freezes under load at rekey
    Very simple approach, only fixing the freezes and using a not
    guaranteed to be working fallback to SW encryption.

Alexander Wetzel (3):
  nl80211: Add ATOMIC_KEY_REPLACE API
  mac80211: Define new driver callback replace_key
  mac80211: Fix PTK rekey freezes and cleartext leaks

 include/net/mac80211.h       |  15 ++++
 include/uapi/linux/nl80211.h |   6 ++
 net/mac80211/driver-ops.h    |  20 ++++++
 net/mac80211/key.c           | 131 +++++++++++++++++++++++++++++------
 net/mac80211/main.c          |   5 ++
 net/mac80211/trace.h         |  39 +++++++++++
 net/mac80211/tx.c            |   4 ++
 7 files changed, 200 insertions(+), 20 deletions(-)

-- 
2.18.0
