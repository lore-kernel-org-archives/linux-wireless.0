Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10502 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZA2GLK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 01:11:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 22:11:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18817.18343.274643.579953@gargle.gargle.HOWL> (sfid-20090129_071124_459875_3A99A94E)
Date: Thu, 29 Jan 2009 11:37:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fix typo in checking for chip revision
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 7728234..00ed44a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -267,7 +267,7 @@ static int ath9k_hw_get_radiorev(struct ath_hal *ah)
 
 static void ath9k_hw_disablepcie(struct ath_hal *ah)
 {
-	if (!AR_SREV_9100(ah))
+	if (AR_SREV_9100(ah))
 		return;
 
 	REG_WRITE(ah, AR_PCIE_SERDES, 0x9248fc00);
-- 
1.6.1

