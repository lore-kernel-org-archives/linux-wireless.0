Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53496 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab1EaTru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:50 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 23/32] ath9k: add a missing case statement to ath_ant_div_comb_alt_check
Date: Tue, 31 May 2011 21:37:14 +0200
Message-Id: <1306870643-7935-24-git-send-email-juhosg@openwrt.org> (sfid-20110531_214852_471183_D586F4C1)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'ar9003_hw_antdiv_comb_conf_get' function sets div_group to 2
however that value is not used in 'ath_ant_div_comb_alt_check'.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 07e35e5..d0af2f2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -39,6 +39,7 @@ static inline bool ath_ant_div_comb_alt_check(u8 div_group, int alt_ratio,
 			result = true;
 		break;
 	case 1:
+	case 2:
 		if ((((curr_main_set == ATH_ANT_DIV_COMB_LNA2) &&
 			(curr_alt_set == ATH_ANT_DIV_COMB_LNA1) &&
 				(alt_rssi_avg >= (main_rssi_avg - 5))) ||
-- 
1.7.2.1

