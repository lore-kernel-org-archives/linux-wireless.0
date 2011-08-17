Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59273 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1HQUGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 16:06:50 -0400
Received: by vws1 with SMTP id 1so975009vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 13:06:50 -0700 (PDT)
From: Bill Jordan <bjordan@rajant.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, linville@tuxdriver.com
Cc: Bill Jordan <bjordan@rajant.com>
Subject: [PATCH] ath9k: fix MGMT packets when using TKIP
Date: Wed, 17 Aug 2011 16:06:37 -0400
Message-Id: <1313611597-17662-1-git-send-email-bjordan@rajant.com> (sfid-20110817_220654_104676_BD4AE430)
In-Reply-To: <4E4AF4A4.9090404@openwrt.org>
References: <4E4AF4A4.9090404@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent 8 bytes from being truncated from MGMT packets
when using TKIP.

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7409402..d8737f2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -824,7 +824,8 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	is_mc = !!is_multicast_ether_addr(hdr->addr1);
 	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
 		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
-	strip_mic = is_valid_tkip && !(rx_stats->rs_status &
+	strip_mic = is_valid_tkip && !ieee80211_is_mgmt(fc) &&
+		!(rx_stats->rs_status &
 		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC));
 
 	if (!rx_stats->rs_datalen)
-- 
1.7.6

