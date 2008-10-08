Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:46230 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYJHWsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 18:48:33 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC PATCH] rtl8187: do not report ACKs if USB Tx status is non-zero
Date: Wed, 8 Oct 2008 19:48:46 -0300
Cc: linux-wireless@vger.kernel.org
References: <1223407098-23060-1-git-send-email-linville@tuxdriver.com> <20081008184205.GB32472@tuxdriver.com>
In-Reply-To: <20081008184205.GB32472@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810081948.46977.herton@mandriva.com.br> (sfid-20081009_004837_575962_236D8C35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 October 2008 15:42:05 John W. Linville wrote:
> On Tue, Oct 07, 2008 at 03:18:18PM -0400, John W. Linville wrote:
> > The vendor-supplied driver treats a USB Tx failure as an un-ACKed frame.
> > I don't see why we shouldn't do the same thing -- hopefully this makes
> > rate-scaling algorithms behave sanely with the rtl8187 driver.
> >
> > Thanks to Felix Fietkau <nbd@openwrt.org> for suggesting this as an
> > option.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > This is currently untested -- anyone with rtl8187 bored enough to try
> > it? :-)
>
> AFAICT, this doesn't actually trigger -- at least, the device can
> go into its typical failure mode (no frames ACKed until you force a
> lower rate) without ever hitting the "assume ACK not received" clause.

I tested here and it didn't trigger indeed, here at least urb->status == 0 
always no matter what I tried, which seems normal, only would trigger at some 
not typical usb failure? But there is one thing that I like about the patch, 
seems correct that we shouldn't set IEEE80211_TX_STAT_ACK if 
IEEE80211_TX_CTL_NO_ACK, that is, looks like a bug always setting ack in the 
flags when no_ack is present, not sure if it has some effect in practice 
though (have to look more at the code that cares about info->flags). I would 
say that the patch 'as is' is correct and will not hurt.

>
> I'll keep looking at it -- there are a couple of 'secrets' still
> buried in the vendor driver (if I can stomach to keep looking at it)...

yeah, not very straightforward to grasp the vendor driver unfortunately... 
good would be to have some times docs/explanation about some of the values 
used, when you're luck there is some comments and references at some places.

>
> John

--
[]'s
Herton
