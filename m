Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway31.websitewelcome.com ([192.185.144.29]:23113 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751424AbdFZXsx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 19:48:53 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 411FC2FD9F
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jun 2017 18:27:00 -0500 (CDT)
Date: Mon, 26 Jun 2017 18:26:58 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] ath9k: remove useless variable assignment in ath_mci_intr()
Message-ID: <20170626232658.GA17483@embeddedgus> (sfid-20170627_014857_084039_B7A99330)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Value assigned to variable offset at line 551 is overwritten at line 562,
before it can be used. This makes such variable assignment useless.

Addresses-Coverity-ID: 1226941
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 66596b9..cf23fd8 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -548,7 +548,7 @@ void ath_mci_intr(struct ath_softc *sc)
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO) {
 		mci_int_rxmsg &= ~AR_MCI_INTERRUPT_RX_MSG_SCHD_INFO;
-		offset = ar9003_mci_state(ah, MCI_STATE_LAST_SCHD_MSG_OFFSET);
+		ar9003_mci_state(ah, MCI_STATE_LAST_SCHD_MSG_OFFSET);
 	}
 
 	if (mci_int_rxmsg & AR_MCI_INTERRUPT_RX_MSG_GPM) {
-- 
2.5.0
