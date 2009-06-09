Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZFIWsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 18:48:03 -0400
Subject: Re: Cross compiling libnl, iw, crda and friends
From: Samuel Ortiz <samuel@sortiz.org>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1244577286.12185.7.camel@jdl-desktop>
References: <1244577286.12185.7.camel@jdl-desktop>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 00:50:13 +0200
Message-Id: <1244587813.2628.10.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jon,

On Tue, 2009-06-09 at 14:54 -0500, Jon Loeliger wrote:
> Guys,
> 
> Am I missing an obvious solution to cross compiling libnl, iw,
> the crda and related friends?
> 
> I have a cross-compiled kernel and headers and such, and I'd
> like to add the various wireless tools into the mix, but I
> think the existing Makefiles are basically unaware of cross
> compiling.
> 
> I think there are a couple points of confusion.  While we need
> to compile on the host machine, we need to point to the target
> include files which may not be installed in standard locations.
Unless you're looking for a quick and easy fix to build some
one-shot demo image for your target, you may want to start looking
at cross platform build systems, like openembedded, poky or maybe
openwrt.

Cheers,
Samuel.

> The resulting libraries, though, need to be installed in standard
> locations on the target.  This combination doesn't seem to be
> recordable in the pkg-config files (libnl-2.0.pc, for example).
> 
> Then things like crda and iw need to use the headers from the
> cross-build installation and the cross-kernel, not the host's.
> 
> Also, crda seems to have hard paths for the regulatory.bin.
> I want to point to my source package for the build, but then
> install it into a standard location on the target.  Feh.
> 
> I feel like I'm missing something here...?
> 
> Thanks,
> jdl
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

