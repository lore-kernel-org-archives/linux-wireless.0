Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63857 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab1D3R14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 13:27:56 -0400
Received: by qyg14 with SMTP id 14so2430430qyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 10:27:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110429194309.GF25999@tuxdriver.com>
References: <1304103559-28415-1-git-send-email-linville@tuxdriver.com>
	<4DBB0FC7.8040809@lwfinger.net>
	<20110429194309.GF25999@tuxdriver.com>
Date: Sat, 30 Apr 2011 19:27:54 +0200
Message-ID: <BANLkTimm8jKnm-K+-FsQsLpSQhzOK-B-Jg@mail.gmail.com> (sfid-20110430_192803_988807_FCE02069)
Subject: Re: [PATCH] b43: avoid uninitialized variable warnings in phy_n
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/29 John W. Linville <linville@tuxdriver.com>:
> On Fri, Apr 29, 2011 at 02:21:43PM -0500, Larry Finger wrote:
>> On 04/29/2011 01:59 PM, John W. Linville wrote:
>> >   CC [M]  drivers/net/wireless/b43/phy_n.o
>> >drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_set_channel’:
>> >drivers/net/wireless/b43/phy_n.c:3848:47: warning: ‘tabent_r2’ may be used uninitialized in this function
>> >drivers/net/wireless/b43/phy_n.c:3849:47: warning: ‘tabent_r3’ may be used uninitialized in this function
>> >drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_poll_rssi.clone.14’:
>> >drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$7’ may be used uninitialized in this function
>> >drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$8’ may be used uninitialized in this function
>> >
>> >FWIW, the usage of these variables is goverened by checks that match
>> >their initializations.  So, I think these are actually false warnings.
>> >Still, I would rather avoid the warning SPAM...
>> >
>> >Signed-off-by: John W. Linville<linville@tuxdriver.com>
>> >---
>> >  drivers/net/wireless/b43/phy_n.c |    7 +++++--
>> >  1 files changed, 5 insertions(+), 2 deletions(-)
>> >
>>
>> If you s/goverened/governed/ in the commit message, then ACK.
>>
>> For my info, what compiler version and architecture shows these
>> warnings? I don't see them with gcc v4.5.1 on x86_64.
>>
>> Larry
>
> /home/linville
> [linville-8530p.local]:> gcc -v
> Using built-in specs.
> COLLECT_GCC=/usr/bin/gcc
> COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.5.1/lto-wrapper
> Target: x86_64-redhat-linux
> Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap --enable-shared
> --enable-threads=posix --enable-checking=release --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id
> --enable-languages=c,c++,objc,obj-c++,java,fortran,ada,lto --enable-plugin --enable-java-awt=gtk --disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre --enable-libgcj-multifile
> --enable-java-maintainer-mode --with-ecj-jar=/usr/share/java/eclipse-ecj.jar --disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux
> Thread model: posix
> gcc version 4.5.1 20100924 (Red Hat 4.5.1-4) (GCC)
>
> This is on Fedora 14, FWIW...

Hm, weird that older gcc (4.5.0) was smarter about this :|

> gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/i586-suse-linux/4.5/lto-wrapper
Target: i586-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib --libexecdir=/usr/lib
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.5
--enable-ssp --disable-libssp --disable-plugin
--with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux'
--disable-libgcj --disable-libmudflap --with-slibdir=/lib
--with-system-zlib --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--enable-version-specific-runtime-libs --program-suffix=-4.5
--enable-linux-futex --without-system-libunwind --enable-gold
--with-plugin-ld=/usr/bin/gold --with-arch-32=i586 --with-tune=generic
--build=i586-suse-linux
Thread model: posix
gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux)

I didn't see any warning.

-- 
Rafał
