Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34798 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbZHCTZL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 15:25:11 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2009 12:25:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/24] ath9k: rename  ath9k_hw_set_defaults() to ath9k_hw_init_config()
Date: Mon, 3 Aug 2009 12:24:43 -0700
Message-ID: <1249327496-24629-12-git-send-email-lrodriguez@atheros.com>
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
index 6aee570..31ec83d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -388,7 +388,7 @@ static const char *ath9k_hw_devname(u16 devid)
 	return NULL;
 }
 
-static void ath9k_hw_set_defaults(struct ath_hw *ah)
+static void ath9k_hw_init_config(struct ath_hw *ah)
 {
 	int i;
 
@@ -655,7 +655,7 @@ int ath9k_hw_attach(struct ath_hw *ah)
 	}
 
 	ath9k_hw_init_defaults(ah);
-	ath9k_hw_set_defaults(ah);
+	ath9k_hw_init_config(ah);
 
 	if (!ath9k_hw_set_reset_reg(ah, ATH9K_RESET_POWER_ON)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL, "Couldn't reset chip\n");
-- 
1.6.3.3

