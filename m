Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36727 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbYLILxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 06:53:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 09 Dec 2008 03:53:40 -0800
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>, <ath9k-devel@venema.h4ckr.net>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH] ath9k: BH shouldn't be enabled when hardirqs are disabled.
Date: Tue, 9 Dec 2008 17:23:33 +0530
Message-ID: <1228823614-6193-1-git-send-email-senthilkumar@atheros.com> (sfid-20081209_125347_095359_51A10AD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_tx_complete_buf uses a BH version of spinlock and so releasing
the lock enables BH which is incorrect when called from sta_notify
callback as MAC80211 disables hardirqs before the driver callback
is called.

As ath_tx_complete_buf is shared between user and softirq context
using normal spinlock may not be appropriate. Though the proper
fix would be to cleanup the context properly in the driver code,
this would be an interim fix to avoid kernel warning.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index ec359c6..e2e847d 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -310,6 +310,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ath_xmit_status tx_status;
+	unsigned long flags;
 
 	/*
 	 * Set retry information.
@@ -340,9 +341,9 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
 	 */
-	spin_lock_bh(&sc->sc_txbuflock);
+	spin_lock_irqsave(&sc->sc_txbuflock, flags);
 	list_splice_tail_init(bf_q, &sc->sc_txbuf);
-	spin_unlock_bh(&sc->sc_txbuflock);
+	spin_unlock_irqrestore(&sc->sc_txbuflock, flags);
 }
 
 /*
-- 
1.6.0.4

