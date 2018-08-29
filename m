Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 19.mo5.mail-out.ovh.net ([46.105.35.78]:46011 "EHLO
        19.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbeH2Ujs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 16:39:48 -0400
Received: from player756.ha.ovh.net (unknown [10.109.146.106])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id ACD8B1E0CA5
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 18:35:31 +0200 (CEST)
From: Alexander Wetzel <alexander@wetzel-home.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, denkenz@gmail.com,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v7 1/2] nl80211: Add CAN_REPLACE_PTK0 API
Date: Wed, 29 Aug 2018 18:34:51 +0200
Message-Id: <20180829163452.32666-2-alexander@wetzel-home.de> (sfid-20180829_184206_037266_667A4B8E)
In-Reply-To: <20180829163452.32666-1-alexander@wetzel-home.de>
References: <20180829163452.32666-1-alexander@wetzel-home.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers able to correctly replace a in-use key should set
@NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 to allow the user space (e.g.
hostapd or wpa_supplicant) to rekey PTK keys.

The user space must detect a PTK rekey attempt and only go ahead with it
when the driver has set this flag. If the driver is not supporting the
feature the user space either must not replace the PTK key or perform a
full re-association instead.

Ignoring this flag and continuing to rekey the connection can still work
but has to be considered insecure and broken. Depending on the driver it
can leak clear text packets or freeze the connection and is only
supported to allow the user space to be updated.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Reviewed-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 7acc16f34942..cf238064d8ab 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5224,6 +5224,11 @@ enum nl80211_feature_flags {
  *	except for supported rates from the probe request content if requested
  *	by the %NL80211_SCAN_FLAG_MIN_PREQ_CONTENT flag.
  *
+ * @NL80211_EXT_FEATURE_CAN_REPLACE_PTK0: Driver/device confirm that they are
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
+	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
-- 
2.18.0
