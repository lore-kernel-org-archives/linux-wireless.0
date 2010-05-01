Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36802 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750800Ab0EALmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 07:42:35 -0400
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Subject: Re: ar9170-fw
Date: Sat, 1 May 2010 13:42:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <4BDB72AA.7000203@dlasys.net> <201005010323.53295.s.L-H@gmx.de> <4BDBFE51.2010305@dlasys.net>
In-Reply-To: <4BDBFE51.2010305@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201005011342.30412.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Saturday 01 May 2010, David H. Lynch Jr. wrote:
>   Did a git pull and picked up the bashisms and versions update.
> At HEAD I get build failures in bfd
> 
> ----------------------------------
> make[5]: Entering directory 
> `/usr/src/ar9170-fw/toolchain/build/binutils/bfd'
> 1011 /bin/sh ./libtool --tag=CC --mode=compile gcc -DHAVE_CONFIG_H -I. 
> -I/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd
> 1012 libtool: compile: gcc -DHAVE_CONFIG_H -I. 
> -I/usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd -I. 
> -I/usr/src/ar9170-fw/
> 1013 cc1: warnings being treated as errors
> 1014 In file included from 
> /usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd/elf32-sh.c:6055:
> 1015 ./elf32-target.h:718: error: initialization makes pointer from 
> integer without a cast
> 1016 ./elf32-target.h:731: error: large integer implicitly truncated to 
> unsigned type
> 1017 ./elf32-target.h:738: error: missing initializer
> 1018 ./elf32-target.h:738: error: (near initialization for 
> ‘elf32_bed.want_p_paddr_set_to_zero’)
> 1019 ./elf32-target.h:826: error: ‘bfd_elf32_bfd_define_common_symbol’ 
> undeclared here (not in a function)
> 1020 In file included from 
> /usr/src/ar9170-fw/toolchain/src/binutils-2.20.1/bfd/elf32-sh.c:6074:
> ------------------------------------
> 
> If I back off to
> dc858db5b191d70362d30f90906d68c1c3c2c972
> the bashism fixes I get the same build errors in libssp in my first email.
> 
> In an unrelated toolchain build project (buildroot for a ppc405) I get 
> libssp errors if I enable SSP.
> 
> I am reading the errors is a failure to properly include standard headers.
> 
> I am working under ubuntu lucid
[...]
> Alternately maybe I am missing some development dependency that 
> configure is not warning about

I have verified before sending the mail yesterday that ar9170.fw still 
builds fine on current Debian unstable (gcc-4.4, but it also worked on 
4.4.2, 4.4.3 before; confirmed in a minimal build chroot (pbuilder) 
environment), so you're likely just missing build dependencies.

# apt-get install build-essential
# apt-get build-dep gcc-4.4 binutils newlib

While this pulls a little more than you'd absolutely need, it still makes
sure that all eventual build dependencies are covered.

Regards
	Stefan Lippers-Hollmann
