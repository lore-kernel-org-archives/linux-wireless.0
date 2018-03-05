Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42892 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbeCEOtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:18 -0500
Received: by mail-pf0-f196.google.com with SMTP id a16so7275003pfn.9
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:18 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 08/10] rsi: device disconnect changes
Date: Mon,  5 Mar 2018 20:06:58 +0530
Message-Id: <1520260620-4694-9-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154922_724496_2B5DF528)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Below changes are done:
1. When HCI detach is called, making bt_adapter null and checking
for this variable where ever required.
2. In USB case, one extra register write is added to disable
firmware watchdog.
3. When interface down is called as part of disconnect, don't
send RX filter frame.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |  8 ++++++--
 drivers/net/wireless/rsi/rsi_91x_main.c     |  2 ++
 drivers/net/wireless/rsi/rsi_91x_usb.c      | 10 ++++++++++
 drivers/net/wireless/rsi/rsi_hal.h          |  1 +
 drivers/net/wireless/rsi/rsi_main.h         |  1 +
 5 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index a7e1f7d..63d43fc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -428,14 +428,18 @@ static void rsi_mac80211_stop(struct ieee80211_hw *hw)
 {
 	struct rsi_hw *adapter = hw->priv;
 	struct rsi_common *common = adapter->priv;
+	u16 rx_filter_word = 0xffff;
 
 	rsi_dbg(ERR_ZONE, "===> Interface DOWN <===\n");
 	mutex_lock(&common->mutex);
 	common->iface_down = true;
 	wiphy_rfkill_stop_polling(hw->wiphy);
 
-	/* Block all rx frames */
-	rsi_send_rx_filter_frame(common, 0xffff);
+	if (!common->disc_in_prog) {
+		/* Block all rx frames */
+		rx_filter_word |= ~DISALLOW_BEACONS;
+		rsi_send_rx_filter_frame(common, rx_filter_word);
+	}
 
 	mutex_unlock(&common->mutex);
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 7790314..96b36aa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -350,6 +350,8 @@ struct rsi_hw *rsi_91x_init(u16 oper_mode)
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
 	common->init_done = true;
+	common->disc_in_prog = false;
+	common->bt_adapter = NULL;
 	adapter->device_model = RSI_DEV_9113;
 	common->oper_mode = oper_mode;
 	adapter->reg_mode = rsi_reg;
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index be8236f..f92909c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -676,11 +676,13 @@ static int usb_ulp_read_write(struct rsi_hw *adapter, u16 addr, u32 data,
 	return 0;
 }
 
+#define FW_WDT_DISABLE_REQ              0x69
 static int rsi_reset_card(struct rsi_hw *adapter)
 {
 	int ret;
 
 	rsi_dbg(INFO_ZONE, "Resetting Card...\n");
+
 	rsi_usb_master_reg_write(adapter, RSI_TA_HOLD_REG, 0xE, 4);
 
 	/* This msleep will ensure Thread-Arch processor to go to hold
@@ -688,6 +690,13 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 	 */
 	msleep(100);
 
+	if (rsi_usb_master_reg_write(adapter, SWBL_REGOUT,
+				     FW_WDT_DISABLE_REQ,
+				     RSI_COMMON_REG_SIZE) < 0) {
+		rsi_dbg(ERR_ZONE, "%s: FW WDT Disable failed...\n", __func__);
+		goto fail;
+	}
+
 	ret = usb_ulp_read_write(adapter, RSI_WATCH_DOG_TIMER_1,
 				 RSI_ULP_WRITE_2, 32);
 	if (ret < 0)
@@ -804,6 +813,7 @@ static void rsi_disconnect(struct usb_interface *pfunction)
 
 	if (!adapter)
 		return;
+	adapter->priv->disc_in_prog = true;
 
 	rsi_mac80211_detach(adapter);
 	rsi_reset_card(adapter);
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index d6c2baa..327638c 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -115,6 +115,7 @@
 #define FW_FLASH_OFFSET			0x820
 #define LMAC_VER_OFFSET			(FW_FLASH_OFFSET + 0x200)
 #define MAX_DWORD_ALIGN_BYTES		64
+#define RSI_COMMON_REG_SIZE		2
 
 struct bl_header {
 	__le32 flags;
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 4521c43..9e09dd5 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -325,6 +325,7 @@ struct rsi_common {
 	bool bgscan_en;
 	bool cancel_hwscan;
 	bool eapol4_confirm;
+	bool disc_in_prog;
 };
 
 struct eepromrw_info {
-- 
2.7.4
