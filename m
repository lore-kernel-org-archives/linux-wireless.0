Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37648 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab1KZIhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 03:37:37 -0500
Received: by vbbfc26 with SMTP id fc26so2672045vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Nov 2011 00:37:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322246431-10825-2-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
	<1322246431-10825-2-git-send-email-mickflemm@gmail.com>
Date: Sat, 26 Nov 2011 16:37:36 +0800
Message-ID: <CAJ-Vmom6LyS173ZgH_6kODx5pmG0k_8CCgBKmCPFd_8=vwiJPw@mail.gmail.com> (sfid-20111126_093740_327904_CE004E93)
Subject: Re: [PATCH v2 01/12] ath5k: Switch from read-and-clear to
 write-to-clear method when handling PISR/SISR registers
From: Adrian Chadd <adrian@freebsd.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Review #2:

One thing that I discovered whilst debugging some silly races in
FreeBSD was that the update of the txq active mask wasn't done
atomically.

Ie, when you check this:

+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1689,7 +1689,7 @@ ath5k_tasklet_tx(unsigned long data)
       struct ath5k_hw *ah = (void *)data;

       for (i = 0; i < AR5K_NUM_TX_QUEUES; i++)
-               if (ah->txqs[i].setup && (ah->ah_txq_isr & BIT(i)))
+               if (ah->txqs[i].setup && (ah->ah_txq_isr_txok_all & BIT(i)))
                       ath5k_tx_processq(ah, &ah->txqs[i]);

The way that the original code did it was:

* update the HAL TX mask bits inside the HAL getisr routine, so it
would just update the HAL idea of txqactive;
* Then, ath_hal_gettxintrtxqs() would pass back to the driver the set
of txq bits currently active, and reset those that are active (with a
mask, so you can read only a few)
* the ath_intr() routine would simply schedule a tasklet call when a
TX interrupt came in;
* .. and then the TX completion tasklet would call
ath_hal_gettxintrtxqs() for each task bit to see if it needed
servicing.

Now, in previous generations of hardware/kernel, this may not have
raced - ath_intr() may have been a "fast" interrupt handler and thus
would occur atomically on a single CPU - so you don't have any races.
But these days, ath_intr() is just a software interrupt and can occur
in parallel with another CPU executing the completion handler.

So since there was no locking around the TXQ bit updates and clear, it
was very possible that a very busy TX device would "miss" TX queue
notifications, as the CPU running the TX completion would
read-and-clear the TXQ active bits in the HAL, whilst another CPU was
running ath_intr() which was trying to do a read/modify/write of those
same bits.

I _think_ felix fixed this in ath9k by hiding this stuff behind the
PCU lock. I've also fixed it in FreeBSD. I think it's worth
re-evaluating what is going on in ath5k and maybe add some similar
locking.

Oh wait. Where are you clearing these bits? It doesn't look like
you're even clearing the ah_txq_isr bits in the most recent ath5k tree
I have here. This means you're likely not missing events; but you're
likely always scanning those queues. Making this code a bit pointless.
:)

Anyway, I'd tidy this all up in a subsequent patchset. Get the
interrupt changes in, then figure out how to properly lock the
interrupt TXQ bit set path (the isr) and the clear path (once you've
tested whether the TXQ needed servicing and then cleared the bit.)

HTH,


adrian
