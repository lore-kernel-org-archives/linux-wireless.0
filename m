Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:43892 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZFSIeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 04:34:23 -0400
Message-ID: <4A3B4D8C.6010002@tuffmail.co.uk>
Date: Fri, 19 Jun 2009 09:34:20 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Bob Copeland <me@bobcopeland.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pm@lists.linux-foundation.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@venema.h4ckr.net, linux-pci@vger.kernel.org
Subject: Re: [ath5k-devel] [linux-pm] PCI hotplug v.s. suspend
References: <Pine.LNX.4.44L0.0906181437090.3129-100000@netrider.rowland.org> <4A3AAF0A.9020707@tuffmail.co.uk>
In-Reply-To: <4A3AAF0A.9020707@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Jenkins wrote:
> Alan Stern wrote:
>   
>> On Thu, 18 Jun 2009, Alan Jenkins wrote:
>>
>>   
>>     
>>> Unfortunately this makes it worse.  My eeepc-laptop hacks are now in
>>> wireless-testing.  If I apply the above patch to wireless-testing and
>>> "remove" the device while suspended, I get a soft hang on resume. 
>>>     
>>>       
>> Is this different from the behavior without the patch?  (I don't see 
>> how it could be.)
>>   
>>     
>
> Ow.  No, the free_irq patch doesn't cause this bug.  I missed testing
> this case after adding a workaround for an even more obscure issue :-(.
>   

I tried an earlier version without the problem workaround.  Bob's
suggested patch to remove the free_irq() on suspend works fine.  It
fixes the WARNING when the device is removed during suspend, and it
still works if the device is not removed during suspend.

Alan
