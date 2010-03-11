Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:17055 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0CKHQe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 02:16:34 -0500
Subject: Re: question about ath9k/hw.c,mac.c
From: Pavel Roskin <proski@gnu.org>
To: Julia Lawall <julia@diku.dk>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1003101325500.24684@ask.diku.dk>
References: <Pine.LNX.4.64.1003101325500.24684@ask.diku.dk>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 02:16:32 -0500
Message-Id: <1268291792.6951.34.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-03-10 at 13:36 +0100, Julia Lawall wrote:

> mac.c contains the following code:
> 
> omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);
...
> Is it correct that the call to ath9k_hw_set_interrupts is masking out what 
> appears to be the flag AR_IMR_RXINTM?

Thank you for asking this question!

I checked the code, and I see several cases when
ath9k_hw_set_interrupts() is called with constants beginning with
"ATH9K_INT_" in the second argument.

On the other hand, the use of ah->mask_reg appears to be inconsistent
across the code.  Sometimes it's used with "ATH9K_INT_", sometimes with
"AR_IMR_".

While at that, using enum ath9k_int appears to be a bad idea, especially
for storing values that don't fit int, such as ATH9K_INT_GLOBAL.  If the
goal is to use sparse to check for errors, I would use bitwise types
like gfp_t.  Perhaps sparse could be patched to allow mutually
incompatible bitwise types.

My guess is that ath9k_hw_init_interrupt_masks() should be using a local
variable instead of ah->mask_reg:

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1fb14ed..97cc35f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1134,23 +1134,23 @@ static void ath9k_hw_init_chain_masks(struct ath_hw *ah)
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
 					  enum nl80211_iftype opmode)
 {
-	ah->mask_reg = AR_IMR_TXERR |
+	u32 imr_mask = AR_IMR_TXERR |
 		AR_IMR_TXURN |
 		AR_IMR_RXERR |
 		AR_IMR_RXORN |
 		AR_IMR_BCNMISC;
 
 	if (ah->config.rx_intr_mitigation)
-		ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
+		imr_mask |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
 	else
-		ah->mask_reg |= AR_IMR_RXOK;
+		imr_mask |= AR_IMR_RXOK;
 
-	ah->mask_reg |= AR_IMR_TXOK;
+	imr_mask |= AR_IMR_TXOK;
 
 	if (opmode == NL80211_IFTYPE_AP)
-		ah->mask_reg |= AR_IMR_MIB;
+		imr_mask |= AR_IMR_MIB;
 
-	REG_WRITE(ah, AR_IMR, ah->mask_reg);
+	REG_WRITE(ah, AR_IMR, imr_mask);
 	ah->imrs2_reg |= AR_IMR_S2_GTT;
 	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
 

-- 
Regards,
Pavel Roskin
