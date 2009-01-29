Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:43606 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbZA2Vaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 16:30:39 -0500
Received: by rv-out-0506.google.com with SMTP id k40so115713rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 13:30:38 -0800 (PST)
Message-ID: <49821FF1.4060200@gmail.com> (sfid-20090129_223043_831418_68CCC8E1)
Date: Thu, 29 Jan 2009 13:30:25 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
References: <20081216025542.GO18056@xi.wantstofly.org> <1231435410.21643.59.camel@localhost.localdomain>
In-Reply-To: <1231435410.21643.59.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/08/2009 09:23 AM, Dan Williams wrote:
> On Tue, 2008-12-16 at 03:55 +0100, Lennert Buytenhek wrote:
>    
>> Hi all,
>>
>> Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
>> PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
>> and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to
>> extend the support to other parts in the 8xxx series, since the firmware
>> interface is very similar between parts.
>>
>> There's an occasional timeout warning with mwl8k_stop(), and hardware
>> crypto is still a work-in-progress, but other than that it looks pretty
>> stable.
>>
>> Feedback appreciated!
>>      
>
> Would you guys mind if we split this up into an mwl8k core, and separate
> mwl8335 and mwl8687 modules?  In starting to add at least firmware
> upload for the 8335 last night, I realized that  most of the 8687
> hardware access code won't work, because it's using DMA for passing the
> firmware image to the card, while the 8335 uses many small writes to the
> registers.  So I'd like to refactor the driver into those 3 distinct
> modules instead.  Eventually there will probably be 8361 and 8362
> modules as well once the TopDog N parts get added.
>
> Sound OK?  I'm working locally with git, but if I go too far it'll be a
> ton of work to merge any changes you have.  Can we put this in a git
> tree somewhere and all work from that while we wait for a merge?
>
> Dan
>    
Has any of this landed in a git repo yet?  I have an 8335 chip and would 
love to help with testing, but need a place to find bits, first.

Thanks,
John Daiker
