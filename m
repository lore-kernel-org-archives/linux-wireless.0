Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo6.mail-out.ovh.net ([178.33.253.26]:49617 "EHLO
        3.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729315AbeGaXMo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 19:12:44 -0400
Received: from player714.ha.ovh.net (unknown [10.109.143.146])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id CD7B41710EA
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 22:11:01 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v4 0/3] Fix PTK rekey freezes and cleartext leaks
Date: Tue, 31 Jul 2018 22:10:27 +0200
Message-Id: <20180731201030.2619-1-alexander@wetzel-home.de> (sfid-20180731_233033_877049_C9E65D04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do not see an acceptable way from the kernel to trigger a fast
reconnect. wpa_supplicant e.g. has some special code handling errors
during a 4-way-handshake differently. I assume we would have to add
code detecting if we are running as AP, Station Infrastructure, Ad-Hoc
or Mesh and then find and spoof an error which allows the userspace to
reconnect fast. For multiple different userspace implementations and
the different versions of them.
And we'll have that mess in the kernel for basically forever...
Seems to be a clear no go, correct?

So this patch (series) is giving up on a quick fix and will allow broken
rekeys to continue. It is instead providing an updated API for both the
userspace and the drivers to also do it correctly. Users running a
userspace not aware of the new API will get some improvements but may
still leak cleartext packets and have connection freezes till we get an
updated userspace rolled out. On the plus side users running updated
userspace won't be able to rekey connections any longer, avoiding the
issues even with unpatched kernels.

Since the new approach now also touches nl80211 I've now broken it down
into a small patch series.
The first two patches are just laying some ground work with all the
magic happening in the last patch, which also best describes what we
want to achieve in its commit message. The commit messages of the first
two are mainly outlining how the new APIs should be used.

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
   connection freezes till  they do not either disable rekey or upgrade
   the userspace. (There is currently no updated userspace available.)

Version history:
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

 include/net/mac80211.h       |  15 +++++
 include/uapi/linux/nl80211.h |   6 ++
 net/mac80211/driver-ops.h    |  20 ++++++
 net/mac80211/key.c           | 123 ++++++++++++++++++++++++++++++-----
 net/mac80211/main.c          |   5 ++
 net/mac80211/trace.h         |  39 +++++++++++
 net/mac80211/tx.c            |   4 ++
 7 files changed, 195 insertions(+), 17 deletions(-)

-- 
2.18.0
