Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23335 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab0G0NrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 09:47:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 06:47:09 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 3/4] ath9k: Fix incorrect user ratekbs of MCS15 ShortGI
Date: Tue, 27 Jul 2010 19:16:33 +0530
Message-ID: <1280238394-2565-3-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1280238394-2565-1-git-send-email-senthilkumar@atheros.com>
References: <1280238394-2565-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The user ratekbs of MCS15 ShortGI is incorrect and can not be lesser
than MCS15 rate. This incorrect rate may affect switching to higher
rates as the rate control algorithm always finds MCS15 is better
than MCS15 ShortGI and results in lower throughput. Fix this by
feeding the correct user ratekbs for MCS15 ShortGI rate.

This issue affects 3 stream case very badly as the 3 stream rates are
not used at all once we scale down to MCS15 from 3 stream rates.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 7b63958..5c9df3b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -74,7 +74,7 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
 		[24] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS, 130000,
 			108300, 15, 15, 4, 23, 54, 25, 55 }, /* 130 Mb */
 		[25] = { RC_HT_DT_20, WLAN_RC_PHY_HT_20_DS_HGI, 144400,
-			12000, 15, 15, 4, 23, 54, 25, 55 }, /* 144.4 Mb */
+			120000, 15, 15, 4, 23, 54, 25, 55 }, /* 144.4 Mb */
 		[26] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 19500,
 			17400, 16, 16, 0, 24, 56, 26, 56 }, /* 19.5 Mb */
 		[27] = {  RC_INVALID, WLAN_RC_PHY_HT_20_TS, 39000,
-- 
1.7.1

