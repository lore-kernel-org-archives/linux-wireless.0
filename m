Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:48685 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaGMKSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:38 -0400
Received: by mail-we0-f172.google.com with SMTP id x48so1124477wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 09/10] ath9k: disable dynack algorithm when coverage class is set
Date: Sun, 13 Jul 2014 12:18:23 +0200
Message-Id: <1405246704-7489-10-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121849_173578_CE69B6E7)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ack timeout estimation algorithm if the coverage class has been
configured

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..689db57 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1969,6 +1969,7 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
+	ah->dynack.enabled = false;
 
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_init_global_settings(ah);
-- 
1.9.1

