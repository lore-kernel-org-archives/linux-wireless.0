Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4826 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933115AbbFVIIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:08:21 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t5M800dp015616
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:20 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1v55hgut9v-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2015 01:08:20 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 15/17] mwifiex: advertise multichannel support to cfg80211
Date: Mon, 22 Jun 2015 19:06:21 +0530
Message-ID: <1434980183-2901-16-git-send-email-patila@marvell.com> (sfid-20150622_103351_371739_B059F23B)
In-Reply-To: <1434980183-2901-1-git-send-email-patila@marvell.com>
References: <1434980183-2901-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to advetise mwifiex multichannel support to
cfg80211. If module parameter drcs is enabled and FW supports multichannel
operation we advertise this support to cfg80211. As of now 2 simultaneous
channels are supported.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 14 +++++++++++++-
 drivers/net/wireless/mwifiex/main.h     |  1 +
 drivers/net/wireless/mwifiex/sta_cmd.c  | 13 +++++++++----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 46f9dc2..bc863e9 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -43,6 +43,15 @@ static const struct ieee80211_iface_combination mwifiex_iface_comb_ap_sta = {
 	.beacon_int_infra_match = true,
 };
 
+static const struct
+ieee80211_iface_combination mwifiex_drcs_iface_comb_ap_sta = {
+	.limits = mwifiex_ap_sta_limits,
+	.num_different_channels = 2,
+	.n_limits = ARRAY_SIZE(mwifiex_ap_sta_limits),
+	.max_interfaces = MWIFIEX_MAX_BSS_NUM,
+	.beacon_int_infra_match = true,
+};
+
 /*
  * This function maps the nl802.11 channel type into driver channel type.
  *
@@ -3745,7 +3754,10 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	else
 		wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
-	wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta;
+	if (adapter->drcs_enabled && ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
+		wiphy->iface_combinations = &mwifiex_drcs_iface_comb_ap_sta;
+	else
+		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta;
 	wiphy->n_iface_combinations = 1;
 
 	/* Initialize cipher suits */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6e82058..f3264f2 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -985,6 +985,7 @@ struct mwifiex_adapter {
 	u8 coex_win_size;
 	u8 coex_tx_win_size;
 	u8 coex_rx_win_size;
+	bool drcs_enabled;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index f250b61..36cb6bd 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -2155,12 +2155,17 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 				return -1;
 		}
 
-		if (ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
-			ret = mwifiex_send_cmd(priv, HostCmd_CMD_MC_POLICY,
-					       HostCmd_ACT_GEN_SET, 0, &drcs,
-					       true);
+		if (drcs) {
+			adapter->drcs_enabled = true;
+			if (ISSUPP_DRCS_ENABLED(adapter->fw_cap_info))
+				ret = mwifiex_send_cmd(priv,
+						       HostCmd_CMD_MC_POLICY,
+						       HostCmd_ACT_GEN_SET, 0,
+						       &adapter->drcs_enabled,
+						       true);
 			if (ret)
 				return -1;
+		}
 	}
 
 	/* get tx rate */
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
