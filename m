Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33409 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbZGFOAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 10:00:14 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Mon, 6 Jul 2009 16:00:13 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200907040053.05654.chunkeey@web.de> <73aaf0dd0907060611w5a288828h4c4728f52fe4e16c@mail.gmail.com>
In-Reply-To: <73aaf0dd0907060611w5a288828h4c4728f52fe4e16c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907061600.14196.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 July 2009 15:11:11 Max Filippov wrote:
> > This patch tries to address a long standing issue:
> > how to survive serve memory starvation situations,
> > without losing the device due to missing transfer-buffers.
> 
> Christian, how does placement of skb allocation point make a
> difference?
not all drivers are equal... usb is the critical one.
just take a look at the these lines in p54u_rx_cb

	skb = dev_alloc_skb(priv->common.rx_mtu + 32);
	if (unlikely(!skb)) {
		/* TODO check rx queue length and refill *somewhere* */
		return;
	}

so every time we failed to alloc the replacement skb, we have to
abandon one rx urb, until nothing is left and the user has
to replug/reload. pci is a bit more forgiving, but it can bite as well.
(Note: this scenario is _unlikely_ to happen ever since Larry scaled
 down the rx_mtu from 3240 to about 2400 or so - which makes
 dev_alloc_skb a 0-order allocation on the most common architectures)

> Anyway skb that carry data frame will be handed to the mac
> and replaced with new one. That is, this patch does not eliminate
> possibility of control frame loss due to insufficient memory.
control frames loss?
can you please point me exactly where?
Since this is a bug that needs to be fixed.

as control frames' skb should be (and hopefully are) always reused.
(see @ txrx.c line 590 - p54_rx_control -> return skb; )

> Maybe we'd better have separate reusable skb for control frames which
> is never handed out from the driver?
well as a matter of fact this is already true for p54pci & p54usb
(based on the assumption we are really recycling all control frames...
 and not somehow forgot a case and got a leak there?!)

Regards,
	Chr
