Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614Ab1BZTBQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 14:01:16 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlagn: split BT page and inquiry UART msg
Date: Sat, 26 Feb 2011 10:46:05 -0800
Message-Id: <1298745966-25130-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1298745966-25130-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both inquiry and page was combine in frame7 of UART message, separate it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    9 ++++++---
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 8c70f0b..dc7055e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1984,12 +1984,14 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME6DISCOVERABLE_MSK & uart_msg->frame6) >>
 			BT_UART_MSG_FRAME6DISCOVERABLE_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Sniff Activity = 0x%X, Inquiry/Page SR Mode = "
-			"0x%X, Connectable = 0x%X",
+	IWL_DEBUG_NOTIF(priv, "Sniff Activity = 0x%X, Page = "
+			"0x%X, Inquiry = 0x%X, Connectable = 0x%X",
 		(BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK & uart_msg->frame7) >>
 			BT_UART_MSG_FRAME7SNIFFACTIVITY_POS,
-		(BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_MSK & uart_msg->frame7) >>
-			BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS,
+		(BT_UART_MSG_FRAME7PAGE_MSK & uart_msg->frame7) >>
+			BT_UART_MSG_FRAME7PAGE_POS,
+		(BT_UART_MSG_FRAME7INQUIRY_MSK & uart_msg->frame7) >>
+			BT_UART_MSG_FRAME7INQUIRY_POS,
 		(BT_UART_MSG_FRAME7CONNECTABLE_MSK & uart_msg->frame7) >>
 			BT_UART_MSG_FRAME7CONNECTABLE_POS);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index df6abbf..3629ee3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4258,9 +4258,12 @@ enum iwl_bt_coex_profile_traffic_load {
 #define BT_UART_MSG_FRAME7SNIFFACTIVITY_POS	(0)
 #define BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK	\
 		(0x7 << BT_UART_MSG_FRAME7SNIFFACTIVITY_POS)
-#define BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS	(3)
-#define BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_MSK	\
-		(0x3 << BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS)
+#define BT_UART_MSG_FRAME7PAGE_POS		(3)
+#define BT_UART_MSG_FRAME7PAGE_MSK		\
+		(0x1 << BT_UART_MSG_FRAME7PAGE_POS)
+#define BT_UART_MSG_FRAME7INQUIRY_POS		(4)
+#define BT_UART_MSG_FRAME7INQUIRY_MSK		\
+		(0x1 << BT_UART_MSG_FRAME7INQUIRY_POS)
 #define BT_UART_MSG_FRAME7CONNECTABLE_POS	(5)
 #define BT_UART_MSG_FRAME7CONNECTABLE_MSK	\
 		(0x1 << BT_UART_MSG_FRAME7CONNECTABLE_POS)
-- 
1.7.0.4

