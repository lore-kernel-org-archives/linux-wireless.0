Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:34095 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaILUhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 16:37:19 -0400
Date: Fri, 12 Sep 2014 22:36:51 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k_htc: fix random decryption failure
Message-ID: <20140912203651.GA10815@sig21.net> (sfid-20140912_223722_701200_1346A2AA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In v3.15 the driver stopped to accept network packets after successful
authentification, which could be worked around by passing the
nohwcrypt=1 module parameter.  This was not reproducible by
everyone, and showed random behaviour in some tests.
It was caused by an uninitialized variable introduced
in 4ed1a8d4a257 ("ath9k_htc: use ath9k_cmn_rx_accept") and
used in 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess").

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=78581
Fixes: 341b29b9cd2f ("ath9k_htc: use ath9k_cmn_rx_skb_postprocess")
Signed-off-by: Johannes Stezenbach <js@sig21.net>

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index bb86eb2..f0484b1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -978,7 +978,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_hw *ah = common->ah;
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
-	bool decrypt_error;
+	bool decrypt_error = false;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
 		ath_err(common, "Corrupted RX frame, dropping (len: %d)\n",
