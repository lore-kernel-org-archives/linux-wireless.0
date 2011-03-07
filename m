Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:44479 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1CGCOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:03 -0500
Received: by pxi15 with SMTP id 15so651103pxi.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:02 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16226.51182.447786@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:43:54 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 12/34] ath9k_htc: Remove unused WMI commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

WMI_TGT_TXQ_ENABLE_CMDID
WMI_HOST_ATTACH
WMI_DEBUG_INFO_CMDID
WMI_BEACON_UPDATE_CMDID
WMI_RESET_CMDID
WMI_RX_LINK_CMDID
WMI_STOP_DMA_RECV_CMDID

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c |   14 --------------
 drivers/net/wireless/ath/ath9k/wmi.h |    7 -------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 39088be..c8eaab3 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -27,16 +27,12 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_DISABLE_INTR_CMDID";
 	case WMI_ENABLE_INTR_CMDID:
 		return "WMI_ENABLE_INTR_CMDID";
-	case WMI_RX_LINK_CMDID:
-		return "WMI_RX_LINK_CMDID";
 	case WMI_ATH_INIT_CMDID:
 		return "WMI_ATH_INIT_CMDID";
 	case WMI_ABORT_TXQ_CMDID:
 		return "WMI_ABORT_TXQ_CMDID";
 	case WMI_STOP_TX_DMA_CMDID:
 		return "WMI_STOP_TX_DMA_CMDID";
-	case WMI_STOP_DMA_RECV_CMDID:
-		return "WMI_STOP_DMA_RECV_CMDID";
 	case WMI_ABORT_TX_DMA_CMDID:
 		return "WMI_ABORT_TX_DMA_CMDID";
 	case WMI_DRAIN_TXQ_CMDID:
@@ -51,8 +47,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_FLUSH_RECV_CMDID";
 	case WMI_SET_MODE_CMDID:
 		return "WMI_SET_MODE_CMDID";
-	case WMI_RESET_CMDID:
-		return "WMI_RESET_CMDID";
 	case WMI_NODE_CREATE_CMDID:
 		return "WMI_NODE_CREATE_CMDID";
 	case WMI_NODE_REMOVE_CMDID:
@@ -61,8 +55,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_VAP_REMOVE_CMDID";
 	case WMI_VAP_CREATE_CMDID:
 		return "WMI_VAP_CREATE_CMDID";
-	case WMI_BEACON_UPDATE_CMDID:
-		return "WMI_BEACON_UPDATE_CMDID";
 	case WMI_REG_READ_CMDID:
 		return "WMI_REG_READ_CMDID";
 	case WMI_REG_WRITE_CMDID:
@@ -71,10 +63,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
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
@@ -83,8 +71,6 @@ static const char *wmi_cmd_to_name(enum wmi_cmd_id wmi_cmd)
 		return "WMI_TX_AGGR_ENABLE_CMDID";
 	case WMI_TGT_DETACH_CMDID:
 		return "WMI_TGT_DETACH_CMDID";
-	case WMI_TGT_TXQ_ENABLE_CMDID:
-		return "WMI_TGT_TXQ_ENABLE_CMDID";
 	case WMI_AGGR_LIMIT_CMD:
 		return "WMI_AGGR_LIMIT_CMD";
 	}
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index ee675dd..7896de4 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -43,11 +43,9 @@ enum wmi_cmd_id {
 	/* Commands to Target */
 	WMI_DISABLE_INTR_CMDID,
 	WMI_ENABLE_INTR_CMDID,
-	WMI_RX_LINK_CMDID,
 	WMI_ATH_INIT_CMDID,
 	WMI_ABORT_TXQ_CMDID,
 	WMI_STOP_TX_DMA_CMDID,
-	WMI_STOP_DMA_RECV_CMDID,
 	WMI_ABORT_TX_DMA_CMDID,
 	WMI_DRAIN_TXQ_CMDID,
 	WMI_DRAIN_TXQ_ALL_CMDID,
@@ -55,23 +53,18 @@ enum wmi_cmd_id {
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
1.7.4.1

