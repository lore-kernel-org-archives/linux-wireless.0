Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47551 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZLUTA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 14:00:28 -0500
Date: Mon, 21 Dec 2009 13:59:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Can't turn off SSB (CONFIG_SSB)?
Message-ID: <20091221185922.GD4979@tuxdriver.com>
References: <4B2ECC72.40703@redfish-solutions.com> <200912210924.16481.holgerschurig@gmail.com> <4B2FC3A4.9080804@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B2FC3A4.9080804@redfish-solutions.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 21, 2009 at 10:51:16AM -0800, Philip A. Prindeville wrote:
> On 12/21/2009 12:24 AM, Holger Schurig wrote:
> >> And what are the steps to figuring out the dependency that
> >> keeps forcing it on?  Something must be doing a "select SSB"
> >> but I'm not sure what.  
> > 
> > "make xconfig", and then turn on "Options -> Show Debug Info".
> > 
> > Then you see the reverse dep.
> > 
> > 
> > Another thing would be "find -name Kconfig |xargs grep 
> > SSB_POSSIBLE" and then carefully check those files.
> 
> Well, as I mentioned, arch/x86/configs/i386_defconfig contains:
> 
> CONFIG_SSB_POSSIBLE=y
> 
> which I've not been able to understand why.  There are lots of x86 configurations where this might *not* be possible, in embedded platforms in particular.

config SSB_POSSIBLE
        bool
        depends on HAS_IOMEM && HAS_DMA
        default y

What x86 configurations don't have IOMEM or DMA?  And what difference
does it make if SSB_POSSIBLE is defined if it doesn't build any code?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
