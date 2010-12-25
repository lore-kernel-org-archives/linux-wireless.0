Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46704 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0LYTeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Dec 2010 14:34:44 -0500
Received: by qwa26 with SMTP id 26so7701862qwa.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Dec 2010 11:34:43 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 25 Dec 2010 14:34:43 -0500
Message-ID: <AANLkTin27fmd-4JU07j+O9Wg0sq1H4hpzsTXyHKj9YZP@mail.gmail.com>
Subject: [PATCH] ath9k: fix spur mitigation no-spur case for AR9002
From: Brian Prodoehl <bprodoehl@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the AR9002, the spur frequency read from the EEPROM is mangled
before being compared against AR_NO_SPUR.  This results in the driver
trying to set up the spur mitigation for bogus spurs, rather than
cleanly breaking out.

Signed-off-by: Brian Prodoehl <bprodoehl@nomadio.net>
---

 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 7ae66a8..7d68d61 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -203,13 +203,14 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);

+		if (AR_NO_SPUR == cur_bb_spur)
+			break;
+
 		if (is2GHz)
 			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_2GHZ;
 		else
 			cur_bb_spur = (cur_bb_spur / 10) + AR_BASE_FREQ_5GHZ;

-		if (AR_NO_SPUR == cur_bb_spur)
-			break;
 		cur_bb_spur = cur_bb_spur - freq;

 		if (IS_CHAN_HT40(chan)) {
