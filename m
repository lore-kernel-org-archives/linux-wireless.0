Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53615 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754366AbcKUMTj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 07:19:39 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uALCFFcc003271
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 04:19:38 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 26tq4neub2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 04:19:38 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: Disable adhoc feature based on firmware capability
Date: Mon, 21 Nov 2016 17:49:04 +0530
Message-ID: <1479730744-8964-1-git-send-email-akarwar@marvell.com> (sfid-20161121_132002_928558_B532A9D4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

We will read fw_cap_info filled by firmware to check whether to
skip ADHOC related commands or not. Also, IBSS_COALESCING_STATUS
command has been moved from init path to adhoc network creation
path.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 +++++++
 drivers/net/wireless/marvell/mwifiex/fw.h       |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c  | 36 +++++++++++++++++--------
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a231f09..a7d359e 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2143,6 +2143,16 @@ static int mwifiex_cfg80211_inform_ibss_bss(struct mwifiex_private *priv)
 	ret = mwifiex_set_encode(priv, NULL, NULL, 0, 0, NULL, 1);
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
+		u16 enable = true;
+
+		/* set ibss coalescing_status */
+		ret = mwifiex_send_cmd(
+				priv,
+				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				HostCmd_ACT_GEN_SET, 0, &enable, true);
+		if (ret)
+			return ret;
+
 		/* "privacy" is set only for ad-hoc mode */
 		if (privacy) {
 			/*
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 9b3ccea..ea45594 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -219,6 +219,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_TDLS_ENABLED(FwCapInfo) (FwCapInfo & BIT(14))
 #define ISSUPP_DRCS_ENABLED(FwCapInfo) (FwCapInfo & BIT(15))
 #define ISSUPP_SDIO_SPA_ENABLED(FwCapInfo) (FwCapInfo & BIT(16))
+#define ISSUPP_ADHOC_ENABLED(FwCapInfo) (FwCapInfo & BIT(25))
 
 #define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
 				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 768c519..125e448 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1900,6 +1900,24 @@ static int mwifiex_cmd_get_wakeup_reason(struct mwifiex_private *priv,
 	return 0;
 }
 
+/* This function check if the command is supported by firmware */
+static int mwifiex_is_cmd_supported(struct mwifiex_private *priv, u16 cmd_no)
+{
+	if (!ISSUPP_ADHOC_ENABLED(priv->adapter->fw_cap_info)) {
+		switch (cmd_no) {
+		case HostCmd_CMD_802_11_IBSS_COALESCING_STATUS:
+		case HostCmd_CMD_802_11_AD_HOC_START:
+		case HostCmd_CMD_802_11_AD_HOC_JOIN:
+		case HostCmd_CMD_802_11_AD_HOC_STOP:
+			return -EOPNOTSUPP;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * This function prepares the commands before sending them to the firmware.
  *
@@ -1913,6 +1931,13 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 	struct host_cmd_ds_command *cmd_ptr = cmd_buf;
 	int ret = 0;
 
+	if (mwifiex_is_cmd_supported(priv, cmd_no)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "0x%x command not supported by firmware\n",
+			    cmd_no);
+			return -EOPNOTSUPP;
+		}
+
 	/* Prepare command */
 	switch (cmd_no) {
 	case HostCmd_CMD_GET_HW_SPEC:
@@ -2206,7 +2231,6 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
-	u16 enable = true;
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
 	struct mwifiex_ds_auto_ds auto_ds;
 	enum state_11d_t state_11d;
@@ -2319,16 +2343,6 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 	if (ret)
 		return -1;
 
-	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
-		/* set ibss coalescing_status */
-		ret = mwifiex_send_cmd(
-				priv,
-				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				HostCmd_ACT_GEN_SET, 0, &enable, true);
-		if (ret)
-			return -1;
-	}
-
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
 	/* Send request to firmware */
-- 
1.9.1
