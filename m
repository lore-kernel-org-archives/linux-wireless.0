Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52064 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYKXDWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 22:22:34 -0500
Cc: Mike Kershaw <dragorn@kismetwireless.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <307F10CD-3A26-4568-B815-6C61B9FFB7A3@holtmann.org> (sfid-20081124_042239_199992_369144F2)
From: Marcel Holtmann <marcel@holtmann.org>
To: Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <1227494724.2548.223.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: iwlagn MAC in deep sleep
Date: Mon, 24 Nov 2008 04:22:27 +0100
References: <20081121193348.GA7373@drd1813.lan> <1227491716.2548.213.camel@debian.sh.intel.com> <4270E0F0-BE5E-4448-A6B0-2E74113488F6@holtmann.org> <1227494724.2548.223.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

>>> Can you please look for something called vPRO/AMT in your BIOS and
>>> try to disable it?
>>
>> what has that to do with it? You need to explain why this should help
>> at all. Just randomly enabling/disabling features of your core system
>> is not a good debugging method. And even if that makes this go away,
>> it is still a bug that needs fixed.
>
> iwlagn currently doesn't support AMT, which is another user for the  
> same
> hardware. At this time, the only way we can do is to disable it.
>
> BTW, I assume you ask this question on behalf of other people.  
> Otherwise
> you should involve in our internal discussion as active as the  
> external
> ones.

you have to see me like any other user of Intel wireless hardware. The  
hardware is available to the masses and the driver is merged into the  
upstream kernel. So the only authority of discussion here is the linux- 
wireless mailing list. This means that everything I have to discuss  
about wireless goes to this mailing list. Unless it involves Intel  
confidential information there is absolutely no need for internal  
discussions.

Back to the topic. So we do have an issue if AMT is enabled. I have it  
enabled and from time to time this now kills my hardware. Telling  
someone to disable a system feature is not really the solution here.

So first question is if we can detect that AMT is enabled from the  
iwlagn driver? If yes, then we should print a warning here to inform  
the user of a potential issue. This helps users at least to know what  
is going.

Second question is if we can tell AMT to not manage this hardware? If  
yes, then we should certainly do so.

And third question is what does it take to fix the driver to play  
nicely with AMT.

Regards

Marcel

