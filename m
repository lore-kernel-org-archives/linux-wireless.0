Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41996 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbZLUM30 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:29:26 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
Date: Mon, 21 Dec 2009 13:28:51 +0100
Cc: wireless <linux-wireless@vger.kernel.org>
References: <4B2ECC72.40703@redfish-solutions.com>
In-Reply-To: <4B2ECC72.40703@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912211328.53552.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 December 2009 02:16:34 Philip A. Prindeville wrote:
> I'm building images for an EMBEDDED platform, and forcing CONFIG_SSB_POSSIBLE=n, but I'm still seeing:
> 
> *
> * Sonics Silicon Backplane
> *
> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n
> 
> Support for the Sonics Silicon Backplane bus.
> You only need to enable this option, if you are
> configuring a kernel for an embedded system with
> this bus.
> It will be auto-selected if needed in other
> environments.
> 
> The module will be called ssb.
> 
> If unsure, say N.
> 
> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) n
> 
> Support for the Sonics Silicon Backplane bus.
> You only need to enable this option, if you are
> configuring a kernel for an embedded system with
> this bus.
> It will be auto-selected if needed in other
> environments.
> 
> The module will be called ssb.
> 
> If unsure, say N.
> 
> Sonics Silicon Backplane support (SSB) [M/y/?] (NEW) 
> 
> 
> 
> And why does arch/x86/configs/i386_defconfig nail up CONFIG_SSB_POSSIBLE?
> 
> This is with 2.6.27.38.
> 
> And what are the steps to figuring out the dependency that keeps forcing it on?  Something must be doing a "select SSB" but I'm not sure what.

CONFIG_SSB_POSSIBLE is just a management config entry that does not affect compilation.
It's just used to get the dependencies right. As long as CONFIG_SSB is n, no SSB code will
be built. CONFIG_SSB_POSSIBLE does just indicate whether it's possible to enable SSB. No more
and no less. It's just used as a dependency for the other modules that do a "select SSB".

The drivers that automatically select CONFIG_SSB are:

- bcm47xx MIPS platform
- bcm63xx MIPS platform
- b43 driver
- b43legacy driver
- b44 driver

-- 
Greetings, Michael.
