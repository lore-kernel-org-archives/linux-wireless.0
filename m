Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47503 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbZAZOtE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 09:49:04 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 06:49:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: fix debug print on regd
Date: Mon, 26 Jan 2009 06:48:10 -0800
Message-ID: <1232981290-16741-1-git-send-email-lrodriguez@atheros.com> (sfid-20090126_154910_057478_BA4CA9B4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With debugging enabled and with ATH_DBG_REGULATORY
selected we wouldn't get the full print out of one line,
reason is we used "," instead of nothing to separate two
lines.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 90f0c98..ec88f78 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -447,7 +447,7 @@ int ath9k_regd_init(struct ath_hal *ah)
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		"Country alpha2 being used: %c%c\n",
+		"Country alpha2 being used: %c%c\n"
 		"Regpair detected: 0x%0x\n",
 		ah->alpha2[0], ah->alpha2[1],
 		ah->regpair->regDmnEnum);
-- 
1.5.6.4

