Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:48674 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 17:41:49 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so1560592wiw.16
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2014 14:41:48 -0700 (PDT)
Message-ID: <539B7019.1050801@gmail.com> (sfid-20140613_234151_987564_E561692A)
Date: Fri, 13 Jun 2014 23:41:45 +0200
From: Mathy Vanhoef <vanhoefm@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 2/2] ath5k: capture CCK and OFDM restarts
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This patch allows users to see CCK and OFDM restarts when FIF_FCSFAIL is set.
Without this patch only the stronger frame (causing the restart) would be
visible.

The patch has been tested using our reactive jammer. The prefix of the weaker
frame is being correctly passed on as a frame with bad CRC!
--
From: "Mathy Vanhoef" <vanhoefm@gmail.com>

Treat frames that underwent a CCK or OFDM restart as frames with an invalid CRC.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 39ba642..1bbc850 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1462,7 +1462,19 @@ ath5k_receive_frame_ok(struct ath5k_hw *ah, struct ath5k_rx_status *rs)
 			ah->stats.rxerr_phy++;
 			if (rs->rs_phyerr > 0 && rs->rs_phyerr < 32)
 				ah->stats.rxerr_phy_code[rs->rs_phyerr]++;
-			return false;
+
+			/*
+			 * Threat packets that underwent a CCK of OFDM reset as having a bad CRC.
+			 * These restarts happen when the radio resynchronizes to a stronger frame
+			 * while receiving a weaker frame. Here we receive the prefix of the weak
+			 * frame. Since these are incomplete packets, mark their CRC as invalid.
+			 */
+			if (rs->rs_phyerr == AR5K_RX_PHY_ERROR_OFDM_RESTART ||
+			    rs->rs_phyerr == AR5K_RX_PHY_ERROR_CCK_RESTART) {
+				rs->rs_status |= AR5K_RXERR_CRC;
+				rs->rs_status &= (~AR5K_RXERR_PHY);
+			}
 		}
 		if (rs->rs_status & AR5K_RXERR_DECRYPT) {
 			/*
-- 
1.8.1.2

