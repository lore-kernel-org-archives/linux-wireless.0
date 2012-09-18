Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1923 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab2IRLU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 07:20:59 -0400
From: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2] cfg80211/nl80211: Notify connection request failure in AP mode
Date: Tue, 18 Sep 2012 16:50:49 +0530
Message-ID: <1347967249-10703-1-git-send-email-c_ppitch@qca.qualcomm.com> (sfid-20120918_132103_382860_686F7D67)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode, when a station requests connection to an AP and if the
request is failed for particular reason, userspace is notified about the
failure through NL80211_CMD_CONN_FAILED command. Reason for the failure
is sent through the attribute NL80211_ATTR_CONN_FAILED_REASON.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
---
 include/linux/nl80211.h |   24 ++++++++++++++++++++++++
 include/net/cfg80211.h  |   19 +++++++++++++++++++
 net/wireless/mlme.c     |   11 +++++++++++
 net/wireless/nl80211.c  |   34 ++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 +++++
 5 files changed, 93 insertions(+)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f38788..fbed6dc 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -565,6 +565,11 @@
  *	%NL80211_ATTR_IFINDEX is now on %NL80211_ATTR_WIPHY_FREQ with
  *	%NL80211_ATTR_WIPHY_CHANNEL_TYPE.
  *
+ * @NL80211_CMD_CONN_FAILED: connection request to an AP failed; used to
+ *	notify userspace that AP has rejected the connection request from a
+ *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
+ *	is used for this.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -708,6 +713,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_NOTIFY,
 
+	NL80211_CMD_CONN_FAILED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1251,6 +1258,10 @@ enum nl80211_commands {
  *	was used to provide the hint. For the different types of
  *	allowed user regulatory hints see nl80211_user_reg_hint_type.
  *
+ * @NL80211_ATTR_CONN_FAILED_REASON: The reason for which AP has rejected
+ *	the connection request from a station. nl80211_connect_failed_reason
+ *	enum has different reasons of connection failure.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1506,6 +1517,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_CONN_FAILED_REASON,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3023,4 +3036,15 @@ enum nl80211_probe_resp_offload_support_attr {
 	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
 };
 
+/**
+ * enum nl80211_connect_failed_reason - connection request failed reasons
+ * @NL80211_CONN_FAIL_MAX_CLIENTS: Maximum number of clients that can be
+ *	handled by the AP is reached.
+ * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Client's MAC is in the AP's blocklist.
+ */
+enum nl80211_connect_failed_reason {
+	NL80211_CONN_FAIL_MAX_CLIENTS,
+	NL80211_CONN_FAIL_BLOCKED_CLIENT,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d254e1..72dff14 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3342,6 +3342,25 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
 
 /**
+ * cfg80211_conn_failed - connection request failed notification
+ *
+ * @dev: the netdev
+ * @mac_addr: the station's address
+ * @reason: the reason for connection failure
+ * @gfp: allocation flags
+ *
+ * Whenever a station tries to connect to an AP and if the station
+ * could not connect to the AP as the AP has rejected the connection
+ * for some reasons, this function is called.
+ *
+ * The reason for connection failure can be any of the value from
+ * nl80211_connect_failed_reason enum
+ */
+void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
+			  enum nl80211_connect_failed_reason reason,
+			  gfp_t gfp);
+
+/**
  * cfg80211_rx_mgmt - notification of received, unprocessed management frame
  * @wdev: wireless device receiving the frame
  * @freq: Frequency on which the frame was received in MHz
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1cdb1d5..7e3eca5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -612,6 +612,17 @@ void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_del_sta);
 
+void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
+			  enum nl80211_connect_failed_reason reason,
+			  gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_conn_failed_event(rdev, dev, mac_addr, reason, gfp);
+}
+EXPORT_SYMBOL(cfg80211_conn_failed);
+
 struct cfg80211_mgmt_registration {
 	struct list_head list;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 97026f3..db06929 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8252,6 +8252,40 @@ void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_send_conn_failed_event(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, const u8 *mac_addr,
+				    enum nl80211_connect_failed_reason reason,
+				    gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CONN_FAILED);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr) ||
+	    nla_put_u32(msg, NL80211_ATTR_CONN_FAILED_REASON, reason))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 static bool __nl80211_unexpected_frame(struct net_device *dev, u8 cmd,
 				       const u8 *addr, gfp_t gfp)
 {
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 9f2616f..f615351 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -91,6 +91,11 @@ void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 				struct net_device *dev, const u8 *mac_addr,
 				gfp_t gfp);
 
+void nl80211_send_conn_failed_event(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, const u8 *mac_addr,
+				    enum nl80211_connect_failed_reason reason,
+				    gfp_t gfp);
+
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, u32 nlpid,
 		      int freq, int sig_dbm,
-- 
1.7.9.5

