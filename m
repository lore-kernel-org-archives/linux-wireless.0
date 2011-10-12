Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49162 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab1JLPaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 11:30:35 -0400
Message-ID: <4E95B299.8050006@emobix.co.uk> (sfid-20111012_173039_205435_7B713FB0)
Date: Wed, 12 Oct 2011 16:30:33 +0100
From: Ian Jeffray <ian@emobix.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver - on ARM
References: <4E81ED65.7060703@emobix.co.uk> <4E8757A8.1010302@emobix.co.uk> <4E87609E.5030002@lwfinger.net> <201110012054.42461.chunkeey@googlemail.com> <4E8768EC.9040900@lwfinger.net> <4E87A110.6030201@emobix.co.uk>
In-Reply-To: <4E87A110.6030201@emobix.co.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/10/2011 00:24, Ian Jeffray wrote:
> On 01/10/2011 20:24, Larry Finger wrote:
>
>> BTW, netperf shows that r8712u can transmit at ~80 and receive at ~60
>> Mbps when connected to a 270 Mbps AP. As Realtek lists this as capable
>> of 150 Mbps, x86_64 is getting the max transmit rate that we might
>> expect.
>
> On x86 32bit, I get a sustained 94Mbps transmit to a 300Mbps AP, which
> seems pretty good - why I'm keen to get this to work for my ARM target.

Larry, just a little more info on this issue, FYI.

It would seem the problem is certainly specific to the 'Inventra' mUSB
host found in recent TI ARM products and ADI Blackfin devices.

I have added a PCI express NEC USB 2.0 host controller card to my ARM
Cortex A8 system, and the r8712u devices work just fine when connected
via that host controller.  (Albeit only at 20MBps rate, but that's
because the host controller is rather poor in general).

We have now raised this problem with TI USB experts.

Regards,

Ian.
