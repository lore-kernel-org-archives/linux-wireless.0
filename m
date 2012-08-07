Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:37681 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2HGG6k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 02:58:40 -0400
From: Avinash Patil <patila@marvell.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
	Bing Zhao <bzhao@marvell.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kiran Divekar <dkiran@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 6 Aug 2012 23:56:07 -0700
Subject: RE: [wireless-testing:master 53/59]
 drivers/net/wireless/mwifiex/uap_event.c:251:11: warning: comparison of
 distinct pointer types lacks a cast
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC1CC7BCF199@SC-VEXCH2.marvell.com> (sfid-20120807_085846_002795_4EA3935F)
References: <20120807005524.GD9903@localhost>
 <477F20668A386D41ADCC57781B1F7043083AE3DA2C@SC-VEXCH1.marvell.com>
 <20120807024707.GA21890@localhost>
In-Reply-To: <20120807024707.GA21890@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fengguang,

Thanks for toolchain URL.

I will fix this warning and send a patch to mailing list.

Regards,
Avinash Patil


-----Original Message-----
From: Fengguang Wu [mailto:fengguang.wu@intel.com] 
Sent: Tuesday, August 07, 2012 8:17 AM
To: Bing Zhao
Cc: Avinash Patil; kernel-janitors@vger.kernel.org; John W. Linville; Kiran Divekar; linux-wireless@vger.kernel.org
Subject: Re: [wireless-testing:master 53/59] drivers/net/wireless/mwifiex/uap_event.c:251:11: warning: comparison of distinct pointer types lacks a cast

On Mon, Aug 06, 2012 at 07:33:37PM -0700, Bing Zhao wrote:
> Hi Fengguang,
> 
> > drivers/net/wireless/mwifiex/uap_event.c: In function 'mwifiex_process_uap_event':
> > drivers/net/wireless/mwifiex/uap_event.c:251:11: warning: comparison of distinct pointer types lacks
> > a cast [enabled by default]
> 
> Thanks for reporting this warning.
> Could you please share your gcc version (or ppc toolchain version) with me?

Bing, the toolchain is downloaded from

https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

Just unpack the powerpc package to /usr/local and run this:

/usr/bin/make ARCH=powerpc CROSS_COMPILE=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux- allmodconfig

The gcc version is:

% /usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc -v
Using built-in specs.
COLLECT_GCC=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/powerpc64-linux-gcc
COLLECT_LTO_WRAPPER=/usr/local/gcc-4.6.3-nolibc/powerpc64-linux/bin/../libexec/gcc/powerpc64-linux/4.6.3/lto-wrapper
Target: powerpc64-linux
Configured with: /home/tony/buildall/src/gcc/configure --target=powerpc64-linux --host=x86_64-linux-gnu --build=x86_64-linux-gnu --enable-targets=all --prefix=/opt/cross/gcc-4.6.3-nolibc/powerpc64-linux/ --enable-languages=c --with-newlib --without-headers --enable-sjlj-exceptions --with-system-libunwind --disable-nls --disable-threads --disable-shared --disable-libmudflap --disable-libssp --disable-libgomp --disable-decimal-float --enable-checking=release --with-mpfr=/home/tony/buildall/src/sys-x86_64 --with-gmp=/home/tony/buildall/src/sys-x86_64 --disable-bootstrap --disable-libquadmath
Thread model: single
gcc version 4.6.3 (GCC) 

Thanks,
Fengguang
