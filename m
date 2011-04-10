Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51285 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1DJTJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 15:09:53 -0400
Message-ID: <4DA2007E.4000307@gmail.com>
Date: Sun, 10 Apr 2011 21:09:50 +0200
From: roel <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_hw: index out of bounds
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check whether index is within bounds before testing the element

Both spurChans arrays in modalHeader5G and modalHeader2G have 5 elements,
AR_EEPROM_MODAL_SPURS is defined 5. So unless a break occurs, in the
last iteration (i=5) we tried to access spurChansPtr[5] before testing
whether i was within bounds. Fix this.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index eb250d6..93398de 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -401,7 +401,7 @@ static void ar9003_hw_spur_mitigate_ofdm(struct ath_hw *ah,
 
 	ar9003_hw_spur_ofdm_clear(ah);
 
-	for (i = 0; spurChansPtr[i] && i < 5; i++) {
+	for (i = 0; i < AR_EEPROM_MODAL_SPURS && spurChansPtr[i]; i++) {
 		freq_offset = FBIN2FREQ(spurChansPtr[i], mode) - synth_freq;
 		if (abs(freq_offset) < range) {
 			ar9003_hw_spur_ofdm_work(ah, chan, freq_offset);
