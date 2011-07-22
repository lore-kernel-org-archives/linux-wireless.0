Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:44402 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1GVDUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 23:20:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove redundant variable scan_table_idx
Date: Thu, 21 Jul 2011 20:25:58 -0700
Message-Id: <1311305158-15534-2-git-send-email-bzhao@marvell.com> (sfid-20110722_052025_850742_D19441F3)
In-Reply-To: <1311305158-15534-1-git-send-email-bzhao@marvell.com>
References: <1311305158-15534-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mwifiex_get_bss_info() routine updates variable 'info->scan_table_idx'
but it is never used.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/ioctl.h     |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |   12 ------------
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index bd9e074..e0b68e7 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -134,7 +134,6 @@ struct mwifiex_ver_ext {
 struct mwifiex_bss_info {
 	u32 bss_mode;
 	struct mwifiex_802_11_ssid ssid;
-	u32 scan_table_idx;
 	u32 bss_chan;
 	u32 region_code;
 	u32 media_connected;
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 10ef9e9..fd764b3 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -376,7 +376,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_bssdescriptor *bss_desc;
-	s32 tbl_idx;
 
 	if (!info)
 		return -1;
@@ -394,17 +393,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 
 	info->region_code = adapter->region_code;
 
-	/* Scan table index if connected */
-	info->scan_table_idx = 0;
-	if (priv->media_connected) {
-		tbl_idx =
-			mwifiex_find_ssid_in_list(priv, &bss_desc->ssid,
-						  bss_desc->mac_address,
-						  priv->bss_mode);
-		if (tbl_idx >= 0)
-			info->scan_table_idx = tbl_idx;
-	}
-
 	info->media_connected = priv->media_connected;
 
 	info->max_power_level = priv->max_tx_power_level;
-- 
1.7.0.2

