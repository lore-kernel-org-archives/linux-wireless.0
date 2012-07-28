Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62251 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2G1OdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 10:33:12 -0400
Received: by wibhm11 with SMTP id hm11so512965wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 07:33:11 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 1/4] ath5k: Use correct value for min_pwr and cur_pwr
Date: Sat, 28 Jul 2012 17:32:48 +0300
Message-Id: <1343485971-31360-1-git-send-email-mickflemm@gmail.com> (sfid-20120728_163350_169922_78350151)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure we don't store the table offsets for min and cur power levels,
store the 0.25dB values instead. This way we don't clamp the tx power level
to max (because now cur_pwr holds the 0.25dB value, not the table offset) after
re-using cur_pwr on reset.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 8b71a2d..aa1a77d 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3562,6 +3562,20 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 		for (i = 8; i <= 15; i++)
 			rates[i] -= ah->ah_txpower.txp_cck_ofdm_gainf_delta;
 
+	/* Save min/max and current tx power for this channel
+	 * in 0.25dB units.
+	 *
+	 * Note: We use rates[0] for current tx power because
+	 * it covers most of the rates, in most cases. It's our
+	 * tx power limit and what the user expects to see. */
+	ah->ah_txpower.txp_min_pwr = 2 * rates[7];
+	ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
+
+	/* Set max txpower for correct OFDM operation on all rates
+	 * -that is the txpower for 54Mbit-, it's used for the PAPD
+	 * gain probe and it's in 0.5dB units */
+	ah->ah_txpower.txp_ofdm = rates[7];
+
 	/* Now that we have all rates setup use table offset to
 	 * match the power range set by user with the power indices
 	 * on PCDAC/PDADC table */
@@ -3571,11 +3585,6 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 		if (rates[i] > 63)
 			rates[i] = 63;
 	}
-
-	/* Min/max in 0.25dB units */
-	ah->ah_txpower.txp_min_pwr = 2 * rates[7];
-	ah->ah_txpower.txp_cur_pwr = 2 * rates[0];
-	ah->ah_txpower.txp_ofdm = rates[7];
 }
 
 
-- 
1.7.3.4

