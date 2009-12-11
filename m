Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50881 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762647AbZLKLme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:42:34 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/31] wl1271: some new configuration values according to new reference
Date: Fri, 11 Dec 2009 13:41:06 +0200
Message-Id: <1260531682-4695-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the new reference driver, some of the firmware configuration values have
been changed.  This patch changes them in the wl1271 driver accordingly.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_acx.h  |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c |   16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index fa5d953..dcd64b7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -885,8 +885,8 @@ struct acx_tx_config_options {
 	__le16 tx_compl_threshold;   /* number of packets */
 } __attribute__ ((packed));
 
-#define ACX_RX_MEM_BLOCKS     64
-#define ACX_TX_MIN_MEM_BLOCKS 64
+#define ACX_RX_MEM_BLOCKS     70
+#define ACX_TX_MIN_MEM_BLOCKS 40
 #define ACX_TX_DESCRIPTORS    32
 #define ACX_NUM_SSID_PROFILES 1
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cdd0bc3..9fb23b0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -67,10 +67,10 @@ static struct conf_drv_settings default_conf = {
 		.ps_poll_timeout             = 15,
 		.upsd_timeout                = 15,
 		.rts_threshold               = 2347,
-		.rx_cca_threshold            = 0xFFEF,
-		.irq_blk_threshold           = 0,
-		.irq_pkt_threshold           = USHORT_MAX,
-		.irq_timeout                 = 5,
+		.rx_cca_threshold            = 0,
+		.irq_blk_threshold           = 0xFFFF,
+		.irq_pkt_threshold           = 0,
+		.irq_timeout                 = 600,
 		.queue_type                  = CONF_RX_QUEUE_TYPE_LOW_PRIORITY,
 	},
 	.tx = {
@@ -172,8 +172,8 @@ static struct conf_drv_settings default_conf = {
 			}
 		},
 		.frag_threshold              = IEEE80211_MAX_FRAG_THRESHOLD,
-		.tx_compl_timeout            = 5,
-		.tx_compl_threshold          = 5
+		.tx_compl_timeout            = 700,
+		.tx_compl_threshold          = 4
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
@@ -186,12 +186,12 @@ static struct conf_drv_settings default_conf = {
 				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
 			}
 		},
-		.synch_fail_thold            = 5,
+		.synch_fail_thold            = 10,
 		.bss_lose_timeout            = 100,
 		.beacon_rx_timeout           = 10000,
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
-		.ps_poll_threshold           = 4,
+		.ps_poll_threshold           = 20,
 		.sig_trigger_count           = 2,
 		.sig_trigger = {
 			[0] = {
-- 
1.6.3.3

