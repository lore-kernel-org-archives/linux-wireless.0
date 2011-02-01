Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab1BAXsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 18:48:18 -0500
Received: by bwz15 with SMTP id 15so31636bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 15:48:17 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Feb 2011 18:48:17 -0500
Message-ID: <AANLkTi=T4QEE2OPyd9mNmNd++vSVGPj_PBm6a4aX5dEx@mail.gmail.com>
Subject: how to get PHY error codes from AR9382 / HB116
From: George Nychis <gnychis@cmu.edu>
To: linux-wireless@vger.kernel.org, Eric Rozner <erozner@cs.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have an Atheros AR9382 chipset, on the 2x2 HB116.

I was wondering if anyone knows how to enable PHY error codes on this
card/chipset being passed up.  Including synchronization errors, like
in the PLCP.

In: drivers/net/wireless/ath/ath9k/hw.c, and function: void
ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
... I did a REG_WRITE(ah, AR_PHY_ERR, 0xffffffff); to enable all phy
error packets upwards in terms of the RX filter.

I am also setting the following in ath9k_hw_ani_init
(drivers/net/wireless/ath/ath9k/ani.c)
  REG_WRITE(ah, AR_PHY_ERR_1, ah->ani[0].ofdmPhyErrBase);
  REG_WRITE(ah, AR_PHY_ERR_2, ah->ani[0].cckPhyErrBase);

I am also commented this out in drivers/net/wireless/ath/ath9k/recv.c:
  rfilt |= ATH9K_RX_FILTER_PHYERR;

I've also tried forcing the card in to promiscuous mode.

However, when I get errored packets up from the card, they all have
the same error type which is 0x00, which makes me believe that the
actual error bits are not being set, or something along these lines.

Does anyone know what I might be missing?  I'd greatly appreciate any help.

- George
