Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13940 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938989AbdAIRyD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 12:54:03 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/3] cfg80211: Specify the reason for connect timeout
Date: Mon, 9 Jan 2017 19:53:08 +0200
Message-ID: <1483984388-30237-3-git-send-email-jouni@qca.qualcomm.com> (sfid-20170109_185416_218092_1A154922)
In-Reply-To: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>

This enhances the connect timeout API to also carry the reason for the
timeout. These reason codes for the connect time out are represented by
enum nl80211_timeout_reason and are passed to user space through a new
attribute NL80211_ATTR_TIMEOUT_REASON (u32).

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 15 +++++++++++----
 include/uapi/linux/nl80211.h | 21 +++++++++++++++++++++
 net/wireless/core.h          |  4 +++-
 net/wireless/mlme.c          |  3 ++-
 net/wireless/nl80211.c       |  8 ++++++--
 net/wireless/nl80211.h       |  3 ++-
 net/wireless/sme.c           | 33 ++++++++++++++++++++++++---------
 net/wireless/util.c          |  2 +-
 8 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9dc11d3..44277fe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5090,6 +5090,9 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  *      %WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
  *      the real status code for failures.
  * @gfp: allocation flags
+ * @timeout_reason: reason for connection timeout. This is used when the
+ *	connection fails due to a timeout instead of an explicit rejection from
+ *	the AP. 0 (NL80211_CONNECT_TIMEOUT_UNSPECIFIED) is used for other cases.
  *
  * It should be called by the underlying driver whenever connect() has
  * succeeded. This is similar to cfg80211_connect_result(), but with the
@@ -5099,7 +5102,8 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 			  struct cfg80211_bss *bss, const u8 *req_ie,
 			  size_t req_ie_len, const u8 *resp_ie,
-			  size_t resp_ie_len, int status, gfp_t gfp);
+			  size_t resp_ie_len, int status, gfp_t gfp,
+			  enum nl80211_timeout_reason timeout_reason);
 
 /**
  * cfg80211_connect_result - notify cfg80211 of connection result
@@ -5125,7 +5129,8 @@ cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			u16 status, gfp_t gfp)
 {
 	cfg80211_connect_bss(dev, bssid, NULL, req_ie, req_ie_len, resp_ie,
-			     resp_ie_len, status, gfp);
+			     resp_ie_len, status, gfp,
+			     NL80211_TIMEOUT_UNSPECIFIED);
 }
 
 /**
@@ -5136,6 +5141,7 @@ cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
  * @req_ie: association request IEs (maybe be %NULL)
  * @req_ie_len: association request IEs length
  * @gfp: allocation flags
+ * @timeout_reason: reason for connection timeout.
  *
  * It should be called by the underlying driver whenever connect() has failed
  * in a sequence where no explicit authentication/association rejection was
@@ -5145,10 +5151,11 @@ cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
  */
 static inline void
 cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
