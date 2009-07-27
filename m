Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45116 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbZG0NzD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 09:55:03 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MVQfO-0003yh-8W
	for linux-wireless@vger.kernel.org; Mon, 27 Jul 2009 13:55:02 +0000
Received: from port-212-202-120-50.static.qsc.de ([212.202.120.50])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 13:55:02 +0000
Received: from w.sang by port-212-202-120-50.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 13:55:02 +0000
To: linux-wireless@vger.kernel.org
From: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: Problem with exclusive interrupt in hostap_cs
Date: Mon, 27 Jul 2009 15:50:07 +0200
Message-ID: <4A6DB08F.2060108@pengutronix.de>
References: <20090420101340.142b6bc6@dp-indexing.com>	<49ECCABE.40805@lwfinger.net> <20090420225740.25307.qmail@cdy.org> <20090421103617.05737b01@dp-indexing.com> <49EDF923.2020102@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <49EDF923.2020102@lwfinger.net>
Cc: linux-pcmcia@lists.infradead.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Larry Finger wrote:

> I took a second look at the code and found that other drivers are using the
> routine prism2_interrupt() with shared interrupts, thus the patch below should
> be all that is needed.
> 
> I trust that you will be able to build the patched driver.
> 
> Larry
> 
> 
> Index: wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/hostap/hostap_cs.c
> +++ wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
> @@ -666,7 +666,8 @@ static int prism2_config(struct pcmcia_d
>  	 * irq structure is initialized.
>  	 */
>  	if (link->conf.Attributes & CONF_ENABLE_IRQ) {
> -		link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
> +		link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
> +				       IRQ_HANDLE_PRESENT;
>  		link->irq.IRQInfo1 = IRQ_LEVEL_ID;
>  		link->irq.Handler = prism2_interrupt;
>  		link->irq.Instance = dev;

Do you think this could be queued up by now? Looks okay to me...

Regards,

    Wolfram

-- 
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

