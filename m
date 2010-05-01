Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:35779 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832Ab0EAKLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 06:11:35 -0400
Message-ID: <4BDBFE51.2010305@dlasys.net>
Date: Sat, 01 May 2010 06:11:29 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw
References: <4BDB72AA.7000203@dlasys.net> <201005010323.53295.s.L-H@gmx.de>
In-Reply-To: <201005010323.53295.s.L-H@gmx.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Did a git pull and picked up the bashisms and versions update.
At HEAD I get build failures in bfd

----------------------------------
make[5]: Entering directory 
`/usr/src/ar9170-fw/toolchain/build/binutils/bfd'
1011 /bin/sh ./libtool --tag=CC --mode=compile gcc -DHAVE_CONFIG_H -I. 
-I/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd
1012 libtool: compile: gcc -DHAVE_CONFIG_H -I. 
-I/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd -I. 
-I/usr/src/ar9170-fw/
1013 cc1: warnings being treated as errors
1014 In file included from 
/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd/elf32-sh.c:6055:
1015 ./elf32-target.h:718: error: initialization makes pointer from 
integer without a cast
1016 ./elf32-target.h:731: error: large integer implicitly truncated to 
unsigned type
1017 ./elf32-target.h:738: error: missing initializer
1018 ./elf32-target.h:738: error: (near initialization for 
‘elf32_bed.want_p_paddr_set_to_zero’)
1019 ./elf32-target.h:826: error: ‘bfd_elf32_bfd_define_common_symbol’ 
undeclared here (not in a function)
1020 In file included from 
/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd/elf32-sh.c:6074:
------------------------------------

If I back off to
dc858db5b191d70362d30f90906d68c1c3c2c972
the bashism fixes I get the same build errors in libssp in my first email.

In an unrelated toolchain build project (buildroot for a ppc405) I get 
libssp errors if I enable SSP.

I am reading the errors is a failure to properly include standard headers.

I am working under ubuntu lucid
gcc --ver as follows:

Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 
4.4.3-4ubuntu5' --with-bugurl=file:///usr/share/doc/gcc-4.4/README.Bugs 
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr 
--enable-shared --enable-multiarch --enable-linker-build-id 
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext 
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.4 
--program-suffix=-4.4 --enable-nls --enable-clocale=gnu 
--enable-libstdcxx-debug --enable-plugin --enable-objc-gc 
--enable-targets=all --disable-werror --with-arch-32=i486 
--with-tune=generic --enable-checking=release --build=i486-linux-gnu 
--host=i486-linux-gnu --target=i486-linux-gnu
Thread model: posix
gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5)

Alternately maybe I am missing some development dependency that 
configure is not warning about





On 04/30/2010 09:23 PM, Stefan Lippers-Hollmann wrote:
> Hi
>
> On Saturday 01 May 2010, David H. Lynch Jr. wrote:
>    
>>       I tried to build the toolchain from an uptodate pull of the git
>> repository,
>>
>>       I am getting a sequence of errors when the build reach libssp.
>>
>>       My guess would be that libssp is not needed for the ar9170 firmware.
>>
>>       Is this correct and I would appreciate an easy suguestion to
>> disable it if so.
>>
>> make[3]: Entering directory `/usr/src/ar9170-fw/toolchain/build/gcc/sh-elf/libssp'
>>      
> [...]
>    
>> -I/usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp -I. -Wall -O2 -g -g -O2 -MT
>> ssp.lo -MD -MP -MF .deps/ssp.Tpo -c
>> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c -o ssp.o
>> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c: In function
>> '__guard_setup':
>> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: warning: implicit
>> declaration of function 'open'
>> /usr/src/ar9170-fw/toolchain/src/gcc-4.3.3/libssp/ssp.c:70: error: 'O_RDONLY'
>> undeclared (first use in this function)
>>      
> [...]
>
> I assume your host's /bin/sh is not bash.
>
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

