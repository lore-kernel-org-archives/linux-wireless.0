Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-i4.informatik.RWTH-Aachen.DE ([137.226.12.21]:54639 "EHLO
	mail-i4.informatik.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbXJ3VUu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 17:20:50 -0400
Received: from info-4.informatik.rwth-aachen.de (cronos.info-4.informatik.rwth-aachen.de [137.226.12.31])
	by mail-i4.informatik.rwth-aachen.de (Postfix) with ESMTP id 7C900980CC
	for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 22:20:49 +0100 (CET)
Date: Tue, 30 Oct 2007 22:20:56 +0100
From: Ulrich Meis <meis@nets.rwth-aachen.de>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: 4word tx descriptor setup doesn't set BUF_LEN
Message-ID: <20071030212056.GB10233@nets.rwth-aachen.de> (sfid-20071030_212057_218294_7255857B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This line got lost when the descriptor setup and fill functions were
merged. Applies ontop of Nick's patches.

Changes-licensed-under: ISC
Signed-off-by: Ulrich Meis <meis@nets.rwth-aachen.de>
---
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 7b9920c..50ceab0 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -3641,6 +3641,8 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
        if (buff_len & ~AR5K_4W_TX_DESC_CTL1_BUF_LEN)
                return -EINVAL;

+       tx_desc->tx_control_1 = buff_len & AR5K_4W_TX_DESC_CTL1_BUF_LEN;
+
        tx_desc->tx_control_0 |=
                AR5K_REG_SM(tx_power, AR5K_4W_TX_DESC_CTL0_XMIT_POWER) |
                AR5K_REG_SM(antenna_mode, AR5K_4W_TX_DESC_CTL0_ANT_MODE_XMIT);
