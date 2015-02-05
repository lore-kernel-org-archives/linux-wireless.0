Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47472 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbBEEto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:44 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENr-002ASp-3G
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] ath9k: Add new MCI states
Date: Thu,  5 Feb 2015 10:22:40 +0530
Message-Id: <1423111964-19626-4-git-send-email-sujith@msujith.org> (sfid-20150205_054953_279755_2FE965A0)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Several new MCI states have to handled,
add them to the list.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.h | 30 ++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.h b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
index 66d7ab9..19800af 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.h
@@ -191,17 +191,45 @@ enum mci_bt_state {
 /* Type of state query */
 enum mci_state_type {
 	MCI_STATE_ENABLE,
+	MCI_STATE_INIT_GPM_OFFSET,
+	MCI_STATE_CHECK_GPM_OFFSET,
+	MCI_STATE_NEXT_GPM_OFFSET,
+	MCI_STATE_LAST_GPM_OFFSET,
+	MCI_STATE_BT,
+	MCI_STATE_SET_BT_SLEEP,
 	MCI_STATE_SET_BT_AWAKE,
+	MCI_STATE_SET_BT_CAL_START,
+	MCI_STATE_SET_BT_CAL,
 	MCI_STATE_LAST_SCHD_MSG_OFFSET,
 	MCI_STATE_REMOTE_SLEEP,
+	MCI_STATE_CONT_STATUS,
 	MCI_STATE_RESET_REQ_WAKE,
 	MCI_STATE_SEND_WLAN_COEX_VERSION,
+	MCI_STATE_SET_BT_COEX_VERSION,
+	MCI_STATE_SEND_WLAN_CHANNELS,
 	MCI_STATE_SEND_VERSION_QUERY,
 	MCI_STATE_SEND_STATUS_QUERY,
+	MCI_STATE_NEED_FLUSH_BT_INFO,
+	MCI_STATE_SET_CONCUR_TX_PRI,
 	MCI_STATE_RECOVER_RX,
 	MCI_STATE_NEED_FTP_STOMP,
+	MCI_STATE_NEED_TUNING,
+	MCI_STATE_NEED_STAT_DEBUG,
+	MCI_STATE_SHARED_CHAIN_CONCUR_TX,
+	MCI_STATE_AIC_CAL,
+	MCI_STATE_AIC_START,
+	MCI_STATE_AIC_CAL_RESET,
+	MCI_STATE_AIC_CAL_SINGLE,
+	MCI_STATE_IS_AR9462,
+	MCI_STATE_IS_AR9565_1ANT,
+	MCI_STATE_IS_AR9565_2ANT,
+	MCI_STATE_WLAN_WEAK_SIGNAL,
+	MCI_STATE_SET_WLAN_PS_STATE,
+	MCI_STATE_GET_WLAN_PS_STATE,
 	MCI_STATE_DEBUG,
-	MCI_STATE_NEED_FLUSH_BT_INFO,
+	MCI_STATE_STAT_DEBUG,
+	MCI_STATE_ALLOW_FCS,
+	MCI_STATE_SET_2G_CONTENTION,
 	MCI_STATE_MAX
 };
 
-- 
2.2.2

