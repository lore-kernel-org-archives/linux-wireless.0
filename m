Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:55855 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756208AbZLUTHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 14:07:53 -0500
Message-ID: <4B2FC783.7050709@redfish-solutions.com>
Date: Mon, 21 Dec 2009 11:07:47 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
References: <4B2ECC72.40703@redfish-solutions.com> <200912210924.16481.holgerschurig@gmail.com> <4B2FC3A4.9080804@redfish-solutions.com> <20091221185922.GD4979@tuxdriver.com>
In-Reply-To: <20091221185922.GD4979@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2009 10:59 AM, John W. Linville wrote:
> On Mon, Dec 21, 2009 at 10:51:16AM -0800, Philip A. Prindeville wrote:
>> On 12/21/2009 12:24 AM, Holger Schurig wrote:
>>>> And what are the steps to figuring out the dependency that
>>>> keeps forcing it on?  Something must be doing a "select SSB"
>>>> but I'm not sure what.  
>>>
>>> "make xconfig", and then turn on "Options -> Show Debug Info".
>>>
>>> Then you see the reverse dep.
>>>
>>>
>>> Another thing would be "find -name Kconfig |xargs grep 
>>> SSB_POSSIBLE" and then carefully check those files.
>>
>> Well, as I mentioned, arch/x86/configs/i386_defconfig contains:
>>
>> CONFIG_SSB_POSSIBLE=y
>>
>> which I've not been able to understand why.  There are lots of x86 configurations where this might *not* be possible, in embedded platforms in particular.
> 
> config SSB_POSSIBLE
>         bool
>         depends on HAS_IOMEM && HAS_DMA
>         default y
> 
> What x86 configurations don't have IOMEM or DMA?  And what difference
> does it make if SSB_POSSIBLE is defined if it doesn't build any code?
> 
> John

The issue is that later on when we build compat-wireless, then my .config file from the linux build directory gets sourced by that and we get a bunch of warnings from the b43, b44, etc. drivers that some ssb_* entry points are missing.


