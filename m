Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35501 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0GTSaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:30:11 -0400
Date: Tue, 20 Jul 2010 14:29:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH] mwl8k: correct/silence sparse warnings
Message-ID: <20100720182903.GA3468@tuxdriver.com>
References: <1279649222-3042-1-git-send-email-linville@tuxdriver.com>
 <1279650123.3706.45.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1279650123.3706.45.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 20, 2010 at 08:22:03PM +0200, Johannes Berg wrote:
> On Tue, 2010-07-20 at 14:07 -0400, John W. Linville wrote:
> 
> >  		off = le32_to_cpu(cmd->rxwrptr) & 0xffff;
> > -		iowrite32(cpu_to_le32(priv->rxq[0].rxd_dma), priv->sram + off);
> > +		iowrite32((__force __u32) cpu_to_le32(priv->rxq[0].rxd_dma),
> > +				priv->sram + off);
> 
> Those don't seem right, it looks more like somebody thought they needed
> to byteswap the iowrite because PCI(e) is little endian, and were wrong?

Yeah, I agree.  I was going with the thought that "it's working, so
I guess it is right".  But then, development was probably done on an
LE system...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