-			 const u8 *req_ie, size_t req_ie_len, gfp_t gfp)
+			 const u8 *req_ie, size_t req_ie_len, gfp_t gfp,
+			 enum nl80211_timeout_reason timeout_reason)
 {
 	cfg80211_connect_bss(dev, bssid, NULL, req_ie, req_ie_len, NULL, 0, -1,
-			     gfp);
+			     gfp, timeout_reason);
 }
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ebed28e..aa008f0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1995,6 +1995,10 @@ enum nl80211_commands {
  *	better BSSs. The attribute value is a packed structure
  *	value as specified by &struct nl80211_bss_select_rssi_adjust.
  *
+ * @NL80211_ATTR_TIMEOUT_REASON: The reason for which an operation timed out.
+ *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
+ *	e.g., with %NL80211_CMD_CONNECT event.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2404,6 +2408,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST,
 
+	NL80211_ATTR_TIMEOUT_REASON,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4788,6 +4794,21 @@ enum nl80211_connect_failed_reason {
 };
 
 /**
+ * enum nl80211_timeout_reason - timeout reasons
+ *
+ * @NL80211_TIMEOUT_UNSPECIFIED: Timeout reason unspecified.
+ * @NL80211_TIMEOUT_SCAN: Scan (AP discovery) timed out.
+ * @NL80211_TIMEOUT_AUTH: Authentication timed out.
+ * @NL80211_TIMEOUT_ASSOC: Association timed out.
+ */
+enum nl80211_timeout_reason {
+	NL80211_TIMEOUT_UNSPECIFIED,
+	NL80211_TIMEOUT_SCAN,
+	NL80211_TIMEOUT_AUTH,
+	NL80211_TIMEOUT_ASSOC,
+};
+
+/**
  * enum nl80211_scan_flags -  scan request control flags
  *
  * Scan request control flags are used to control the handling
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ba42055..58ca206 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -228,6 +228,7 @@ struct cfg80211_event {
 			size_t resp_ie_len;
 			struct cfg80211_bss *bss;
 			int status; /* -1 = failed; 0..65535 = status code */
+			enum nl80211_timeout_reason timeout_reason;
 		} cr;
 		struct {
 			const u8 *req_ie;
@@ -388,7 +389,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
 			       int status, bool wextev,
-			       struct cfg80211_bss *bss);
+			       struct cfg80211_bss *bss,
+			       enum nl80211_timeout_reason timeout_reason);
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap);
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index b876f40..22b3d99 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -48,7 +48,8 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				  status_code,
-				  status_code == WLAN_STATUS_SUCCESS, bss);
+				  status_code == WLAN_STATUS_SUCCESS, bss,
+				  NL80211_TIMEOUT_UNSPECIFIED);
 }
 EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bb3f04a..64d77e3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -409,6 +409,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST] = {
 		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
 	},
+	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -13232,7 +13233,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *bssid,
 				 const u8 *req_ie, size_t req_ie_len,
 				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status, gfp_t gfp)
+				 int status, gfp_t gfp,
+				 enum nl80211_timeout_reason timeout_reason)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -13253,7 +13255,9 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	    nla_put_u16(msg, NL80211_ATTR_STATUS_CODE,
 			status < 0 ? WLAN_STATUS_UNSPECIFIED_FAILURE :
 			status) ||
-	    (status < 0 && nla_put_flag(msg, NL80211_ATTR_TIMED_OUT)) ||
+	    (status < 0 &&
+	     (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
+	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON, timeout_reason))) ||
 	    (req_ie &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, req_ie_len, req_ie)) ||
 	    (resp_ie &&
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 75f8252..633b3eb 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -56,7 +56,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *bssid,
 				 const u8 *req_ie, size_t req_ie_len,
 				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status, gfp_t gfp);
+				 int status, gfp_t gfp,
+				 enum nl80211_timeout_reason timeout_reason);
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev, const u8 *bssid,
 			 const u8 *req_ie, size_t req_ie_len,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 4669391..472225d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -38,6 +38,7 @@ struct cfg80211_conn {
 		CFG80211_CONN_ASSOCIATE_NEXT,
 		CFG80211_CONN_ASSOCIATING,
 		CFG80211_CONN_ASSOC_FAILED,
+		CFG80211_CONN_ASSOC_FAILED_TIMEOUT,
 		CFG80211_CONN_DEAUTH,
 		CFG80211_CONN_ABANDON,
 		CFG80211_CONN_CONNECTED,
@@ -140,7 +141,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	return err;
 }
 
-static int cfg80211_conn_do_work(struct wireless_dev *wdev)
+static int cfg80211_conn_do_work(struct wireless_dev *wdev,
+				 enum nl80211_timeout_reason *treason)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
@@ -172,6 +174,7 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					  params->key, params->key_len,
 					  params->key_idx, NULL, 0);
 	case CFG80211_CONN_AUTH_FAILED:
+		*treason = NL80211_TIMEOUT_AUTH;
 		return -ENOTCONN;
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		if (WARN_ON(!rdev->ops->assoc))
@@ -198,6 +201,9 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					     WLAN_REASON_DEAUTH_LEAVING,
 					     false);
 		return err;
