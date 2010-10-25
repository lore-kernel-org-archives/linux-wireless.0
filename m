Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51107 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0JYPhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 11:37:07 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 08:36:56 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<j@w1.fi>, <Senthilkumar.Balasubramanian@Atheros.com>,
	<Vasanth.Thiagarajan@Atheros.com>, <nbd@openwrt.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC] ath9k: Fix incorrect access of rate flags in RC
Date: Mon, 25 Oct 2010 21:06:44 +0530
Message-ID: <1288021004-7315-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The index variable to access the rate flags should be obtained from the
inner loop counter which corresponds to rate table structure.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0cee90c..89978d7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -527,7 +527,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
-			u16 rate_flags = rate_table->info[i].rate_flags;
+			u16 rate_flags = rate_table->info[j].rate_flags;
 			u8 rate = rateset->rs_rates[i];
 			u8 dot11rate = rate_table->info[j].dot11rate;
 
-- 
1.7.0.4

