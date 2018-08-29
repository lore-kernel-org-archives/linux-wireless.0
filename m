Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 19.mo7.mail-out.ovh.net ([178.33.251.118]:45345 "EHLO
        19.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbeH2UkY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 16:40:24 -0400
Received: from player771.ha.ovh.net (unknown [10.109.146.86])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 7C031CE27F
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 18:35:31 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v7 0/2] Fix PTK rekey freezes and clear text leak
Date: Wed, 29 Aug 2018 18:34:50 +0200
Message-Id: <20180829163452.32666-1-alexander@wetzel-home.de> (sfid-20180829_184241_398153_5F3E3E28)
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
This allows the replay detection code to account frames intended for
the old key against the new one, which sets the PN to a value which was
correct for the old key but will drop all frames send with a PN
belonging to the new key.
The solution is of course to make sure frames prepared for the old key
are never checked against the PN (IV) of the new key, thus preventing
the invalid carry over of the old PN value to the new key.

The issue is complicated by the fact that at last some drivers do not
expect to be asked to replace a key which may be actively in use for
transmitting frames. Ath9k is e.g. simply removing the key and then
sends out the queued frames in clear till the new key is installed.

As a conclusion we therefore have to assume that all drivers which do
not actively tell us that they can handle replacing an in-use key must
not be asked to do so. Unfortunately the rekey decision is solely the
responsibility of the user space and when the kernel refuses to replace
a key those programs are suddenly exposed to an new error condition.
At least wpa_supplicant currently reacts badly to that and assumes the
PSK is wrong instead of simply quickly reconnecting when trying that.

We also do not have an established way to inform the user space that the
rekey operation is not supported and it must not use it.

As a way forward this patch series makes the needed changes to correctly
rekey connections and allowing the user space to check if PTK rekeys can
be used at all. While enforcing this restriction would probably be OK
there are some constellations where it can work. So instead of reporting
an error back to the user space we now only print out a warning and fall
back to a best-we-can-do approach to maintain backward compatibility.

Downside here is, that till the user space catches up - or all drivers
are supporting the new API for in-use key replaces - users may still
suffer connection freezes and leak clear text frames. But it should only
be a fraction of what it would be without this patch and not break
anything in the cases where it's currently working.

It's also worth mentioning that most of the pitfalls rekeying a PTK has
could have been avoided if the first IEEE 802.11 standards would already
have had the option introduced in the 2012 version, named
"Extended Key ID for Individually Addressed Frames". This basically
drills down to using key ID 0 and 1 for PTK keys (and shift GTKs to 2
and 3), allowing to rollover PTK keys the same way it has been
established for GTK keys.
Supporting this addition will be the ultimate solution for the issues,
but since it only can be used if both sides are supporting it we still
have to handle PTK only using the key ID 0.

Here a quick overview of the patches in the series:
1) nl80211: Add CAN_REPLACE_PTK0 API
   This adds support for @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0
   to nl80211. We expect the user space (hostap, wpa_supplicant, iwd ...)
   to check this flag and only rekey a connection when this flag is
   present. When the flag is not set a rekey has to be "emulated" by a
   full de-association and a reconnect if it can't be avoided by the
   user space.

2) mac80211: Fix PTK rekey freezes and clear text leak
   This changes how mac80211 handles the rekey. HW keys are now switched
   over to the new key prior to mac80211 for both PTK and GTK. Also the
   driver won't get any frames depending on the key we are replacing
   from mac80211 till the switch to the new key has been completed and
   all running aggregation sessions for the STA are torn down to avoid
   really complex code to making those save during a rekey.
   When a driver is not signaling compliance with the new requirements
   requested for @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 by setting the
   new flag mac80211 will output a rate limited warning and calls the
   optional flush() callback from the driver to increase the chance the
   driver will work correctly.

Version history:
V7 Fix PTK rekey freezes and clear text leaks
   - renamed @NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to
     @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0
   - dropped replace_key() patch, using
     @NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE as replacement
   - updated the "Hardware crypto acceleration" doc
   - updated commits, cover letter and some comments

V6 Fix PTK rekey freezes and clear text leaks
    - typo fix in comment (beeing -> being)

V5 Fix PTK rekey freezes and clear text leaks
    - rewritten most of the cover letter to give a better overview
    - Make "HW installs key prior to mac80211" the default for all
      key installs. (Cleaner, better understandable code.)
    - best-we-can-do approach for drivers not implementing replace_key
      which should work for many drivers.

V4 Fix PTK rekey freezes and clear text leaks
    - Switched over to a small patch series.
    - Allows insecure rekeys again for compatibility
    - Allows the user space to check if rekeys are safe by extending
      nl80211.

V3 mac80211: Fix PTK rekey freezes and clear text leaks
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

Alexander Wetzel (2):
  nl80211: Add CAN_REPLACE_PTK0 API
  mac80211: Fix PTK rekey freezes and clear text leak

 include/net/mac80211.h       |  13 ++++
 include/uapi/linux/nl80211.h |   6 ++
 net/mac80211/key.c           | 118 +++++++++++++++++++++++++++++------
 net/mac80211/tx.c            |   4 ++
 4 files changed, 121 insertions(+), 20 deletions(-)

-- 
2.18.0
