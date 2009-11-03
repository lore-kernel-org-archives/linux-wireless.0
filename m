Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39711 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754426AbZKCVAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 16:00:15 -0500
Message-ID: <4AF095C3.5020409@gmx.net>
Date: Tue, 03 Nov 2009 21:42:43 +0100
From: Frank Schaefer <schaefer.frank@gmx.net>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB
 N devices in cdrom mode
References: <Pine.LNX.4.44L0.0911031001470.10778-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911031001470.10778-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern schrieb:
> On Mon, 2 Nov 2009, Dan Williams wrote
>> In userspace, usb_modeswitch is the place to put all this logic.  Then
>> you tie it together with udev rules using some bubble-gum and duct-tape,
>> and maybe it works.  Of course, there's massive duplication of data
>> between usb_modeswitch and the kernel drivers, because the there's
>> simply no communication between the two.
>>     
> The only reason for this "massive" duplication is that nobody has
> bothered to remove from the kernel the parts that usb_modeswitch can
> handle.  Adding yet more switching code into the kernel, thereby
> _increasing_ the amount of duplication, seems like a bad idea.
>   
Or the other way around ;) .

Of course, we all don't want any duplicate code. We need a kernelspace
OR a userspace-solution.
But we should make pragmatic and device-(group-)specific decisions.
The hardware itself and the context in which it is used (=>
switch-policy) are too different.

...
> ... Jobs that can be handled 
> in userspace _should_ be handled there.
>
> Alan Stern
>   

Basically, I have no problem to agree here.
But what's the price we pay for this solution(s) in this case (and most
other devices with windows-driver-disc-mode) ?
You should not ignore the problems coming-up with the discussed
userspace-solutions.
This is not ONLY about technical aspects. We already discussed usability
and maintanance. Think about the whole product, not only the kernel-part.
Then, please, make a list of ALL pros and cons a make a pragmatic decision.

Frank

