Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2242 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964855AbbA1EzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:55:03 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4o1Or024450
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:03 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1s50eqxb55-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:55:03 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <gaoqs@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 02/10] mwifiex: store AP configuration in private structure
Date: Wed, 28 Jan 2015 15:54:17 +0530
Message-ID: <1422440665-3940-3-git-send-email-patila@marvell.com> (sfid-20150128_055513_032568_7275B84F)
In-Reply-To: <1422440665-3940-1-git-send-email-patila@marvell.com>
References: <1422440665-3940-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store AP configuration in private structure so that we know
current AP configuration.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Qingshui Gao <gaoqs@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 2 ++
 drivers/net/wireless/mwifiex/main.h     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 1acccc5..8e07564 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1655,6 +1655,7 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
 
 	priv->ap_11n_enabled = 0;
+	memset(&priv->bss_cfg, 0, sizeof(priv->bss_cfg));
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
@@ -1782,6 +1783,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -1;
 	}
 
+	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9e839cd..673252a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -577,6 +577,7 @@ struct mwifiex_private {
 	unsigned long csa_expire_time;
 	u8 del_list_idx;
 	bool hs2_enabled;
+	struct mwifiex_uap_bss_param bss_cfg;
 	struct station_parameters *sta_params;
 	struct sk_buff_head tdls_txq;
 	u8 check_tdls_tx;
-- 
1.8.1.4

