Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27321 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZG2Jmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:42:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 02:42:55 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/3] ath9k: Update rate control for 11NA HT40 mode
Date: Wed, 29 Jul 2009 15:05:21 +0530
Message-ID: <1248860123-12079-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now the lowest rate in 11na ht40 mode is 13.5Mbps this shortens the
range when compared to 11na ht20 mode where the lowest rate is 6.5Mbps.
To improve the range, make 6.5Mbps as the lowest rate in 11na ht40 mode,
this improves the range by approximately 2dB. 11ng ht40 does not have
this issue as it also has basic rates (1, 2, 5.5 and 11).

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index a07efa2..59ad47c 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -44,7 +44,7 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 54000, /* 54 Mb */
 			29300, 0x0c, 0x00, 108,
 			4,  7, 7, 7, 7, 0 },
-		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
+		{ VALID_2040, VALID_2040, WLAN_RC_PHY_HT_20_SS, 6500, /* 6.5 Mb */
 			6400, 0x80, 0x00, 0,
 			0, 8, 24, 8, 24, 3216 },
 		{ VALID_20, VALID_20, WLAN_RC_PHY_HT_20_SS, 13000, /* 13 Mb */
@@ -463,8 +463,6 @@ static int ath_rc_valid_phyrate(u32 phy, u32 capflag, int ignore_cw)
 	if (!ignore_cw && WLAN_RC_PHY_HT(phy))
 		if (WLAN_RC_PHY_40(phy) && !(capflag & WLAN_RC_40_FLAG))
 			return 0;
-		if (!WLAN_RC_PHY_40(phy) && (capflag & WLAN_RC_40_FLAG))
-			return 0;
 	return 1;
 }
 
-- 
1.5.5.1

