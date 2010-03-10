Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:45677 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab0CJMgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 07:36:45 -0500
Date: Wed, 10 Mar 2010 13:36:43 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: question about ath9k/hw.c,mac.c
Message-ID: <Pine.LNX.4.64.1003101325500.24684@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw.c contains the following code:

static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
                                          enum nl80211_iftype opmode)
{
        ah->mask_reg = AR_IMR_TXERR |
                AR_IMR_TXURN |
                AR_IMR_RXERR |
                AR_IMR_RXORN |
                AR_IMR_BCNMISC;

        if (ah->intr_mitigation)
                ah->mask_reg |= AR_IMR_RXINTM | AR_IMR_RXMINTR;
        else
                ah->mask_reg |= AR_IMR_RXOK;
...
}

mac.c contains the following code:

omask = ath9k_hw_set_interrupts(ah, ah->mask_reg & ~ATH9K_INT_GLOBAL);

ATH9K_INT_GLOBAL is 0x80000000 (hw.h)

reg.h contains the following definitions:

#define AR_IMR_TXMINTR       0x00080000
#define AR_IMR_RXMINTR       0x01000000
#define AR_IMR_TXINTM        0x40000000
#define AR_IMR_RXINTM        0x80000000

Is it correct that the call to ath9k_hw_set_interrupts is masking out what 
appears to be the flag AR_IMR_RXINTM?  I don't know enough about the code 
to know what it all means, but at least in the definition of the mask_reg 
field in hw.c, AR_IMR_RXINTM seems to be used in a manner that is quite 
parallel to AR_IMR_RXMINTR, and AR_IMR_RXINTM seems to be conceptually 
similar to AR_IMR_TXINTM, but neither of them is masked out.

thanks,
julia

