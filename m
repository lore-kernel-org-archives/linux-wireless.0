Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:33256 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbeEVITo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:19:44 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>,
        Jithu Jance <jithu.jance@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 1/3] cfg80211: use separate struct for fils parameters
Date: Tue, 22 May 2018 10:19:06 +0200
Message-Id: <1526977148-11600-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180522_101954_834399_4B0242F8)
In-Reply-To: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Put FILS related parameters into their own struct definition so
it can be reused for roam events in subsequent change.

Reviewed-by: Jithu Jance <jithu.jance@broadcom.com>
Reviewed-by: Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h | 44 ++++++++++++++++++++++++++------------------
 net/wireless/nl80211.c | 22 +++++++++++-----------
 net/wireless/sme.c     | 40 +++++++++++++++++++++-------------------
 3 files changed, 58 insertions(+), 48 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 11a2184..6d7a668 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5417,6 +5417,30 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 #endif
 
 /**
+ * struct cfg80211_fils_resp_params - FILS connection response params
+ * @kek: KEK derived from a successful FILS connection (may be %NULL)
+ * @kek_len: Length of @fils_kek in octets
+ * @update_erp_next_seq_num: Boolean value to specify whether the value in
+ *	@erp_next_seq_num is valid.
+ * @erp_next_seq_num: The next sequence number to use in ERP message in
+ *	FILS Authentication. This value should be specified irrespective of the
+ *	status for a FILS connection.
+ * @pmk: A new PMK if derived from a successful FILS connection (may be %NULL).
+ * @pmk_len: Length of @pmk in octets
+ * @pmkid: A new PMKID if derived from a successful FILS connection or the PMKID
+ *	used for this FILS connection (may be %NULL).
+ */
+struct cfg80211_fils_resp_params {
+	const u8 *kek;
+	size_t kek_len;
+	bool update_erp_next_seq_num;
+	u16 erp_next_seq_num;
+	const u8 *pmk;
+	size_t pmk_len;
+	const u8 *pmkid;
+};
+
+/**
  * struct cfg80211_connect_resp_params - Connection response params
  * @status: Status code, %WLAN_STATUS_SUCCESS for successful connection, use
  *	%WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
@@ -5434,17 +5458,7 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  * @req_ie_len: Association request IEs length
  * @resp_ie: Association response IEs (may be %NULL)
  * @resp_ie_len: Association response IEs length
- * @fils_kek: KEK derived from a successful FILS connection (may be %NULL)
- * @fils_kek_len: Length of @fils_kek in octets
- * @update_erp_next_seq_num: Boolean value to specify whether the value in
- *	@fils_erp_next_seq_num is valid.
- * @fils_erp_next_seq_num: The next sequence number to use in ERP message in
- *	FILS Authentication. This value should be specified irrespective of the
- *	status for a FILS connection.
- * @pmk: A new PMK if derived from a successful FILS connection (may be %NULL).
- * @pmk_len: Length of @pmk in octets
- * @pmkid: A new PMKID if derived from a successful FILS connection or the PMKID
- *	used for this FILS connection (may be %NULL).
+ * @fils: FILS connection response parameters.
  * @timeout_reason: Reason for connection timeout. This is used when the
  *	connection fails due to a timeout instead of an explicit rejection from
  *	the AP. %NL80211_TIMEOUT_UNSPECIFIED is used when the timeout reason is
@@ -5460,13 +5474,7 @@ struct cfg80211_connect_resp_params {
 	size_t req_ie_len;
 	const u8 *resp_ie;
 	size_t resp_ie_len;
-	const u8 *fils_kek;
-	size_t fils_kek_len;
-	bool update_erp_next_seq_num;
-	u16 fils_erp_next_seq_num;
-	const u8 *pmk;
-	size_t pmk_len;
-	const u8 *pmkid;
+	struct cfg80211_fils_resp_params fils;
 	enum nl80211_timeout_reason timeout_reason;
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 462e028..1bf2c3b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14197,8 +14197,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	void *hdr;
 
 	msg = nlmsg_new(100 + cr->req_ie_len + cr->resp_ie_len +
-			cr->fils_kek_len + cr->pmk_len +
-			(cr->pmkid ? WLAN_PMKID_LEN : 0), gfp);
+			cr->fils.kek_len + cr->fils.pmk_len +
+			(cr->fils.pmkid ? WLAN_PMKID_LEN : 0), gfp);
 	if (!msg)
 		return;
 
@@ -14224,17 +14224,17 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	    (cr->resp_ie &&
 	     nla_put(msg, NL80211_ATTR_RESP_IE, cr->resp_ie_len,
 		     cr->resp_ie)) ||
-	    (cr->update_erp_next_seq_num &&
+	    (cr->fils.update_erp_next_seq_num &&
 	     nla_put_u16(msg, NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM,
-			 cr->fils_erp_next_seq_num)) ||
+			 cr->fils.erp_next_seq_num)) ||
 	    (cr->status == WLAN_STATUS_SUCCESS &&
-	     ((cr->fils_kek &&
-	       nla_put(msg, NL80211_ATTR_FILS_KEK, cr->fils_kek_len,
-		       cr->fils_kek)) ||
-	      (cr->pmk &&
-	       nla_put(msg, NL80211_ATTR_PMK, cr->pmk_len, cr->pmk)) ||
-	      (cr->pmkid &&
-	       nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, cr->pmkid)))))
+	     ((cr->fils.kek &&
+	       nla_put(msg, NL80211_ATTR_FILS_KEK, cr->fils.kek_len,
+		       cr->fils.kek)) ||
+	      (cr->fils.pmk &&
+	       nla_put(msg, NL80211_ATTR_PMK, cr->fils.pmk_len, cr->fils.pmk)) ||
+	      (cr->fils.pmkid &&
+	       nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, cr->fils.pmkid)))))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 5df6b33..73881fb 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -803,8 +803,8 @@ void cfg80211_connect_done(struct net_device *dev,
 
 	ev = kzalloc(sizeof(*ev) + (params->bssid ? ETH_ALEN : 0) +
 		     params->req_ie_len + params->resp_ie_len +
-		     params->fils_kek_len + params->pmk_len +
-		     (params->pmkid ? WLAN_PMKID_LEN : 0), gfp);
+		     params->fils.kek_len + params->fils.pmk_len +
+		     (params->fils.pmkid ? WLAN_PMKID_LEN : 0), gfp);
 	if (!ev) {
 		cfg80211_put_bss(wdev->wiphy, params->bss);
 		return;
@@ -831,27 +831,29 @@ void cfg80211_connect_done(struct net_device *dev,
 		       params->resp_ie_len);
 		next += params->resp_ie_len;
 	}
-	if (params->fils_kek_len) {
-		ev->cr.fils_kek = next;
-		ev->cr.fils_kek_len = params->fils_kek_len;
-		memcpy((void *)ev->cr.fils_kek, params->fils_kek,
-		       params->fils_kek_len);
-		next += params->fils_kek_len;
+	if (params->fils.kek_len) {
+		ev->cr.fils.kek = next;
+		ev->cr.fils.kek_len = params->fils.kek_len;
+		memcpy((void *)ev->cr.fils.kek, params->fils.kek,
+		       params->fils.kek_len);
+		next += params->fils.kek_len;
 	}
-	if (params->pmk_len) {
-		ev->cr.pmk = next;
-		ev->cr.pmk_len = params->pmk_len;
-		memcpy((void *)ev->cr.pmk, params->pmk, params->pmk_len);
-		next += params->pmk_len;
+	if (params->fils.pmk_len) {
+		ev->cr.fils.pmk = next;
+		ev->cr.fils.pmk_len = params->fils.pmk_len;
+		memcpy((void *)ev->cr.fils.pmk, params->fils.pmk,
+		       params->fils.pmk_len);
+		next += params->fils.pmk_len;
 	}
-	if (params->pmkid) {
-		ev->cr.pmkid = next;
-		memcpy((void *)ev->cr.pmkid, params->pmkid, WLAN_PMKID_LEN);
+	if (params->fils.pmkid) {
+		ev->cr.fils.pmkid = next;
+		memcpy((void *)ev->cr.fils.pmkid, params->fils.pmkid,
+		       WLAN_PMKID_LEN);
 		next += WLAN_PMKID_LEN;
 	}
-	ev->cr.update_erp_next_seq_num = params->update_erp_next_seq_num;
-	if (params->update_erp_next_seq_num)
-		ev->cr.fils_erp_next_seq_num = params->fils_erp_next_seq_num;
+	ev->cr.fils.update_erp_next_seq_num = params->fils.update_erp_next_seq_num;
+	if (params->fils.update_erp_next_seq_num)
+		ev->cr.fils.erp_next_seq_num = params->fils.erp_next_seq_num;
 	if (params->bss)
 		cfg80211_hold_bss(bss_from_pub(params->bss));
 	ev->cr.bss = params->bss;
-- 
1.9.1
