Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:48585 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab1DKGXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 02:23:01 -0400
Subject: Re: [PATCH] mwl8k: interrupt handling changes
From: Nishant Sarmukadam <nishants@marvell.com>
Reply-To: nishants@marvell.com
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110408181946.GY22881@wantstofly.org>
References: <1302253707.3447.86.camel@localhost.localdomain>
	 <20110408181946.GY22881@wantstofly.org>
Content-Type: text/plain
Date: Mon, 11 Apr 2011 11:43:25 +0530
Message-ID: <1302502405.3447.144.camel@localhost.localdomain>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2011-04-08 at 11:19 -0700, Lennert Buytenhek wrote:
> On Fri, Apr 08, 2011 at 02:38:27PM +0530, Nishant Sarmukadam wrote:
> 
> > We do not need to enable all the interrupts in mwl8k_probe_hw.
> > We need to enable only MWL8K_A2H_INT_OPC_DONE interrupt for sending
> > commands to the firmware. Keep the other interrupts masked in
> > mwl8k_probe_hw.
> 
> This part of the description matches the patch.  But..
> 
> 
> > Also, in mwl8k_start, where we expect other interrupts,
> > enable only those interrupts we are interested in.
> 
> ..this comment does not match the code.
> 
> 
> >  	/* Enable interrupts */
> >  	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
> > +	iowrite32(MWL8K_A2H_EVENTS,
> > +		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);
> 
> This writes to the status register.  Why does it do that?

Here we are writing to the 'status mask' register and not the 'status'
register. Interrupts will not be enabled until we write 1's in the
status mask register. Earlier, we were writing 0xffffffff in this
register, whereas enabling only interrupts specified in MWL8K_A2H_EVENTS
should be sufficient since driver is interested in only those
interrupts. Hence the description. 