+	case CFG80211_CONN_ASSOC_FAILED_TIMEOUT:
+		*treason = NL80211_TIMEOUT_ASSOC;
+		/* fall through */
 	case CFG80211_CONN_ASSOC_FAILED:
 		cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 				     NULL, 0,
@@ -223,6 +229,7 @@ void cfg80211_conn_work(struct work_struct *work)
 		container_of(work, struct cfg80211_registered_device, conn_work);
 	struct wireless_dev *wdev;
 	u8 bssid_buf[ETH_ALEN], *bssid = NULL;
+	enum nl80211_timeout_reason treason;
 
 	rtnl_lock();
 
@@ -244,10 +251,12 @@ void cfg80211_conn_work(struct work_struct *work)
 			memcpy(bssid_buf, wdev->conn->params.bssid, ETH_ALEN);
 			bssid = bssid_buf;
 		}
-		if (cfg80211_conn_do_work(wdev)) {
+		treason = NL80211_TIMEOUT_UNSPECIFIED;
+		if (cfg80211_conn_do_work(wdev, &treason)) {
 			__cfg80211_connect_result(
 					wdev->netdev, bssid,
-					NULL, 0, NULL, 0, -1, false, NULL);
+					NULL, 0, NULL, 0, -1, false, NULL,
+					treason);
 		}
 		wdev_unlock(wdev);
 	}
@@ -352,7 +361,8 @@ void cfg80211_sme_rx_auth(struct wireless_dev *wdev, const u8 *buf, size_t len)
 	} else if (status_code != WLAN_STATUS_SUCCESS) {
 		__cfg80211_connect_result(wdev->netdev, mgmt->bssid,
 					  NULL, 0, NULL, 0,
-					  status_code, false, NULL);
+					  status_code, false, NULL,
+					  NL80211_TIMEOUT_UNSPECIFIED);
 	} else if (wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
 		schedule_work(&rdev->conn_work);
@@ -422,7 +432,7 @@ void cfg80211_sme_assoc_timeout(struct wireless_dev *wdev)
 	if (!wdev->conn)
 		return;
 
-	wdev->conn->state = CFG80211_CONN_ASSOC_FAILED;
+	wdev->conn->state = CFG80211_CONN_ASSOC_FAILED_TIMEOUT;
 	schedule_work(&rdev->conn_work);
 }
 
@@ -564,7 +574,9 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 
 	/* we're good if we have a matching bss struct */
 	if (bss) {
-		err = cfg80211_conn_do_work(wdev);
+		enum nl80211_timeout_reason treason;
+
+		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
 		/* otherwise we'll need to scan for the AP first */
@@ -661,7 +673,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
 			       int status, bool wextev,
-			       struct cfg80211_bss *bss)
+			       struct cfg80211_bss *bss,
+			       enum nl80211_timeout_reason timeout_reason)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const u8 *country_ie;
@@ -680,7 +693,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
 				    resp_ie, resp_ie_len,
-				    status, GFP_KERNEL);
+				    status, GFP_KERNEL, timeout_reason);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wextev) {
@@ -771,7 +784,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 			  struct cfg80211_bss *bss, const u8 *req_ie,
 			  size_t req_ie_len, const u8 *resp_ie,
-			  size_t resp_ie_len, int status, gfp_t gfp)
+			  size_t resp_ie_len, int status, gfp_t gfp,
+			  enum nl80211_timeout_reason timeout_reason)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -811,6 +825,7 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 		cfg80211_hold_bss(bss_from_pub(bss));
 	ev->cr.bss = bss;
 	ev->cr.status = status;
+	ev->cr.timeout_reason = timeout_reason;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index cd8a7ae..1b92968 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -951,7 +951,7 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 				ev->cr.resp_ie, ev->cr.resp_ie_len,
 				ev->cr.status,
 				ev->cr.status == WLAN_STATUS_SUCCESS,
-				ev->cr.bss);
+				ev->cr.bss, ev->cr.timeout_reason);
 			break;
 		case EVENT_ROAMED:
 			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
-- 
2.7.4
