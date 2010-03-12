Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:52575 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932528Ab0CLUyE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 15:54:04 -0500
Message-ID: <4B9AA9E8.6010307@gmail.com>
Date: Fri, 12 Mar 2010 21:54:00 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Janne Tanskanen <jannejt@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rt2500pci master mode and hostapd
References: <4ADF4285.7010405@gmail.com> <20100312162040.GA17689@tuxdriver.com>
In-Reply-To: <20100312162040.GA17689@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/10 17:20, John W. Linville wrote:
> On Wed, Oct 21, 2009 at 08:19:01PM +0300, Janne Tanskanen wrote:
>> Hi! I build a wireless access point using a-link wl54pc (pcmcia card,  
>> rt2500pci module) and hostapd 0.6.9 with kernel version 2.6.32-rc5.  
>> Problem is that even tho hostapd starts and iwconfig shows wlan0 in  
>> master mode, other computers cant find the wireless network.
>>
>> I found a working patch from here:  
>> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?p=32632#p32632 and  
>> all works now with it applied to vanilla kernel. Just wanted to post  
>> this to the mailing list and ask why it's not added to mainline rt2x00  
>> kernel tree yet? Patch on forum is from May, almost half year ago.  
>> Hopefully it'll be included to mainline kernel asap.
> 
> This is an old one -- sorry if no one got back to you sooner!
> It looks to me like the equivalent of the patch you cited is available
> in 2.6.34-rc1 (if not before) -- look for DRIVER_REQUIRE_DMA and
> rt2x00queue_align_frame.  There were some changes between 2.6.32-rc5
> and now, but I'm not sure if they affect things for your or not.
> 
> Could you try 2.6.34-rc1 and see if things are working for you?
> 

This indeed ought to be fixed already in mainline. Investigations show that
a fix similar to the mentioned patch (in a different place in the rt2x00
code) was included in 2.6.32.
See commit 93354cbbcbfca920495377158c0f61c36be79e13 of Linus' tree.

---
Gertjan.
