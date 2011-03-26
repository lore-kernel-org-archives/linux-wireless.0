Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49325 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1CZCnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 22:43:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove macro SHORT_SLOT_TIME_DISABLED
Date: Fri, 25 Mar 2011 19:47:01 -0700
Message-Id: <1301107622-31449-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and SHORT_SLOT_TIME_ENABLED.
Use WLAN_CAPABILITY_SHORT_SLOT_TIME instead.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |    3 ---
 drivers/net/wireless/mwifiex/join.c |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d1a5a10..410be69 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -57,9 +57,6 @@ struct tx_packet_hdr {
 #define GET_FW_DEFAULT_BANDS(adapter)  \
 	((adapter->fw_cap_info >> 8) & ALL_802_11_BANDS)
 
-#define SHORT_SLOT_TIME_DISABLED(CapInfo) (CapInfo &= ~BIT(10))
-#define SHORT_SLOT_TIME_ENABLED(CapInfo)  (CapInfo |= BIT(10))
-
 extern u8 supported_rates_b[B_SUPPORTED_RATES];
 extern u8 supported_rates_g[G_SUPPORTED_RATES];
 extern u8 supported_rates_bg[BG_SUPPORTED_RATES];
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 98d76d8..8ffb6a8 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -517,7 +517,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	tmp_cap = bss_desc->cap_info_bitmap;
 
 	if (priv->adapter->config_bands == BAND_B)
-		SHORT_SLOT_TIME_DISABLED(tmp_cap);
+		tmp_cap &= ~WLAN_CAPABILITY_SHORT_SLOT_TIME;
 
 	tmp_cap &= CAPINFO_MASK;
 	dev_dbg(priv->adapter->dev, "info: ASSOC_CMD: tmp_cap=%4X CAPINFO_MASK=%4lX\n",
@@ -1015,9 +1015,9 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
 			     + S_DS_GEN + cmd_append_size));
 
 	if (adapter->adhoc_start_band == BAND_B)
-		SHORT_SLOT_TIME_DISABLED(tmp_cap);
+		tmp_cap &= ~WLAN_CAPABILITY_SHORT_SLOT_TIME;
 	else
-		SHORT_SLOT_TIME_ENABLED(tmp_cap);
+		tmp_cap |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
 
 	adhoc_start->cap_info_bitmap = cpu_to_le16(tmp_cap);
 
-- 
1.7.0.2

