Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:42386 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbZCST45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:56:57 -0400
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Message-Id: <35D36C55-6CB3-443C-A916-D5771B68DD9A@ing.unibs.it> (sfid-20090319_205700_314604_2F9D8F22)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200903192013.44903.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 20:56:52 +0100
References: <200903191927.21868.mb@bu3sch.de> <2CE6D71C-6DB5-41F2-8FFD-C013DC2B9AF6@ing.unibs.it> <200903192013.44903.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mar 19, 2009, at 8:13 PM, Michael Buesch wrote:

> On Thursday 19 March 2009 20:00:45 Francesco Gringoli wrote:
>>
>
> Yeah well. This confirms my thoughts.
> There are other ways to voluntarily trigger the errors. For example
> try covering the antennae with your bare hands. Try to move the
> device to a place with extremely bad signal (Iron beams between them).
> Try to move the transceivers very close (20cm) together, so basic rf  
> rules are violated.
>
> This are all pretty reliable ways to trigger these errors.
Cool! I will give it a try.

>> - these strange PHY errors are not due to tx tries, they happen also
>> with devices were the tx code has been cut away
>
> Well, I did not see that, so I cannot really comment on this.
> I never saw them in monitor mode.
It was the reason that made me lose a lot of time in putting traps  
into the firmware to understand if we were forgetting something in  
configuring devices to run in monitor mode. Well, we are not: the tx  
code is never crossed. But PHY errors are triggered the same.

>> I would say this noise directly affects the irq line, or it triggers
>> the serializer to send out a packet with completely wrong radio/plcp/
>> mac configuration that causes a PHY tx error.
>
> I don't think it triggers the IRQ line. I'd rather think that some  
> sensitivity
> threshold is configured incorrectly, so the PHY will trigger the  
> errors on
> completely valid stuff.

I would agree with you, but there is this bizarre issue with PHY  
errors in monitoring mode that makes me thinking about what we call  
PHY errors. I would say they are not only due to transmission, they  
are general PHY errors, could they be? One last test I could try, is  
to put again the broken minipci to pci adapter in one pci slot and put  
on the next slot the adapter that does not trigger these errors. If  
the interference caused by the broken adapter induces the wifi boards  
on top of it in errors, it should induce the same error on the board  
mounted on the right adapter.

Cheers,
-FG

>
>
> So now this is your turn: Which one? :D
>
> -- 
> Greetings, Michael.

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli




