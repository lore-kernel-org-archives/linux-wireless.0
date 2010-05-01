Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:44730 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751086Ab0EAIjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 04:39:04 -0400
Message-ID: <4BDBE89C.20406@dlasys.net>
Date: Sat, 01 May 2010 04:38:52 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw
References: <4BDB72AA.7000203@dlasys.net> <201005010323.53295.s.L-H@gmx.de>
In-Reply-To: <201005010323.53295.s.L-H@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2010 09:23 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> I assume your host's /bin/sh is not bash.
>    
ubuntu default

ls -al /bin/sh
lrwxrwxrwx 1 root root 4 2010-04-02 01:25 sh -> dash

I have bumped into similar problems with buildroot.

Is there a serious downside to linking /bin/sh to bash ?

> ---------------------------------------------------------------------------
>
> ar9170.fw: fix bashisms while building the cross toolchain.
>
> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
>
> --- a/toolchain/Makefile
> +++ b/toolchain/Makefile
> @@ -31,7 +31,8 @@ src/newlib-$(NEWLIB_VER): src/$(NEWLIB_T
>
>   src/gcc-$(GCC_VER): src/$(GCC_TAR) src/newlib-$(NEWLIB_VER)
>   	tar -C src -xjf $<
> -	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/{newlib,libgloss} $@
> +	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/newlib $@
> +	ln -s $(BASEDIR)/src/newlib-$(NEWLIB_VER)/libgloss $@
>
>   binutils: src/binutils-$(BINUTILS_VER)
>   	mkdir -p build/binutils
>
> ---------------------------------------------------------------------------
>
> While you're at it, I'd suggest to bump the versions for the required
> cross-build environment as well, as it noticably improves stability of the
> firmware images built by it (still not perfectly, but better).
>
> ---------------------------------------------------------------------------
>
> ar9170.fw: update cross-toolchain.
>
> Updating the toolchain improves stability of the built firmware images
> significantly.
>
> * gcc-4.4.4
> * binutils-2.20.1
> * newlib 1.18.0
>
> Signed-off-by: Stefan Lippers-Hollmann<s.l-h@gmx.de>
>
> --- a/toolchain/Makefile
> +++ b/toolchain/Makefile
> @@ -1,12 +1,12 @@
> -BINUTILS_VER=2.19.1
> +BINUTILS_VER=2.20.1
>   BINUTILS_URL=http://mirrors.kernel.org/gnu/binutils/binutils-$(BINUTILS_VER).tar.bz2
>   BINUTILS_TAR=binutils-$(BINUTILS_VER).tar.bz2
>
> -NEWLIB_VER=1.17.0
> +NEWLIB_VER=1.18.0
>   NEWLIB_URL=ftp://sources.redhat.com/pub/newlib/newlib-$(NEWLIB_VER).tar.gz
>   NEWLIB_TAR=newlib-$(NEWLIB_VER).tar.gz
>
> -GCC_VER=4.3.3
> +GCC_VER=4.4.4
>   GCC_URL=http://mirrors.kernel.org/gnu/gcc/gcc-$(GCC_VER)/gcc-core-$(GCC_VER).tar.bz2
>   GCC_TAR=gcc-core-$(GCC_VER).tar.bz2
>
> ---------------------------------------------------------------------------
>
> Regards
> 	Stefan Lippers-Hollmann
>    


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

