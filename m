Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50659 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab0DFTFJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 15:05:09 -0400
Message-ID: <4BBB85DD.10409@openwrt.org>
Date: Tue, 06 Apr 2010 12:05:01 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: fix double calls to ath_radio_enable
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the enable_radio being uninitialized, ath_radio_enable() might be
called twice, which can leave some hardware in an undefined state.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1572,8 +1572,7 @@ static int ath9k_config(struct ieee80211
 		all_wiphys_idle =  ath9k_all_wiphys_idle(sc);
 		ath9k_set_wiphy_idle(aphy, idle);

-		if (!idle && all_wiphys_idle)
-			enable_radio = true;
+		enable_radio = (!idle && all_wiphys_idle);

 		/*
 		 * After we unlock here its possible another wiphy
