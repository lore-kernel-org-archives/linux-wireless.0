Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp117.mail.mud.yahoo.com ([209.191.84.166]:43537 "HELO
	smtp117.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751704AbYGXLHJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 07:07:09 -0400
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Kernel WARNING: at net/core/dev.c:1330 __netif_schedule+0x2c/0x98()
Date: Thu, 24 Jul 2008 21:06:51 +1000
Cc: peterz@infradead.org, davem@davemloft.net, jarkao2@gmail.com,
	Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, mingo@redhat.com,
	paulmck@linux.vnet.ibm.com
References: <1216890648.7257.258.camel@twins> <200807242038.36693.nickpiggin@yahoo.com.au> <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KLyUI-0006ZS-Cg@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807242106.52672.nickpiggin@yahoo.com.au> (sfid-20080724_130722_512184_33B0E1F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 July 2008 20:55, Miklos Szeredi wrote:
> On Thu, 24 Jul 2008, Nick Piggin wrote:
> > Hey, something kind of cool (and OT) I've just thought of that we can
> > do with ticket locks is to take tickets for 2 (or 64K) nested locks,
> > and then wait for them both (all), so the cost is N*lock + longest spin,
> > rather than N*lock + N*avg spin.
>
> Isn't this deadlocky?
>
> E.g. one task takes ticket x=1, then other task comes in and takes x=2
> and y=1, then first task takes y=2.  Then neither can actually
> complete both locks.

Oh duh of course you still need mutual exclusion from the first lock
to order the subsequent :P

So yeah it only works for N > 2 locks, and you have to spin_lock the
first one... so unsuitable for scheduler.
