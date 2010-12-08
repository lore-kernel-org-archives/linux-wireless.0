Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27187 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0LHObg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 09:31:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 08 Dec 2010 06:31:21 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>
Subject: [PATCH] ath: Missed to clear key4 of micentry
Date: Wed, 8 Dec 2010 20:01:05 +0530
Message-ID: <1291818665-6660-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

key4 of micentry is used, if ATH_CRYPT_CAP_MIC_COMBINED is set.
But is not cleared on key cache reset.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/key.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 29a2961..5d465e5 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -58,6 +58,8 @@ bool ath_hw_keyreset(struct ath_common *common, u16 entry)
 		REG_WRITE(ah, AR_KEYTABLE_KEY1(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY2(micentry), 0);
 		REG_WRITE(ah, AR_KEYTABLE_KEY3(micentry), 0);
+		if (common->crypt_caps & ATH_CRYPT_CAP_MIC_COMBINED)
+			REG_WRITE(ah, AR_KEYTABLE_KEY4(micentry), 0);
 
 	}
 
-- 
1.7.3.3

