Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2107 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1L3J5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 04:57:11 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH] ath6kl: send TCMD response through testmode events
Date: Fri, 30 Dec 2011 01:57:00 -0800
Message-ID: <1325239020-6698-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20111230_105715_867933_4B5C3297)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <twpedersen@qca.qualcomm.com>

ath6kl no longer knows what it is transmitting through
cfg80211_testmode, and simply passes opaque buffers between userspace
and the firmware. Leave the CONT_RX enum for backwards compatibility.

Signed-off-by: Thomas Pedersen <twpedersen@qca.qualcomm.com>

v2:
	ath6kl_warn not _dbg, GFP_KERNEL, and misc. (Kalle)
---
 drivers/net/wireless/ath/ath6kl/testmode.c |  104 +++++-----------------------
 drivers/net/wireless/ath/ath6kl/testmode.h |    6 +-
 drivers/net/wireless/ath/ath6kl/wmi.c      |    6 +-
 3 files changed, 24 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/testmode.c b/drivers/net/wireless/ath/ath6kl/testmode.c
index 381eb66..b6e6a2a 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.c
+++ b/drivers/net/wireless/ath/ath6kl/testmode.c
@@ -15,6 +15,7 @@
  */
 
 #include "testmode.h"
+#include "debug.h"
 
 #include <net/netlink.h>
 
@@ -30,7 +31,7 @@ enum ath6kl_tm_attr {
 
 enum ath6kl_tm_cmd {
 	ATH6KL_TM_CMD_TCMD		= 0,
-	ATH6KL_TM_CMD_RX_REPORT		= 1,
+	ATH6KL_TM_CMD_RX_REPORT		= 1,	/* deprecated */
 };
 
 #define ATH6KL_TM_DATA_MAX_LEN		5000
@@ -41,84 +42,33 @@ static const struct nla_policy ath6kl_tm_policy[ATH6KL_TM_ATTR_MAX + 1] = {
 					    .len = ATH6KL_TM_DATA_MAX_LEN },
 };
 
