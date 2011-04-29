Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47097 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1D2Spx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 14:45:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: me@bobcopeland.com, mickflemm@gmail.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: fix uninitialized var warning for txf2txs
Date: Fri, 29 Apr 2011 14:36:43 -0400
Message-Id: <1304102203-27321-1-git-send-email-linville@tuxdriver.com> (sfid-20110429_204600_675576_A1E786E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath/ath5k/reset.o
drivers/net/wireless/ath/ath5k/reset.c: In function ‘ath5k_hw_init_core_clock’:
drivers/net/wireless/ath/ath5k/reset.c:100:51: warning: ‘txf2txs’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 8420689..3510de2 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -159,6 +159,11 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 	rxlat = AR5K_REG_MS(usec_reg, AR5K_USEC_RX_LATENCY_5211);
 
 	/*
+	 * Set default Tx frame to Tx data start delay
+	 */
+	txf2txs = AR5K_INIT_TXF2TXD_START_DEFAULT;
+
+	/*
 	 * 5210 initvals don't include usec settings
 	 * so we need to use magic values here for
 	 * tx/rx latencies
-- 
1.7.4.4

