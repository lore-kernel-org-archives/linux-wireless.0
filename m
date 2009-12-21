Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:37600 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbZLUEWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 23:22:21 -0500
Message-ID: <4B2EF7FB.1080901@redfish-solutions.com>
Date: Sun, 20 Dec 2009 20:22:19 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
References: <4B2ECC72.40703@redfish-solutions.com> <20091220175033.36980f35.rdunlap@xenotime.net>
In-Reply-To: <20091220175033.36980f35.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2009 05:50 PM, Randy Dunlap wrote:
> On Sun, 20 Dec 2009 17:16:34 -0800 Philip A. Prindeville wrote:
> 
>> I'm building images for an EMBEDDED platform, and forcing CONFIG_SSB_POSSIBLE=n, but I'm still seeing:
> 
> What $ARCH ?

i586.


> 
>> *
>> * Sonics Silicon Backplane
>> *
>> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n
>>
>> Support for the Sonics Silicon Backplane bus.
>> You only need to enable this option, if you are
>> configuring a kernel for an embedded system with
>> this bus.
>> It will be auto-selected if needed in other
>> environments.
>>
>> The module will be called ssb.
>>
>> If unsure, say N.
>>
>> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n
>>
>> Support for the Sonics Silicon Backplane bus.
>> You only need to enable this option, if you are
>> configuring a kernel for an embedded system with
>> this bus.
>> It will be auto-selected if needed in other
>> environments.
>>
>> The module will be called ssb.
>>
>> If unsure, say N.
>>
>> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) 
>>
>>
>>
>> And why does arch/x86/configs/i386_defconfig nail up CONFIG_SSB_POSSIBLE?
> 
> That just means that SSB support is possible:
> 
> config SSB_POSSIBLE
> 	bool
> 	depends on HAS_IOMEM && HAS_DMA
> 	default y
> 
> Shouldn't be a problem.
> 
>> This is with 2.6.27.38.
>>
>> And what are the steps to figuring out the dependency that keeps forcing it on?  Something must be doing a "select SSB" but I'm not sure what.
> 
> Are you using b43 or b44 network drivers?

Neither.

I can attach the .config we're using, if you want...

-Philip



> ---
> ~Randy

