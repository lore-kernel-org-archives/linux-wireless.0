Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:33962 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125Ab1F3IoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 04:44:03 -0400
Subject: [PATCH v2] ath6kl: implement testmode rx command
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Thu, 30 Jun 2011 11:43:54 +0300
Message-ID: <20110630084354.5352.83068.stgit@localhost6.localdomain6> (sfid-20110630_104421_543532_BEDD309F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new testmode command for retrieving rx reports from firmware.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c         |   99 ++++++++++++++++++++
 .../staging/ath6kl/os/linux/include/ar6000_drv.h   |   10 --
 drivers/staging/ath6kl/os/linux/include/cfg80211.h |   11 ++
 drivers/staging/ath6kl/wmi/wmi.c                   |    6 +
 4 files changed, 114 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 441ae04..5fdda4a 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1472,6 +1472,7 @@ enum ar6k_testmode_attr {
 
 enum ar6k_testmode_cmd {
 	AR6K_TM_CMD_TCMD		= 0,
+	AR6K_TM_CMD_RX_REPORT		= 1,
 };
 
 #define AR6K_TM_DATA_MAX_LEN 5000
@@ -1482,11 +1483,88 @@ static const struct nla_policy ar6k_testmode_policy[AR6K_TM_ATTR_MAX + 1] = {
 				.len = AR6K_TM_DATA_MAX_LEN },
 };
 
+void ar6000_testmode_rx_report_event(struct ar6_softc *ar, void *buf,
+				     int buf_len)
+{
+	if (down_interruptible(&ar->arSem))
+		return;
+
+	kfree(ar->tcmd_rx_report);
+
+	ar->tcmd_rx_report = kmemdup(buf, buf_len, GFP_KERNEL);
+	ar->tcmd_rx_report_len = buf_len;
+
+	up(&ar->arSem);
+
+	wake_up(&arEvent);
+}
+
+static int ar6000_testmode_rx_report(struct ar6_softc *ar, void *buf,
+				     int buf_len, struct sk_buff *skb)
+{
+	int ret = 0;
+	long left;
+
+	if (down_interruptible(&ar->arSem))
+		return -ERESTARTSYS;
+
+	if (ar->arWmiReady == false) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (ar->bIsDestroyProgress) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	WARN_ON(ar->tcmd_rx_report != NULL);
+	WARN_ON(ar->tcmd_rx_report_len > 0);
+
+	if (wmi_test_cmd(ar->arWmi, buf, buf_len) < 0) {
+		up(&ar->arSem);
+		return -EIO;
+	}
+
+	left = wait_event_interruptible_timeout(arEvent,
+					       ar->tcmd_rx_report != NULL,
+					       wmitimeout * HZ);
+
+	if (left == 0) {
+		ret = -ETIMEDOUT;
+		goto out;
+	} else if (left < 0) {
+		ret = left;
+		goto out;
+	}
+
+	if (ar->tcmd_rx_report == NULL || ar->tcmd_rx_report_len == 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	NLA_PUT(skb, AR6K_TM_ATTR_DATA, ar->tcmd_rx_report_len,
+		ar->tcmd_rx_report);
+
+	kfree(ar->tcmd_rx_report);
+	ar->tcmd_rx_report = NULL;
+
+out:
+	up(&ar->arSem);
+
+	return ret;
+
+nla_put_failure:
+	ret = -ENOBUFS;
+	goto out;
+}
+
 static int ar6k_testmode_cmd(struct wiphy *wiphy, void *data, int len)
 {
 	struct ar6_softc *ar = wiphy_priv(wiphy);
 	struct nlattr *tb[AR6K_TM_ATTR_MAX + 1];
-	int err, buf_len;
+	int err, buf_len, reply_len;
+	struct sk_buff *skb;
 	void *buf;
 
 	err = nla_parse(tb, AR6K_TM_ATTR_MAX, data, len,
@@ -1510,6 +1588,25 @@ static int ar6k_testmode_cmd(struct wiphy *wiphy, void *data, int len)
 		return 0;
 
 		break;
+	case AR6K_TM_CMD_RX_REPORT:
+		if (!tb[AR6K_TM_ATTR_DATA])
+			return -EINVAL;
+
+		buf = nla_data(tb[AR6K_TM_ATTR_DATA]);
+		buf_len = nla_len(tb[AR6K_TM_ATTR_DATA]);
+
+		reply_len = nla_total_size(AR6K_TM_DATA_MAX_LEN);
+		skb = cfg80211_testmode_alloc_reply_skb(wiphy, reply_len);
+		if (!skb)
+			return -ENOMEM;
+
+		err = ar6000_testmode_rx_report(ar, buf, buf_len, skb);
+		if (err < 0) {
+			kfree_skb(skb);
+			return err;
+		}
+
+		return cfg80211_testmode_reply(skb);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
index 2911ea0..05cc774 100644
--- a/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
+++ b/drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
@@ -546,15 +546,9 @@ struct ar6_softc {
     s8 arMaxRetries;
     u8 arPhyCapability;
 #ifdef CONFIG_HOST_TCMD_SUPPORT
-    u8 tcmdRxReport;
-    u32 tcmdRxTotalPkt;
-    s32 tcmdRxRssi;
-    u32 tcmdPm;
     u32 arTargetMode;
-    u32 tcmdRxcrcErrPkt;
-    u32 tcmdRxsecErrPkt;
-    u16 tcmdRateCnt[TCMD_MAX_RATES];
-    u16 tcmdRateCntShortGuard[TCMD_MAX_RATES];
+    void *tcmd_rx_report;
+    int tcmd_rx_report_len;
 #endif
     AR6000_WLAN_STATE       arWlanState;
     struct ar_node_mapping  arNodeMap[MAX_NODE_NUM];
diff --git a/drivers/staging/ath6kl/os/linux/include/cfg80211.h b/drivers/staging/ath6kl/os/linux/include/cfg80211.h
index 1a6ae97..d525320 100644
--- a/drivers/staging/ath6kl/os/linux/include/cfg80211.h
+++ b/drivers/staging/ath6kl/os/linux/include/cfg80211.h
@@ -41,6 +41,17 @@ void ar6k_cfg80211_disconnect_event(struct ar6_softc *ar, u8 reason,
 
 void ar6k_cfg80211_tkip_micerr_event(struct ar6_softc *ar, u8 keyid, bool ismcast);
 
+#ifdef CONFIG_NL80211_TESTMODE
+void ar6000_testmode_rx_report_event(struct ar6_softc *ar, void *buf,
+				     int buf_len);
+#else
+static inline void ar6000_testmode_rx_report_event(struct ar6_softc *ar,
+						   void *buf, int buf_len) 
+{
+}
+#endif
+
+
 #endif /* _AR6K_CFG80211_H_ */
 
 
diff --git a/drivers/staging/ath6kl/wmi/wmi.c b/drivers/staging/ath6kl/wmi/wmi.c
index 4a17f99..c7b5e5c 100644
--- a/drivers/staging/ath6kl/wmi/wmi.c
+++ b/drivers/staging/ath6kl/wmi/wmi.c
@@ -41,6 +41,7 @@
 #include "a_debug.h"
 #include "dbglog_api.h"
 #include "roaming.h"
+#include "cfg80211.h"
 
 #define ATH_DEBUG_WMI ATH_DEBUG_MAKE_MODULE_MASK(0)
 
@@ -4465,10 +4466,9 @@ wmi_verify_tspec_params(WMI_CREATE_PSTREAM_CMD *pCmd, int tspecCompliance)
 static int
 wmi_tcmd_test_report_rx(struct wmi_t *wmip, u8 *datap, int len)
 {
+	ar6000_testmode_rx_report_event(wmip->wmi_devt, datap, len);
 
-   A_DPRINTF(DBG_WMI, (DBGFMT "Enter\n", DBGARG));
-
-   return 0;
+	return 0;
 }
 
 #endif /* CONFIG_HOST_TCMD_SUPPORT*/

