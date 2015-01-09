Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:49998 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758175AbbAITS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:28 -0500
Received: by mail-oi0-f54.google.com with SMTP id u20so13178366oif.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:27 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/8] wcn36xx: use !! when assigning int as a boolean
Date: Fri,  9 Jan 2015 14:15:46 -0500
Message-Id: <1420830952-9624-3-git-send-email-me@bobcopeland.com> (sfid-20150109_201833_465095_97632AF9)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bd->tx_comp is a single bit in a bitfield, so assigning
"info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS" only happens
to work because TX_STATUS is defined to BIT(0); if it were
any other bit this assignment would fail.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 32bb26a..f701873 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -237,7 +237,7 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
 
 	bd->dpu_rf = WCN36XX_BMU_WQ_TX;
 
-	bd->tx_comp = info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS;
+	bd->tx_comp = !!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS);
 	if (bd->tx_comp) {
 		wcn36xx_dbg(WCN36XX_DBG_DXE, "TX_ACK status requested\n");
 		spin_lock_irqsave(&wcn->dxe_lock, flags);
-- 
1.7.10.4

