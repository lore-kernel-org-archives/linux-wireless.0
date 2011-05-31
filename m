Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53481 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab1EaTrs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:48 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 14/32] ath9k: configure RF channel frequency for AR9330
Date: Tue, 31 May 2011 21:37:05 +0200
Message-Id: <1306870643-7935-15-git-send-email-juhosg@openwrt.org> (sfid-20110531_214751_014109_FFF92EDB)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1194eeb..a0ca1eb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -75,7 +75,19 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	freq = centers.synth_center;
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
-		if (AR_SREV_9485(ah)) {
+		if (AR_SREV_9330(ah)) {
+			u32 chan_frac;
+			u32 div;
+
+			if (ah->is_clk_25mhz)
+				div = 75;
+			else
+				div = 120;
+
+			channelSel = (freq * 4) / div;
+			chan_frac = (((freq * 4) % div) * 0x20000) / div;
+			channelSel = (channelSel << 17) | chan_frac;
+		} else if (AR_SREV_9485(ah)) {
 			u32 chan_frac;
 
 			/*
-- 
1.7.2.1

