Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48021 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760920Ab1D2TqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:46:14 -0400
Date: Fri, 29 Apr 2011 15:43:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43: avoid uninitialized variable warnings in phy_n
Message-ID: <20110429194309.GF25999@tuxdriver.com> (sfid-20110429_214635_285972_65E0C2A8)
References: <1304103559-28415-1-git-send-email-linville@tuxdriver.com>
 <4DBB0FC7.8040809@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4DBB0FC7.8040809@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 29, 2011 at 02:21:43PM -0500, Larry Finger wrote:
> On 04/29/2011 01:59 PM, John W. Linville wrote:
> >   CC [M]  drivers/net/wireless/b43/phy_n.o
> >drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_set_channel’:
> >drivers/net/wireless/b43/phy_n.c:3848:47: warning: ‘tabent_r2’ may be used uninitialized in this function
> >drivers/net/wireless/b43/phy_n.c:3849:47: warning: ‘tabent_r3’ may be used uninitialized in this function
> >drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_poll_rssi.clone.14’:
> >drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$7’ may be used uninitialized in this function
> >drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$8’ may be used uninitialized in this function
> >
> >FWIW, the usage of these variables is goverened by checks that match
> >their initializations.  So, I think these are actually false warnings.
> >Still, I would rather avoid the warning SPAM...
> >
> >Signed-off-by: John W. Linville<linville@tuxdriver.com>
> >---
> >  drivers/net/wireless/b43/phy_n.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> >
> 
> If you s/goverened/governed/ in the commit message, then ACK.
> 
> For my info, what compiler version and architecture shows these
> warnings? I don't see them with gcc v4.5.1 on x86_64.
> 
> Larry

/home/linville
[linville-8530p.local]:> gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared
--enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile
--enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC)

This is on Fedora 14, FWIW...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
