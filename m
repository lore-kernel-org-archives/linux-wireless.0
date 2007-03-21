Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.zelnet.ru ([80.92.97.13]:46245 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbXCUKwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 06:52:45 -0400
Message-ID: <4601005F.7020301@namesys.com>
Date: Wed, 21 Mar 2007 12:52:31 +0300
From: Edward Shishkin <edward@namesys.com>
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	bluez-devel@lists.sourceforge.net, reiserfs-dev@namesys.com
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>	<1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
In-Reply-To: <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Morton wrote:

>On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
>
>  
>
>>On Mon, 2007-03-19 at 20:56 -0800, Andrew Morton wrote:
>>    
>>
>>>Temporarily at
>>>
>>>  http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
>>>
>>>Will appear later at
>>>
>>>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
>>>      
>>>
>>First impressions:
>>Several of the same bugs as rc3-mm*:
>>      * Freezes immediately if I touch the wlan0 device after loading
>>        the new Broadcom wireless driver.
>>    
>>
>
>cc linux-wireless
>
>  
>
>>      * Freezes immediately if I allow Bluetooth to configure.
>>    
>>
>
>cc bluez-devel
>
>  
>
>>      * All freezes simply stop, no BUG or panic happens, no watchdog,
>>        soft or NMI ever triggers.  Thinking about it, I wonder if
>>        disabling EDAC_K8 would help here?  Does it steal NMI?  I'll try
>>        that later.
>>    
>>
>
>Mabe that will be fixed by the just-uploaded
>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/hot-fixes/tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
>
>  
>
>>      * I am using Reiser4 and after one of the above freezes and hard
>>        power cycle, files that were in use *read*only* are filled with
>>        zeros.
>>

did you enable compression announced not so long ago?
anyway, it would be better to check your fs by fsck.reiser4

>>  For example, while testing and experiencing the above
>>        freezes, I lost /etc/ld.so.preload
>>        and /lib/security/pam_limits.so.  What the heck?
>>    
>>
>
>cc reiserfs-dev
>  
>

