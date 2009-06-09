Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infomaniak.ch ([84.16.68.90]:50100 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbZFIVrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 17:47:22 -0400
Received: from Krom.local (175-48.107-92.cust.bluewin.ch [92.107.48.175])
	(authenticated bits=0)
	by smtp2.infomaniak.ch (8.14.2/8.14.2) with ESMTP id n59LlL0W003596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 9 Jun 2009 23:47:22 +0200
Message-ID: <4A2ED869.2080200@shockfish.com>
Date: Tue, 09 Jun 2009 23:47:21 +0200
From: Alexandre Becholey - s h o c k f i s h / <alexandre@shockfish.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: Cross compiling libnl, iw, crda and friends
References: <1244577286.12185.7.camel@jdl-desktop>
In-Reply-To: <1244577286.12185.7.camel@jdl-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
 >
 > Thanks,
 > jdl
 >
 >
 > --
 > To unsubscribe from this list: send the line "unsubscribe 
linux-wireless" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html

[forgot to CC the mailing list...]

Hi,

I did cross-compile libnl for ARMv5 CPU a few months ago. What you need 
is a tool-chain (a gcc that runs or your computer but compile code for 
target machine and the glibc).
In your Makefile or configure (I don't remember, but if you are patient 
I can have a look soon), you'll have to add the tool-chain's include 
file (can also tell you the path soon) to the CFLAGS variable (CFLAGS += 
-I/path/to/the/tool-chain's/include).

http://www.kegel.com/crosstool/ may help you for your tool-chain

Best regards,

Alexandre

PS: If your target machine is an ARM, I have 3 tool-chains: gcc 3.4.3, 
gcc 4.1.x (fails with the weak attribute if I remember well) and gcc 
4.2.x, if that's interest you...


