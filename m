Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:26911 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab3HATMh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 15:12:37 -0400
Message-ID: <51FAB31F.6050207@lenbrook.com> (sfid-20130801_211520_702471_860620CB)
Date: Thu, 01 Aug 2013 15:12:31 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: backports@vger.kernel.org
CC: Solomon Peachy <pizza@shaftnet.org>, linux-wireless@vger.kernel.org
Subject: Re: cross compile backports with LTIB
References: <1375338204-2021-8-git-send-email-sujith@msujith.org> <1375370826-1387-1-git-send-email-sujith@msujith.org> <51FA8ECD.7070401@lenbrook.com> <20130801174749.GC10904@shaftnet.org>
In-Reply-To: <20130801174749.GC10904@shaftnet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-08-01 01:47 PM, Solomon Peachy wrote:
> On Thu, Aug 01, 2013 at 12:37:33PM -0400, Jonathan Bagg wrote:
>> I've been cross compiling compat-wireless and now I'm trying
>> backports.  It looks like conf.c and zconf.tab.c are being compiled
>> as arm and then the build process is trying to run conf on my x86
>> host.  Results using the below make parameters I was using for
>> compat-wireless......
Learned some things....Problem was LTIB (ltib = Freescale tool) 
environment.  Outside of LTIB, backports cross compiles fine.  To get 
backports happy in LTIB need to use UNSPOOF/SPOOF_PATH to switch between 
host and cross environment....

%Build
export PATH=$UNSPOOF_PATH

make defconfig-cw1200 make prefix=%{_prefix} 
CROSS_COMPILE=${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX} ARCH=$LINTARCH 
KLIB=${TOP}/rootfs/lib/modules/%{kversion} KLIB_BUILD=${TOP}/rpm/BUILD/linux

export PATH=$SPOOF_PATH

make prefix=%{_prefix} 
CROSS_COMPILE=${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX} ARCH=$LINTARCH 
KLIB=${TOP}/rootfs/lib/modules/%{kversion} KLIB_BUILD=${TOP}/rpm/BUILD/linux

Jon

> Howdy.  :)
>
> (btw, I'm CC'ing the backports mailing list, which is a better place to
>   ask these sorts of questions)
>
> I found that the backports cross-compile process worked much the same
> way as building compat-wireless.  This is what I'm doing currently in my
> build script:  (This is using a backports package generated last night
> using the backports git HEAD code with the cw1200 driver integrated)
>
>   set -a
>   CROSS_COMPILE=${CROSS_COMPILE}
>   ARCH=${TARGET_CPU}
>   KLIB_BUILD=${DEV_PATH}/${LINUX_DIR}
>   KLIB=${TARGET_ROOT_ON_HOST}
>   set +a
>   make oldconfig  # menuconfig worked here too
>   make
>   make install
>
> That said, the 'make install' target isn't currently sane for
> cross-builds due to the bacport_firmware_install script not respecting
> prefixes.  I just commented that script (and a few others like initrd
> updates) out of the Makefiles, and I had a successful build/install.
>
>   - Solomon


-- 
Jonathan Bagg
Software Developer
NAD Electronics | Lenbrook Industries Limited
633 Granite Court, Pickering, Ontario, Canada L1W 3K1 | 905-831-0799 ext 4478 | http://www.nadelectronics.com

