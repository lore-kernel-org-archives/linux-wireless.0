Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3943 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab3ABOXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:07 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/18] brcmsmac: remove dead code
Date: Wed, 2 Jan 2013 15:22:37 +0100
Message-ID: <1357136572-18273-5-git-send-email-arend@broadcom.com> (sfid-20130102_152322_349267_F96957AD)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Piotr Haber <phaber@broadcom.com>

Dead code after AMPDU restructure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    7 ++-----
 drivers/net/wireless/brcm80211/brcmsmac/scb.h   |    1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 1de94f3..1585cc5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -961,7 +961,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
 			    && isset(bitmap, bindex)) {
-				ini->tx_in_transit--;
 				ini->txretry[index] = 0;
 
 				/*
@@ -990,7 +989,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				int ret;
 				ini->txretry[index]++;
-				ini->tx_in_transit--;
 				ret = brcms_c_txfifo(wlc, queue, p);
 				/*
 				 * We shouldn't be out of space in the DMA
@@ -1000,7 +998,6 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				WARN_ONCE(ret, "queue %d out of txds\n", queue);
 			} else {
 				/* Retry timeout */
-				ini->tx_in_transit--;
 				ieee80211_tx_info_clear_status(tx_info);
 				tx_info->status.ampdu_ack_len = 0;
 				tx_info->status.ampdu_len = 1;
@@ -1009,8 +1006,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				skb_pull(p, D11_PHY_HDR_LEN);
 				skb_pull(p, D11_TXH_LEN);
 				brcms_dbg_ht(wlc->hw->d11core,
-					     "BA Timeout, seq %d, in_transit %d\n",
-					     seq, ini->tx_in_transit);
+					     "BA Timeout, seq %d\n",
+					     seq);
 				ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw,
 							    p);
 			}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/scb.h b/drivers/net/wireless/brcm80211/brcmsmac/scb.h
index 51c79c7..3a3d736 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/scb.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/scb.h
@@ -36,7 +36,6 @@
 
 /* structure to store per-tid state for the ampdu initiator */
 struct scb_ampdu_tid_ini {
-	u8 tx_in_transit; /* number of pending mpdus in transit in driver */
 	u8 tid;		  /* initiator tid for easy lookup */
 	/* tx retry count; indexed by seq modulo */
 	u8 txretry[AMPDU_TX_BA_MAX_WSIZE];
-- 
1.7.10.4


