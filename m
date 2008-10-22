Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42476 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbYJWD2x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 23:28:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 20:28:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath9k: enable RX interrupt mitigation
Date: Wed, 22 Oct 2008 13:28:44 -0700
Message-ID: <1224707325-13101-2-git-send-email-lrodriguez@atheros.com> (sfid-20081023_052913_448705_6F04C15C)
In-Reply-To: <1224707325-13101-1-git-send-email-lrodriguez@atheros.com>
References: <1224707325-13101-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables hardware interrupt mitigation on RX.
It should alleviate system interrupt load intelligently.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 62e44a0..934b800 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -345,7 +345,7 @@ static void ath9k_hw_set_defaults(struct ath_hal *ah)
 		ah->ah_config.spurchans[i][1] = AR_NO_SPUR;
 	}
 
-	ah->ah_config.intr_mitigation = 0;
+	ah->ah_config.intr_mitigation = 1;
 }
 
 static void ath9k_hw_override_ini(struct ath_hal *ah,
-- 
1.5.6.3

