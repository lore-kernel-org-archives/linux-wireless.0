Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:62155 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaFKOSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:46 -0400
Received: by mail-wg0-f49.google.com with SMTP id y10so3189050wgg.20
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:45 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/10] mac80211: add API to request TDLS operation from userspace
Date: Wed, 11 Jun 2014 17:18:25 +0300
Message-Id: <1402496307-32522-8-git-send-email-arik@wizery.com> (sfid-20140611_161852_022476_736D909A)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Write a mac80211 to the cfg80211 API for requesting a userspace TDLS
operation. Define TDLS specific reason codes that can be used here.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  3 +++
 include/net/mac80211.h    | 13 +++++++++++++
 net/mac80211/tdls.c       | 17 +++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6bff13f..75d17e1 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1621,6 +1621,9 @@ enum ieee80211_reasoncode {
 	WLAN_REASON_INVALID_RSN_IE_CAP = 22,
 	WLAN_REASON_IEEE8021X_FAILED = 23,
 	WLAN_REASON_CIPHER_SUITE_REJECTED = 24,
+	/* TDLS (802.11z) */
+	WLAN_REASON_TDLS_TEARDOWN_UNREACHABLE = 25,
+	WLAN_REASON_TDLS_TEARDOWN_UNSPECIFIED = 26,
 	/* 802.11e */
 	WLAN_REASON_DISASSOC_UNSPECIFIED_QOS = 32,
 	WLAN_REASON_DISASSOC_QAP_NO_BANDWIDTH = 33,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 421b6ec..8d876dc 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4815,4 +4815,17 @@ int ieee80211_parse_p2p_noa(const struct ieee80211_p2p_noa_attr *attr,
  */
 void ieee80211_update_p2p_noa(struct ieee80211_noa_data *data, u32 tsf);
 
+/**
+ * ieee80211_tdls_oper - request userspace to perform a TDLS operation
+ * @vif: virtual interface
+ * @peer: the peer's destination address
+ * @oper: the requested TDLS operation
+ * @reason_code: reason code for the operation, valid for TDLS teardown
+ * @gfp: allocation flags
+ *
+ * See cfg80211_tdls_oper_request().
+ */
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index da7eb7e..009601a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/ieee80211.h>
+#include <net/cfg80211.h>
 #include "ieee80211_i.h"
 
 /* give usermode some time for retries in setting up the TDLS session */
@@ -516,3 +517,19 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	mutex_unlock(&local->mtx);
 	return ret;
 }
+
+void ieee80211_tdls_oper_request(struct ieee80211_vif *vif, const u8 *peer,
+				 enum nl80211_tdls_operation oper,
+				 u16 reason_code, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (vif->type != NL80211_IFTYPE_STATION || !vif->bss_conf.assoc) {
+		sdata_err(sdata, "Discarding TDLS oper %d - not STA or disconnected\n",
+			  oper);
+		return;
+	}
+
+	cfg80211_tdls_oper_request(sdata->dev, peer, oper, reason_code, gfp);
+}
+EXPORT_SYMBOL(ieee80211_tdls_oper_request);
-- 
1.9.1

