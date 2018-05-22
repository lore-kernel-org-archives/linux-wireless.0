Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:33238 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751269AbeEVITm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:19:42 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>,
        Jithu Jance <jithu.jance@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/3] nl80211: add FILS related parameters to ROAM event
Date: Tue, 22 May 2018 10:19:07 +0200
Message-Id: <1526977148-11600-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180522_101949_194588_1BBFA91D)
In-Reply-To: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of FILS shared key offload the parameters can change
upon roaming of which user-space needs to be notified.

Reviewed-by: Jithu Jance <jithu.jance@broadcom.com>
Reviewed-by: Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 ++-
 net/wireless/nl80211.c       | 16 +++++++++++++--
 net/wireless/sme.c           | 48 +++++++++++++++++++++++++++++++++++++-------
 4 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6d7a668..266d25a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5620,6 +5620,7 @@ void cfg80211_connect_done(struct net_device *dev,
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
+ * @fils: FILS related roaming information.
  */
 struct cfg80211_roam_info {
 	struct ieee80211_channel *channel;
@@ -5629,6 +5630,7 @@ struct cfg80211_roam_info {
 	size_t req_ie_len;
 	const u8 *resp_ie;
 	size_t resp_ie_len;
+	struct cfg80211_fils_resp_params fils;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5e67e34..18fea06 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -215,7 +215,8 @@
  * as specified in IETF RFC 6696.
  *
  * When FILS shared key authentication is completed, driver needs to provide the
- * below additional parameters to userspace.
+ * below additional parameters to userspace, which can be either after setting
+ * up a connection or after roaming.
  *	%NL80211_ATTR_FILS_KEK - used for key renewal
  *	%NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM - used in further EAP-RP exchanges
  *	%NL80211_ATTR_PMKID - used to identify the PMKSA used/generated
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1bf2c3b..66be69f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14255,7 +14255,9 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 	void *hdr;
 	const u8 *bssid = info->bss ? info->bss->bssid : info->bssid;
 
-	msg = nlmsg_new(100 + info->req_ie_len + info->resp_ie_len, gfp);
+	msg = nlmsg_new(100 + info->req_ie_len + info->resp_ie_len +
+			info->fils.kek_len + info->fils.pmk_len +
+			(info->fils.pmkid ? WLAN_PMKID_LEN : 0), gfp);
 	if (!msg)
 		return;
 
@@ -14273,7 +14275,17 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 		     info->req_ie)) ||
 	    (info->resp_ie &&
 	     nla_put(msg, NL80211_ATTR_RESP_IE, info->resp_ie_len,
-		     info->resp_ie)))
+		     info->resp_ie)) ||
+	    (info->fils.update_erp_next_seq_num &&
+	     nla_put_u16(msg, NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM,
+			 info->fils.erp_next_seq_num)) ||
+	    (info->fils.kek &&
+	     nla_put(msg, NL80211_ATTR_FILS_KEK, info->fils.kek_len,
+		     info->fils.kek)) ||
+	    (info->fils.pmk &&
+	     nla_put(msg, NL80211_ATTR_PMK, info->fils.pmk_len, info->fils.pmk)) ||
+	    (info->fils.pmkid &&
+	     nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, info->fils.pmkid)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 73881fb..d536b07 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -932,6 +932,7 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
+	u8 *next;
 
 	if (!info->bss) {
 		info->bss = cfg80211_get_bss(wdev->wiphy, info->channel,
@@ -944,19 +945,52 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 	if (WARN_ON(!info->bss))
 		return;
 
-	ev = kzalloc(sizeof(*ev) + info->req_ie_len + info->resp_ie_len, gfp);
+	ev = kzalloc(sizeof(*ev) + info->req_ie_len + info->resp_ie_len +
+		     info->fils.kek_len + info->fils.pmk_len +
+		     (info->fils.pmkid ? WLAN_PMKID_LEN : 0), gfp);
 	if (!ev) {
 		cfg80211_put_bss(wdev->wiphy, info->bss);
 		return;
 	}
 
 	ev->type = EVENT_ROAMED;
-	ev->rm.req_ie = ((u8 *)ev) + sizeof(*ev);
-	ev->rm.req_ie_len = info->req_ie_len;
-	memcpy((void *)ev->rm.req_ie, info->req_ie, info->req_ie_len);
-	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + info->req_ie_len;
-	ev->rm.resp_ie_len = info->resp_ie_len;
-	memcpy((void *)ev->rm.resp_ie, info->resp_ie, info->resp_ie_len);
+	next = ((u8 *)ev) + sizeof(*ev);
+	if (info->req_ie_len) {
+		ev->rm.req_ie = next;
+		ev->rm.req_ie_len = info->req_ie_len;
+		memcpy((void *)ev->rm.req_ie, info->req_ie, info->req_ie_len);
+		next += info->req_ie_len;
+	}
+	if (info->resp_ie_len) {
+		ev->rm.resp_ie = next;
+		ev->rm.resp_ie_len = info->resp_ie_len;
+		memcpy((void *)ev->rm.resp_ie, info->resp_ie,
+		       info->resp_ie_len);
+		next += info->resp_ie_len;
+	}
+	if (info->fils.kek_len) {
+		ev->rm.fils.kek = next;
+		ev->rm.fils.kek_len = info->fils.kek_len;
+		memcpy((void *)ev->rm.fils.kek, info->fils.kek,
+		       info->fils.kek_len);
+		next += info->fils.kek_len;
+	}
+	if (info->fils.pmk_len) {
+		ev->rm.fils.pmk = next;
+		ev->rm.fils.pmk_len = info->fils.pmk_len;
+		memcpy((void *)ev->rm.fils.pmk, info->fils.pmk,
+		       info->fils.pmk_len);
+		next += info->fils.pmk_len;
+	}
+	if (info->fils.pmkid) {
+		ev->rm.fils.pmkid = next;
+		memcpy((void *)ev->rm.fils.pmkid, info->fils.pmkid,
+		       WLAN_PMKID_LEN);
+		next += WLAN_PMKID_LEN;
+	}
+	ev->rm.fils.update_erp_next_seq_num = info->fils.update_erp_next_seq_num;
+	if (info->fils.update_erp_next_seq_num)
+		ev->rm.fils.erp_next_seq_num = info->fils.erp_next_seq_num;
 	ev->rm.bss = info->bss;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
-- 
1.9.1
