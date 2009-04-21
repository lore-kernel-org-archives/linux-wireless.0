Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37902 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZDUL5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 07:57:44 -0400
Received: by bwz7 with SMTP id 7so1715098bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 04:57:42 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Apr 2009 14:57:42 +0300
Message-ID: <b25312890904210457u1fffa553sa661d5b093a6e80f@mail.gmail.com> (sfid-20090421_135746_848217_7C9C959B)
Subject: [PATCH ] mwl8: fix build warning.
From: Rami Rosen <roszenrami@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>, buytenh@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a build warning in mwl8.c.
(Marvell TOPDOG wireless driver)

The warning it fixes is: "large integer implicitly truncated to unsigned type."


Signed-off-by: Rami Rosen <ramirose@gmail.com>

--
(wireless-next)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 57a0268..8bc016c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -893,8 +893,7 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw,
int index)
 		rx_desc->next_rx_desc_phys_addr =
 			cpu_to_le32(rxq->rx_desc_dma
 						+ nexti * sizeof(*rx_desc));
-		rx_desc->rx_ctrl =
-			cpu_to_le32(MWL8K_RX_CTRL_OWNED_BY_HOST);
+		rx_desc->rx_ctrl = MWL8K_RX_CTRL_OWNED_BY_HOST;
 	}

 	return 0;
