Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:59975 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab1AUDEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:04:36 -0500
Received: by pxi15 with SMTP id 15so217956pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:04:36 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63382.633231.531270@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:33:50 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 31/33] ath9k_htc: Remove unused WMI commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

WMI_TGT_TXQ_ENABLE_CMDID
WMI_HOST_ATTACH
WMI_DEBUG_INFO_CMDID
WMI_BEACON_UPDATE_CMDID
WMI_RESET_CMDID
WMI_RX_LINK_CMDID
WMI_ABORT_TXQ_CMDID
WMI_STOP_DMA_RECV_CMDID

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |   16 ----------------
 drivers/net/wireless/ath/ath9k/wmi.h |    8 --------
 2 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 9c11d6e..a5f8f6b 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -27,16 +27,10 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_DISABLE_INTR_CMDID";
 	case WMI_ENABLE_INTR_CMDID:
 		return "WMI_ENABLE_INTR_CMDID";
-	case WMI_RX_LINK_CMDID:
-		return "WMI_RX_LINK_CMDID";
 	case WMI_ATH_INIT_CMDID:
 		return "WMI_ATH_INIT_CMDID";
-	case WMI_ABORT_TXQ_CMDID:
-		return "WMI_ABORT_TXQ_CMDID";
 	case WMI_STOP_TX_DMA_CMDID:
 		return "WMI_STOP_TX_DMA_CMDID";
-	case WMI_STOP_DMA_RECV_CMDID:
-		return "WMI_STOP_DMA_RECV_CMDID";
 	case WMI_ABORT_TX_DMA_CMDID:
 		return "WMI_ABORT_TX_DMA_CMDID";
 	case WMI_DRAIN_TXQ_CMDID:
@@ -51,8 +45,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_FLUSH_RECV_CMDID";
 	case WMI_SET_MODE_CMDID:
 		return "WMI_SET_MODE_CMDID";
-	case WMI_RESET_CMDID:
-		return "WMI_RESET_CMDID";
 	case WMI_NODE_CREATE_CMDID:
 		return "WMI_NODE_CREATE_CMDID";
 	case WMI_NODE_REMOVE_CMDID:
@@ -61,8 +53,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_VAP_REMOVE_CMDID";
 	case WMI_VAP_CREATE_CMDID:
 		return "WMI_VAP_CREATE_CMDID";
-	case WMI_BEACON_UPDATE_CMDID:
-		return "WMI_BEACON_UPDATE_CMDID";
 	case WMI_REG_READ_CMDID:
 		return "WMI_REG_READ_CMDID";
 	case WMI_REG_WRITE_CMDID:
@@ -71,10 +61,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_RC_STATE_CHANGE_CMDID";
 	case WMI_RC_RATE_UPDATE_CMDID:
 		return "WMI_RC_RATE_UPDATE_CMDID";
-	case WMI_DEBUG_INFO_CMDID:
-		return "WMI_DEBUG_INFO_CMDID";
-	case WMI_HOST_ATTACH:
-		return "WMI_HOST_ATTACH";
 	case WMI_TARGET_IC_UPDATE_CMDID:
 		return "WMI_TARGET_IC_UPDATE_CMDID";
 	case WMI_TGT_STATS_CMDID:
@@ -83,8 +69,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_TX_AGGR_ENABLE_CMDID";
 	case WMI_TGT_DETACH_CMDID:
 		return "WMI_TGT_DETACH_CMDID";
-	case WMI_TGT_TXQ_ENABLE_CMDID:
-		return "WMI_TGT_TXQ_ENABLE_CMDID";
 	case WMI_AGGR_LIMIT_CMD:
 		return "WMI_AGGR_LIMIT_CMD";
 	}
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index b705961..6e3edec 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -43,11 +43,8 @@ enum wmi_cmd_id {
 	/* Commands to Target */
 	WMI_DISABLE_INTR_CMDID,
 	WMI_ENABLE_INTR_CMDID,
-	WMI_RX_LINK_CMDID,
 	WMI_ATH_INIT_CMDID,
-	WMI_ABORT_TXQ_CMDID,
 	WMI_STOP_TX_DMA_CMDID,
-	WMI_STOP_DMA_RECV_CMDID,
 	WMI_ABORT_TX_DMA_CMDID,
 	WMI_DRAIN_TXQ_CMDID,
 	WMI_DRAIN_TXQ_ALL_CMDID,
@@ -55,23 +52,18 @@ enum wmi_cmd_id {
 	WMI_STOP_RECV_CMDID,
 	WMI_FLUSH_RECV_CMDID,
 	WMI_SET_MODE_CMDID,
-	WMI_RESET_CMDID,
 	WMI_NODE_CREATE_CMDID,
 	WMI_NODE_REMOVE_CMDID,
 	WMI_VAP_REMOVE_CMDID,
 	WMI_VAP_CREATE_CMDID,
-	WMI_BEACON_UPDATE_CMDID,
 	WMI_REG_READ_CMDID,
 	WMI_REG_WRITE_CMDID,
 	WMI_RC_STATE_CHANGE_CMDID,
 	WMI_RC_RATE_UPDATE_CMDID,
-	WMI_DEBUG_INFO_CMDID,
-	WMI_HOST_ATTACH,
 	WMI_TARGET_IC_UPDATE_CMDID,
 	WMI_TGT_STATS_CMDID,
 	WMI_TX_AGGR_ENABLE_CMDID,
 	WMI_TGT_DETACH_CMDID,
-	WMI_TGT_TXQ_ENABLE_CMDID,
 	WMI_AGGR_LIMIT_CMD = 0x0026,
 };
 
-- 
1.7.3.5

