Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:37577 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbZGFNQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 09:16:53 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
Date: Mon, 6 Jul 2009 15:16:50 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <200907040053.05654.chunkeey@web.de> <200907060005.55329.chunkeey@web.de> <4A51553B.9050204@lwfinger.net>
In-Reply-To: <4A51553B.9050204@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907061516.50254.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 July 2009 03:36:59 Larry Finger wrote:
> Christian Lamparter wrote:
> 
> > hmm, can you please give this a go? (I hope this patch still applies...)
> > I'm curious if you can dump the tx_queue when p54_alloc_skb fail?
> 
> The patch applied with the aid of wiggle.
yeah, I don't want to delay these changes... so they are based on top of
the last _official_ patches, rather than the experimental ones.

> Since adding it, I've had 7 of the disassociation failures, but none of the
> queue len problems.
ohh, forgot to add that...
- do you think you can add another p54_dump_tx_queue
  when it "disassociates". I'm curious if the queue was empty or is full
  (with what?!)

> I have modified every place that p54_alloc_skb() fails with a printk
> that tells why it failed and then calls p54_dump_tx_queue(), but I
> have not gotten to test it yet. I found an oops when 2.6.31-rc2 is
> booted that I'm bisecting right now.
yeah, in the mean time I'll get these fixes to linville.

Regards,
	Chr
