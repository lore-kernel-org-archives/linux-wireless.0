Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:62424 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGGJb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:57 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so4082596wes.29
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:55 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 09/10] ath9k: disable dynack algorithm when coverage class is set
Date: Mon,  7 Jul 2014 11:31:45 +0200
Message-Id: <1404725506-9571-10-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113208_575656_289E6208)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable ack timeout estimation algorithm if the coverage class has been
configured

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..5d8af08 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1969,6 +1969,7 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
+	ah->dynack.fix_to = true;
 
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_init_global_settings(ah);
-- 
1.9.1

