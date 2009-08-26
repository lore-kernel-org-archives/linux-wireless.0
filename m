Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45797 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZHZPrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:08 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:10 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/8] ath9k: Configure btcoex register during every reset
Date: Wed, 26 Aug 2009 21:08:45 +0530
Message-ID: <1251301130-10912-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-3-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure btcoex register configured with appropriate values
after it is initialized with the default values from initvals.h
during reset.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c3ecc7e..d7e03f9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2555,6 +2555,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 #endif
 	}
 
+	if (ah->ah_sc->sc_flags & SC_OP_BTCOEX_ENABLED)
+		ath9k_hw_btcoex_enable(ah);
+
 	return 0;
 }
 
-- 
1.5.5.1

