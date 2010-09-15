Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39308 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab0IOT3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:29:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: make ath_ant_div_conf_fast_divbias static
Date: Wed, 15 Sep 2010 15:26:13 -0400
Message-Id: <1284578773-18629-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/ath/ath9k/recv.c
drivers/net/wireless/ath/ath9k/recv.c:1341:6: warning: symbol 'ath_ant_div_conf_fast_divbias' was not declared. Should it be static?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6fb3b45..aa9a14d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1338,7 +1338,7 @@ static void ath_select_ant_div_from_quick_scan(struct ath_ant_comb *antcomb,
 	}
 }
 
-void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
+static void ath_ant_div_conf_fast_divbias(struct ath_hw_antcomb_conf *ant_conf)
 {
 	/* Adjust the fast_div_bias based on main and alt lna conf */
 	switch ((ant_conf->main_lna_conf << 4) | ant_conf->alt_lna_conf) {
-- 
1.7.2.3

