Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:52459 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbZG0W2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 18:28:08 -0400
Message-ID: <4A6E2A12.30009@lwfinger.net>
Date: Mon, 27 Jul 2009 17:28:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Problem with exclusive interrupt in hostap_cs
References: <20090420101340.142b6bc6@dp-indexing.com>	<49ECCABE.40805@lwfinger.net>	<20090420225740.25307.qmail@cdy.org>	<20090421103617.05737b01@dp-indexing.com>	<49EDF923.2020102@lwfinger.net> <4A6DB08F.2060108@pengutronix.de>
In-Reply-To: <4A6DB08F.2060108@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wolfram Sang wrote:
> Hi Larry,
> 
> Larry Finger wrote:
> 
>> I took a second look at the code and found that other drivers are
>> using the
>> routine prism2_interrupt() with shared interrupts, thus the patch
>> below should
>> be all that is needed.
>>
>> I trust that you will be able to build the patched driver.
>>
>> Larry
>>
>>
>> Index: wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/hostap/hostap_cs.c
>> +++ wireless-testing/drivers/net/wireless/hostap/hostap_cs.c
>> @@ -666,7 +666,8 @@ static int prism2_config(struct pcmcia_d
>>       * irq structure is initialized.
>>       */
>>      if (link->conf.Attributes & CONF_ENABLE_IRQ) {
>> -        link->irq.Attributes = IRQ_TYPE_EXCLUSIVE | IRQ_HANDLE_PRESENT;
>> +        link->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING |
>> +                       IRQ_HANDLE_PRESENT;
>>          link->irq.IRQInfo1 = IRQ_LEVEL_ID;
>>          link->irq.Handler = prism2_interrupt;
>>          link->irq.Instance = dev;
> 
> Do you think this could be queued up by now? Looks okay to me...

As Dominik was missing and there was no action on the linux-pcmcia
list, I took advantage of the fact that this is a wireless device and
submitted the patch to John Linville. It is commit
e4a01604b8e5656f3a059f52b3e8f2560740c057 in the wireless-testing tree
and was sent to DaveM on July 24 for linux-next. It will be in 2.6.32.

Larry

