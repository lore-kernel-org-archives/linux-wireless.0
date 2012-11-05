Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64819 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab2KEUSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 15:18:08 -0500
Received: by mail-lb0-f174.google.com with SMTP id n3so4583139lbo.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2012 12:18:06 -0800 (PST)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 2/2] ar5523: Don't dereference sta if NULL
Date: Mon,  5 Nov 2012 21:17:51 +0100
Message-Id: <1352146671-4318-2-git-send-email-pontus.fuchs@gmail.com> (sfid-20121105_211825_119816_34DB9D40)
In-Reply-To: <1352146671-4318-1-git-send-email-pontus.fuchs@gmail.com>
References: <1352146671-4318-1-git-send-email-pontus.fuchs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A missing else caused a potential NULL dereference.

Reported-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index bb774b3..c312899 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -1196,8 +1196,8 @@ static void ar5523_create_rateset(struct ar5523 *ar,
 	if (!sta) {
 		ar5523_info(ar, "STA not found. Cannot set rates\n");
 		sta_rate_set = bss_conf->basic_rates;
-	}
-	sta_rate_set = sta->supp_rates[ar->hw->conf.channel->band];
+	} else
+		sta_rate_set = sta->supp_rates[ar->hw->conf.channel->band];
 
 	ar5523_dbg(ar, "sta rate_set = %08x\n", sta_rate_set);
 
-- 
1.7.9.5

