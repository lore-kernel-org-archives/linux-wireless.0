Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55260 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1JXJRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 05:17:55 -0400
Subject: [PATCH 7/9] ath6kl: remove unused debug levels
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 24 Oct 2011 12:17:51 +0300
Message-ID: <20111024091751.5004.61121.stgit@localhost6.localdomain6> (sfid-20111024_111757_806845_CE474741)
In-Reply-To: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
References: <20111024091644.5004.2767.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few levels had only one user so I changed them to use WLAN_CFG.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    8 ++++----
 drivers/net/wireless/ath/ath6kl/main.c  |    5 ++---
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index cbabc25..afb747b 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -20,16 +20,16 @@
 #include "hif.h"
 
 enum ATH6K_DEBUG_MASK {
-	ATH6KL_DBG_WLAN_CONNECT = BIT(0),     /* wlan connect */
-	ATH6KL_DBG_WLAN_SCAN    = BIT(1),     /* wlan scan */
+	/* hole */
+	/* hole */
 	ATH6KL_DBG_WLAN_TX      = BIT(2),     /* wlan tx */
 	ATH6KL_DBG_WLAN_RX      = BIT(3),     /* wlan rx */
 	ATH6KL_DBG_BMI		= BIT(4),     /* bmi tracing */
 	ATH6KL_DBG_HTC		= BIT(5),
 	ATH6KL_DBG_HIF		= BIT(6),
 	ATH6KL_DBG_IRQ		= BIT(7),     /* interrupt processing */
-	ATH6KL_DBG_PM           = BIT(8),     /* power management */
-	ATH6KL_DBG_WLAN_NODE    = BIT(9),     /* general wlan node tracing */
+	/* hole */
+	/* hole */
 	ATH6KL_DBG_WMI          = BIT(10),    /* wmi tracing */
 	ATH6KL_DBG_TRC	        = BIT(11),    /* generic func tracing */
 	ATH6KL_DBG_SCATTER	= BIT(12),    /* hif scatter tracing */
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 8d9a8f3..9db86e3 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -742,7 +742,7 @@ void ath6kl_scan_complete_evt(struct ath6kl *ar, int status)
 		ath6kl_wmi_bssfilter_cmd(ar->wmi, NONE_BSS_FILTER, 0);
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_WLAN_SCAN, "scan complete: %d\n", status);
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "scan complete: %d\n", status);
 }
 
 void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
@@ -1089,8 +1089,7 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 
 	del_timer(&ar->disconnect_timer);
 
-	ath6kl_dbg(ATH6KL_DBG_WLAN_CONNECT,
-		   "disconnect reason is %d\n", reason);
+	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "disconnect reason is %d\n", reason);
 
 	/*
 	 * If the event is due to disconnect cmd from the host, only they

