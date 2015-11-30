Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37868 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbbK3XB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 18:01:59 -0500
From: greearb@candelatech.com
To: ath6kl@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath6kl:  fix tx/rx antenna reporting for 2x2 devices.
Date: Mon, 30 Nov 2015 15:01:47 -0800
Message-Id: <1448924508-25672-1-git-send-email-greearb@candelatech.com> (sfid-20151201_000206_328532_7E671347)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

My previous patch incorrectly reported the antenna
for 2x2 devices.  It should be a mask instead of
a numeric count.  This patch fixes that.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5e982e2..3ce2584 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3931,8 +3931,8 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[1] = 0xff;
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[1] = 0xff;
-		ar->hw.tx_ant = 2;
-		ar->hw.rx_ant = 2;
+		ar->hw.tx_ant = 0x3; /* mask, 2 antenna */
+		ar->hw.rx_ant = 0x3;
 	} else {
 		ath6kl_band_2ghz.ht_cap.mcs.rx_mask[0] = 0xff;
 		ath6kl_band_5ghz.ht_cap.mcs.rx_mask[0] = 0xff;
-- 
2.4.3

