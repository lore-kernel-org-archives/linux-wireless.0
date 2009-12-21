Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:50609 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbZLUSvU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 13:51:20 -0500
Message-ID: <4B2FC3A4.9080804@redfish-solutions.com>
Date: Mon, 21 Dec 2009 10:51:16 -0800
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Holger Schurig <holgerschurig@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
References: <4B2ECC72.40703@redfish-solutions.com> <200912210924.16481.holgerschurig@gmail.com>
In-Reply-To: <200912210924.16481.holgerschurig@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2009 12:24 AM, Holger Schurig wrote:
>> And what are the steps to figuring out the dependency that
>> keeps forcing it on?  Something must be doing a "select SSB"
>> but I'm not sure what.  
> 
> "make xconfig", and then turn on "Options -> Show Debug Info".
> 
> Then you see the reverse dep.
> 
> 
> Another thing would be "find -name Kconfig |xargs grep 
> SSB_POSSIBLE" and then carefully check those files.

Well, as I mentioned, arch/x86/configs/i386_defconfig contains:

CONFIG_SSB_POSSIBLE=y

which I've not been able to understand why.  There are lots of x86 configurations where this might *not* be possible, in embedded platforms in particular.

-Philip




