Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53499 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab1EaTrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:51 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 13/32] ath9k: fix channel frequency calculation for AR9340
Date: Tue, 31 May 2011 21:37:04 +0200
Message-Id: <1306870643-7935-14-git-send-email-juhosg@openwrt.org> (sfid-20110531_214846_444351_2B1B9FB7)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A multiplication is missing from the current formula.

Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2df72cb..1194eeb 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -104,7 +104,7 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			u32 chan_frac;
 
 			channelSel = (freq * 2) / 75;
-			chan_frac = ((freq % 75) * 0x20000) / 75;
+			chan_frac = (((freq * 2) % 75) * 0x20000) / 75;
 			channelSel = (channelSel << 17) | chan_frac;
 		} else {
 			channelSel = CHANSEL_5G(freq);
-- 
1.7.2.1

