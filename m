Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49158 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbbANKqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 05:46:40 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0EANn2L027577
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:40 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rwj838p15-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 02:46:40 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<gaoqs@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 02/10] mwifiex: store AP configuration in private structure
Date: Wed, 14 Jan 2015 21:45:30 +0530
Message-ID: <1421252138-30157-3-git-send-email-patila@marvell.com> (sfid-20150114_114643_069500_88482CF4)
In-Reply-To: <1421252138-30157-1-git-send-email-patila@marvell.com>
References: <1421252138-30157-1-git-send-email-patila@marvell.com>
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
index 85795f9..9dde975 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1653,6 +1653,7 @@ static int mwifiex_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 		wiphy_err(wiphy, "Failed to delete mgmt IEs!\n");
 
 	priv->ap_11n_enabled = 0;
+	memset(&priv->bss_cfg, 0, sizeof(priv->bss_cfg));
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_STOP,
 			     HostCmd_ACT_GEN_SET, 0, NULL, true)) {
@@ -1780,6 +1781,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -1;
 	}
 
+	memcpy(&priv->bss_cfg, bss_cfg, sizeof(priv->bss_cfg));
 	kfree(bss_cfg);
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_UAP_BSS_START,
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0f5fcdf..fb8e195 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -578,6 +578,7 @@ struct mwifiex_private {
 	unsigned long csa_expire_time;
 	u8 del_list_idx;
 	bool hs2_enabled;
+	struct mwifiex_uap_bss_param bss_cfg;
 	struct station_parameters *sta_params;
 	struct sk_buff_head tdls_txq;
 	u8 check_tdls_tx;
-- 
1.8.1.4

