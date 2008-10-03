Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52115 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbYJCPKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Oct 2008 11:10:43 -0400
Received: from sapphire.tuxdriver.com ([70.61.120.61] helo=localhost)
	by smtp.tuxdriver.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1KlmIk-0002Ah-6T
	for linux-wireless@vger.kernel.org; Fri, 03 Oct 2008 11:10:42 -0400
Date: Fri, 3 Oct 2008 11:10:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: [mingo@elte.hu: Re: ath9k: panic on tip/master]
Message-ID: <20081003151006.GB3368@tuxdriver.com> (sfid-20081003_171048_739115_6AB15022)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

----- Forwarded message from Ingo Molnar <mingo@elte.hu> -----

> Delivery-date: Fri, 03 Oct 2008 06:03:27 -0400
> Date: Fri, 3 Oct 2008 12:02:11 +0200
> From: Ingo Molnar <mingo@elte.hu>
> To: Steven Noonan <steven@uplinklabs.net>
> Cc: linux-kernel@vger.kernel.org, ath9k-devel@lists.ath9k.org,
> 	lrodriguez@atheros.com
> Subject: Re: ath9k: panic on tip/master
> In-Reply-To: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com>
> List-ID: <linux-kernel.vger.kernel.org>
> X-Mailing-List: linux-kernel@vger.kernel.org
> 
> * Steven Noonan <steven@uplinklabs.net> wrote:
> 
> > Hey folks,
> > 
> > Just got a panic on tip. According to the stack trace, ath9k is what 
> > decided to bomb.
> > 
> > http://www.uplinklabs.net/~tycho/linux/ath9k_panic_tip_10.3.2008.jpg
> > 
> > Note: Although it says 'sudo modprobe radeon' on the bash prompt above 
> > the panic, I never got to hit 'enter' on that command before the panic 
> > occurred.
> 
> it appears to me that ath9k's eth_rx_input() takes a spinlock that is 
> not initialized (or already destroyed by the allocator).
> 
> this would be consistent with an IRQ storm hitting some race in the 
> ath9k driver init sequence. For example if request_irq() is done before 
> all structures that the IRQ handler relies on are properly initialized.
> 
> i.e. this has the signature of a genuine ath9k bug.
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

----- End forwarded message -----

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
