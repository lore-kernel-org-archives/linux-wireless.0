Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2933 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1H3Lva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 07:51:30 -0400
Date: Tue, 30 Aug 2011 07:50:22 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com, lrodriguez@atheros.com,
	Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH] ath5k: Invoke irqsafe version of ieee80211_tx_status()
 to avoid deadlock
Message-ID: <20110830115022.GA22125@hash.lan> (sfid-20110830_135133_055948_96BF34A0)
References: <1314236064-6339-1-git-send-email-thomas@cozybit.com>
 <20110826142210.GE2579@tuxdriver.com>
 <CAG6hwVM8t=v0_xZuKf-nodZR77R0S8nSUgea9QM5S-vB4h_8jg@mail.gmail.com>
 <CAEKwDSAXDgUY_Mc2A75x=-1VEMLF3Kd+=dgJOaBs+XOFn58dYw@mail.gmail.com>
 <CAG6hwVMYaxsY6XcwbU9_nNMCEO0pC_RiQU-QJBPbpdxO9g4rnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAG6hwVMYaxsY6XcwbU9_nNMCEO0pC_RiQU-QJBPbpdxO9g4rnA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 11:13:10AM -0700, Thomas Pedersen wrote:
> I meant to say "In addition to the above discussion,
> ieee80211_tx_status() should not be called from interrupt context
> anyway".
> 
> > the very change the patch added.  It's running in a bottom half
> > though, not a hard irq.
> 
> Even in a bottom half we're still in "interrupt" context, right?

Yes, but my interpretation is that _irqsafe() in this case refers to
hard irq context and not softirq context.  So it's still atomic,
but tx_status() does things like kfree_skb() directly instead of
deferring that to another softirq.

There are 3 contexts in Linux: process, softirq, and hardirq, and
given that we have 3 corresponding tx_status functions (tx_status_ni,
tx_status, tx_status_irqsafe), this interpretation makes sense, no?
Someone correct me if I'm wrong here.

It seems to me this patch warrants some discussion or some comments
in the .h files about how drivers can be called back into themselves;
otherwise it's very hard for a driver writer to get locking right
without examining the stack.

And dropping locks around various API calls means you have to validate
the protected state when you get the lock back, it's not a panacea.

-- 
Bob Copeland %% www.bobcopeland.com

