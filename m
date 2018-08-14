Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo179.mail-out.ovh.net ([178.33.251.175]:60376 "EHLO
        3.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbeHNNaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 09:30:10 -0400
Received: from player694.ha.ovh.net (unknown [10.109.160.253])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id B5348E1AB5
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 12:43:32 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
Date: Tue, 14 Aug 2018 12:42:53 +0200
Message-Id: <20180814104255.4183-2-alexander@wetzel-home.de> (sfid-20180814_124337_154275_B6D40AB7)
In-Reply-To: <20180814104255.4183-1-alexander@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers able to correctly replace a in-use key should set
NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to allow the userspace (e.g.
hostapd or wpa_supplicant) to rekey PTK keys.

The userspace must detect a PTK rekey attempt and only go ahead with the
rekey when the driver has set this flag. If the driver is not supporting
the feature the userspace either must not replace the PTK key or perform
a full re-association.

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
