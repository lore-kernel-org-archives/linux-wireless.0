Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52598 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1DHSRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 14:17:15 -0400
Date: Fri, 8 Apr 2011 20:19:46 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Nishant Sarmukadam <nishants@marvell.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mwl8k: interrupt handling changes
Message-ID: <20110408181946.GY22881@wantstofly.org>
References: <1302253707.3447.86.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302253707.3447.86.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 08, 2011 at 02:38:27PM +0530, Nishant Sarmukadam wrote:

> We do not need to enable all the interrupts in mwl8k_probe_hw.
> We need to enable only MWL8K_A2H_INT_OPC_DONE interrupt for sending
> commands to the firmware. Keep the other interrupts masked in
> mwl8k_probe_hw.

This part of the description matches the patch.  But..


> Also, in mwl8k_start, where we expect other interrupts,
> enable only those interrupts we are interested in.

..this comment does not match the code.


>  	/* Enable interrupts */
>  	iowrite32(MWL8K_A2H_EVENTS, priv->regs + MWL8K_HIU_A2H_INTERRUPT_MASK);
> +	iowrite32(MWL8K_A2H_EVENTS,
> +		  priv->regs + MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK);

This writes to the status register.  Why does it do that?
