Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44650 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZFIVEW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 17:04:22 -0400
Message-ID: <4A2ECE50.7020704@openwrt.org>
Date: Tue, 09 Jun 2009 23:04:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jon Loeliger <jdl@bigfootnetworks.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Cross compiling libnl, iw, crda and friends
References: <1244577286.12185.7.camel@jdl-desktop>
In-Reply-To: <1244577286.12185.7.camel@jdl-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon Loeliger wrote:
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
In OpenWrt, we have generic workarounds for stuff like libtool and
pkg-config. You may need to override PKG_CONFIG_PATH and
PKG_CONFIG_LIBDIR to point to your staging directory (if you use such a
thing). The configure script can be used with generic options like for
other packages.
Another thing that might interest you is that I created a tiny version
of libnl (based on a git snapshot), which only contains genl, not
rtnetlink or any of the netfilter stuff, and compiles down to less than
30k in binary size.
You can find it here:
https://dev.openwrt.org/browser/trunk/package/libnl-tiny
Our crda build system file is here:
https://dev.openwrt.org/browser/trunk/package/crda/Makefile
(it's an OpenWrt build system makefile, but you might get the point by
reading it).

Hope this helps,

- Felix
