Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:32770 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750978Ab1KHFlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 00:41:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/7] mwifiex: fix coding style
Date: Mon,  7 Nov 2011 21:41:09 -0800
Message-Id: <1320730872-25619-5-git-send-email-bzhao@marvell.com> (sfid-20111108_064157_449825_2EFDE84F)
In-Reply-To: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
References: <1320730872-25619-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Rename DataRate to data_rate and arrange 'for' loop
for better readability.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |    2 +-
 drivers/net/wireless/mwifiex/join.c |   17 ++++++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 0cc5d73..35cb29c 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -673,7 +673,7 @@ struct host_cmd_ds_802_11_ad_hoc_start {
 	union ieee_types_phy_param_set phy_param_set;
 	u16 reserved1;
 	__le16 cap_info_bitmap;
-	u8 DataRate[HOSTCMD_SUPPORTED_RATES];
+	u8 data_rate[HOSTCMD_SUPPORTED_RATES];
 } __packed;
 
 struct host_cmd_ds_802_11_ad_hoc_result {
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index b27bd33..1c49813 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -837,8 +837,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		bss_desc->privacy = MWIFIEX_802_11_PRIV_FILTER_ACCEPT_ALL;
 	}
 
-	memset(adhoc_start->DataRate, 0, sizeof(adhoc_start->DataRate));
-	mwifiex_get_active_data_rates(priv, adhoc_start->DataRate);
+	memset(adhoc_start->data_rate, 0, sizeof(adhoc_start->data_rate));
+	mwifiex_get_active_data_rates(priv, adhoc_start->data_rate);
 	if ((adapter->adhoc_start_band & BAND_G) &&
 	    (priv->curr_pkt_filter & HostCmd_ACT_MAC_ADHOC_G_PROTECTION_ON)) {
 		if (mwifiex_send_cmd_async(priv, HostCmd_CMD_MAC_CONTROL,
@@ -850,20 +850,19 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 		}
 	}
 	/* Find the last non zero */
-	for (i = 0; i < sizeof(adhoc_start->DataRate) &&
-			adhoc_start->DataRate[i];
-			i++)
-			;
+	for (i = 0; i < sizeof(adhoc_start->data_rate); i++)
+		if (!adhoc_start->data_rate[i])
+			break;
 
 	priv->curr_bss_params.num_of_rates = i;
 
 	/* Copy the ad-hoc creating rates into Current BSS rate structure */
 	memcpy(&priv->curr_bss_params.data_rates,
-	       &adhoc_start->DataRate, priv->curr_bss_params.num_of_rates);
+	       &adhoc_start->data_rate, priv->curr_bss_params.num_of_rates);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
-	       adhoc_start->DataRate[0], adhoc_start->DataRate[1],
-	       adhoc_start->DataRate[2], adhoc_start->DataRate[3]);
+	       adhoc_start->data_rate[0], adhoc_start->data_rate[1],
+	       adhoc_start->data_rate[2], adhoc_start->data_rate[3]);
 
 	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
 
-- 
1.7.0.2

