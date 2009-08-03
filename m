Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34795 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbZHCTZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:09 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 10/24] ath9k: rename ath9k_hw_newstate() to ath9k_hw_init_defaults()
Date: Mon, 3 Aug 2009 12:24:42 -0700
Message-ID: <1249327496-24629-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
References: <1249327496-24629-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reflects better what we are actually doing there.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4f3d7bf..6aee570 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -437,7 +437,7 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
 
-static void ath9k_hw_newstate(struct ath_hw *ah)
+static void ath9k_hw_init_defaults(struct ath_hw *ah)
 {
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->regulatory.country_code = CTRY_DEFAULT;
@@ -654,7 +654,7 @@ int ath9k_hw_attach(struct ath_hw *ah)
 		goto bad;
 	}
 
-	ath9k_hw_newstate(ah);
+	ath9k_hw_init_defaults(ah);
 	ath9k_hw_set_defaults(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
-- 
1.6.3.3

