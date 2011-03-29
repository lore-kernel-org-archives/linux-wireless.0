Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36014 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab1C2Av5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 20:51:57 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: remove unused radio_on variable and macros
Date: Mon, 28 Mar 2011 17:55:43 -0700
Message-Id: <1301360144-4986-3-git-send-email-bzhao@marvell.com>
In-Reply-To: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
References: <1301360144-4986-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

The radio_on variable is defined but never used.

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h        |    3 ---
 drivers/net/wireless/mwifiex/init.c      |    1 -
 drivers/net/wireless/mwifiex/ioctl.h     |    1 -
 drivers/net/wireless/mwifiex/main.h      |    1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c |    3 ---
 5 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 6593e07..2d93391 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -875,9 +875,6 @@ struct host_cmd_ds_802_11_snmp_mib {
 	u8 value[1];
 } __packed;
 
-#define RADIO_ON                                0x01
-#define RADIO_OFF                               0x00
-
 struct mwifiex_rate_scope {
 	__le16 type;
 	__le16 length;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index bad436d..6fcdaa9 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -234,7 +234,6 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(adapter->bcn_buf, 0, sizeof(adapter->bcn_buf));
 	adapter->bcn_buf_end = adapter->bcn_buf;
 
-	adapter->radio_on = RADIO_ON;
 	adapter->multiple_dtim = 1;
 
 	adapter->local_listen_interval = 0;	/* default value in firmware
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 7e0d316..d01160a 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -193,7 +193,6 @@ struct mwifiex_bss_info {
 	u32 bss_chan;
 	u32 region_code;
 	u32 media_connected;
-	u32 radio_on;
 	u32 max_power_level;
 	u32 min_power_level;
 	u32 adhoc_state;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 12b9a36..c26f704 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -611,7 +611,6 @@ struct mwifiex_adapter {
 	u16 curr_tx_buf_size;
 	u32 ioport;
 	enum MWIFIEX_HARDWARE_STATUS hw_status;
-	u16 radio_on;
 	u16 number_of_antenna;
 	u32 fw_cap_info;
 	/* spin lock for interrupt handling */
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index abad07e..b163507 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -790,9 +790,6 @@ int mwifiex_get_bss_info(struct mwifiex_private *priv,
 	/* Connection status */
 	info->media_connected = priv->media_connected;
 
-	/* Radio status */
-	info->radio_on = adapter->radio_on;
-
 	/* Tx power information */
 	info->max_power_level = priv->max_tx_power_level;
 	info->min_power_level = priv->min_tx_power_level;
-- 
1.7.0.2

