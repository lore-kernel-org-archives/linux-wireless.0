Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36323 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2G1OdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 10:33:14 -0400
Received: by weyx8 with SMTP id x8so2692055wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 07:33:13 -0700 (PDT)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 2/4] ath5k: Fix range scaling when setting rate power table
Date: Sat, 28 Jul 2012 17:32:49 +0300
Message-Id: <1343485971-31360-2-git-send-email-mickflemm@gmail.com> (sfid-20120728_163351_008780_20A9BE89)
In-Reply-To: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rates[i] is unsigned but txp_offset can be negative for newer parts
with PDADC table. We cover the case when rates[i] + txp_offset > 63
but we must also cover the case when its < 0 or else rates[i] will underflow.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index aa1a77d..84a9aaf 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -3516,6 +3516,7 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 {
 	unsigned int i;
 	u16 *rates;
+	s16 rate_idx_scaled = 0;
 
 	/* max_pwr is power level we got from driver/user in 0.5dB
 	 * units, switch to 0.25dB units so we can compare */
@@ -3580,10 +3581,13 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 	 * match the power range set by user with the power indices
 	 * on PCDAC/PDADC table */
 	for (i = 0; i < 16; i++) {
-		rates[i] += ah->ah_txpower.txp_offset;
+		rate_idx_scaled = rates[i] + ah->ah_txpower.txp_offset;
 		/* Don't get out of bounds */
-		if (rates[i] > 63)
-			rates[i] = 63;
+		if (rate_idx_scaled > 63)
+			rate_idx_scaled = 63;
+		if (rate_idx_scaled < 0)
+			rate_idx_scaled = 0;
+		rates[i] = rate_idx_scaled;
 	}
 }
 
-- 
1.7.3.4

