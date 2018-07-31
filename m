Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:56073 "EHLO
        1.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbeGaXI5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 19:08:57 -0400
Received: from player794.ha.ovh.net (unknown [10.109.160.153])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id E0551146BE8
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 22:11:00 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v4 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
Date: Tue, 31 Jul 2018 22:10:28 +0200
Message-Id: <20180731201030.2619-2-alexander@wetzel-home.de> (sfid-20180731_232643_430927_45D7A866)
In-Reply-To: <20180731201030.2619-1-alexander@wetzel-home.de>
References: <20180731201030.2619-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers able to replace a in-use should set
NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to allow the userspace (e.g.
hostapd or wpa_supplicant) to rekey the PTK without a full
disassociation. The userspace must detect a PTK rekey attempt and only
go ahead with the rekey if the driver has set this flag. When the driver
is not supporting the feature the userspace has to perform
a re-association.

Ignoring this flag and continuing to rekey the connection can still
work but has to be considered insecure and broken. It can leak cleartext
packets or freeze the connection and is only supported to allow the
userspace to be updated.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/uapi/linux/nl80211.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..b41b9ade0449 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5224,6 +5224,11 @@ enum nl80211_feature_flags {
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
  *
+ * @NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE: Driver/device confirm that they are
+ *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
+ *      if this flag is not set. Ignoring this can leak clear text packets and/or
+ *      freeze the connection.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5259,6 +5264,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_TXQS,
 	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
+	NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
-- 
2.18.0