-void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len)
+void ath6kl_tm_rx_event(struct ath6kl *ar, void *buf, size_t buf_len)
 {
-	if (down_interruptible(&ar->sem))
-		return;
-
-	kfree(ar->tm.rx_report);
-
-	ar->tm.rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
-	ar->tm.rx_report_len = buf_len;
-
-	up(&ar->sem);
-
-	wake_up(&ar->event_wq);
-}
-
-static int ath6kl_tm_rx_report(struct ath6kl *ar, void *buf, size_t buf_len,
-			       struct sk_buff *skb)
-{
-	int ret = 0;
-	long left;
-
-	if (down_interruptible(&ar->sem))
-		return -ERESTARTSYS;
-
-	if (!test_bit(WMI_READY, &ar->flag)) {
-		ret = -EIO;
-		goto out;
-	}
-
-	if (test_bit(DESTROY_IN_PROGRESS, &ar->flag)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	if (ath6kl_wmi_test_cmd(ar->wmi, buf, buf_len) < 0) {
-		up(&ar->sem);
-		return -EIO;
-	}
-
-	left = wait_event_interruptible_timeout(ar->event_wq,
-						ar->tm.rx_report != NULL,
-						WMI_TIMEOUT);
+	struct sk_buff *skb;
 
-	if (left == 0) {
-		ret = -ETIMEDOUT;
-		goto out;
-	} else if (left < 0) {
-		ret = left;
-		goto out;
-	}
+	if (!buf || buf_len == 0)
+		return;
 
-	if (ar->tm.rx_report == NULL || ar->tm.rx_report_len == 0) {
-		ret = -EINVAL;
-		goto out;
+	skb = cfg80211_testmode_alloc_event_skb(ar->wiphy, buf_len, GFP_KERNEL);
+	if (!skb) {
+		ath6kl_warn("failed to allocate testmode rx skb!\n");
+		return;
 	}
-
-	NLA_PUT(skb, ATH6KL_TM_ATTR_DATA, ar->tm.rx_report_len,
-		ar->tm.rx_report);
-
-	kfree(ar->tm.rx_report);
-	ar->tm.rx_report = NULL;
-
-out:
-	up(&ar->sem);
-
-	return ret;
+	NLA_PUT_U32(skb, ATH6KL_TM_ATTR_CMD, ATH6KL_TM_CMD_TCMD);
+	NLA_PUT(skb, ATH6KL_TM_ATTR_DATA, buf_len, buf);
+	cfg80211_testmode_event(skb, GFP_KERNEL);
+	return;
 
 nla_put_failure:
-	ret = -ENOBUFS;
-	goto out;
+	kfree_skb(skb);
+	ath6kl_warn("nla_put failed on testmode rx skb!\n");
 }
 
 int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
 {
 	struct ath6kl *ar = wiphy_priv(wiphy);
 	struct nlattr *tb[ATH6KL_TM_ATTR_MAX + 1];
-	int err, buf_len, reply_len;
-	struct sk_buff *skb;
+	int err, buf_len;
 	void *buf;
 
 	err = nla_parse(tb, ATH6KL_TM_ATTR_MAX, data, len,
@@ -131,6 +81,7 @@ int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
 
 	switch (nla_get_u32(tb[ATH6KL_TM_ATTR_CMD])) {
 	case ATH6KL_TM_CMD_TCMD:
+	case ATH6KL_TM_CMD_RX_REPORT:
 		if (!tb[ATH6KL_TM_ATTR_DATA])
 			return -EINVAL;
 
@@ -142,25 +93,6 @@ int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len)
 		return 0;
 
 		break;
-	case ATH6KL_TM_CMD_RX_REPORT:
-		if (!tb[ATH6KL_TM_ATTR_DATA])
-			return -EINVAL;
-
-		buf = nla_data(tb[ATH6KL_TM_ATTR_DATA]);
-		buf_len = nla_len(tb[ATH6KL_TM_ATTR_DATA]);
-
-		reply_len = nla_total_size(ATH6KL_TM_DATA_MAX_LEN);
-		skb = cfg80211_testmode_alloc_reply_skb(wiphy, reply_len);
-		if (!skb)
-			return -ENOMEM;
-
-		err = ath6kl_tm_rx_report(ar, buf, buf_len, skb);
-		if (err < 0) {
-			kfree_skb(skb);
-			return err;
-		}
-
-		return cfg80211_testmode_reply(skb);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/testmode.h b/drivers/net/wireless/ath/ath6kl/testmode.h
index 43dffcc..7fd47a6 100644
--- a/drivers/net/wireless/ath/ath6kl/testmode.h
+++ b/drivers/net/wireless/ath/ath6kl/testmode.h
@@ -18,13 +18,13 @@
 
 #ifdef CONFIG_NL80211_TESTMODE
 
-void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf, size_t buf_len);
+void ath6kl_tm_rx_event(struct ath6kl *ar, void *buf, size_t buf_len);
 int ath6kl_tm_cmd(struct wiphy *wiphy, void *data, int len);
 
 #else
 
-static inline void ath6kl_tm_rx_report_event(struct ath6kl *ar, void *buf,
-					     size_t buf_len)
+static inline void ath6kl_tm_rx_event(struct ath6kl *ar, void *buf,
+				      size_t buf_len)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 1e31c38..c6ca660 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1145,9 +1145,9 @@ static int ath6kl_wmi_bitrate_reply_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
-static int ath6kl_wmi_tcmd_test_report_rx(struct wmi *wmi, u8 *datap, int len)
+static int ath6kl_wmi_test_rx(struct wmi *wmi, u8 *datap, int len)
 {
-	ath6kl_tm_rx_report_event(wmi->parent_dev, datap, len);
+	ath6kl_tm_rx_event(wmi->parent_dev, datap, len);
 
 	return 0;
 }
@@ -3402,7 +3402,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_TEST_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TEST_EVENTID\n");
-		ret = ath6kl_wmi_tcmd_test_report_rx(wmi, datap, len);
+		ret = ath6kl_wmi_test_rx(wmi, datap, len);
 		break;
 	case WMI_GET_FIXRATES_CMDID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_FIXRATES_CMDID\n");
-- 
1.7.8

