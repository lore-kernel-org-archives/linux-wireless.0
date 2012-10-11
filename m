Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36062 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab2JKQXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 12:23:50 -0400
Received: from bob.linux.org.uk (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q9BGu1K7020637
	for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2012 17:56:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] ath9k: Fix broken conditional
To: linux-wireless@vger.kernel.org
Date: Thu, 11 Oct 2012 17:25:30 +0100
Message-ID: <20121011162525.2643.85972.stgit@bob.linux.org.uk> (sfid-20121011_182353_194992_E61CD0E5)
In-Reply-To: <20121011162505.2643.87138.stgit@bob.linux.org.uk>
References: <20121011162505.2643.87138.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

One stray semicolon...

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 5bbe505..189aeb2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2989,7 +2989,7 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_PAPRD:
 		if (AR_SREV_9462(ah))
 			return false;
-		if (!ah->config.enable_paprd);
+		if (!ah->config.enable_paprd)
 			return false;
 		return !!(pBase->featureEnable & BIT(5));
 	case EEP_CHAIN_MASK_REDUCE:

