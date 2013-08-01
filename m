Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([216.94.44.85]:24870 "EHLO mail.lenbrook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3HAT0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 15:26:52 -0400
Message-ID: <51FAB45A.9080306@lenbrook.com> (sfid-20130801_212700_965749_D28102E4)
Date: Thu, 01 Aug 2013 15:17:46 -0400
From: Jonathan Bagg <jbagg@lenbrook.com>
MIME-Version: 1.0
To: backports@vger.kernel.org
CC: Solomon Peachy <pizza@shaftnet.org>, linux-wireless@vger.kernel.org
Subject: Re: cross compile backports with LTIB
References: <1375338204-2021-8-git-send-email-sujith@msujith.org> <1375370826-1387-1-git-send-email-sujith@msujith.org> <51FA8ECD.7070401@lenbrook.com> <20130801174749.GC10904@shaftnet.org> <51FAB31F.6050207@lenbrook.com>
In-Reply-To: <51FAB31F.6050207@lenbrook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-08-01 03:12 PM, Jonathan Bagg wrote:
> On 13-08-01 01:47 PM, Solomon Peachy wrote:
>> On Thu, Aug 01, 2013 at 12:37:33PM -0400, Jonathan Bagg wrote:
>>> I've been cross compiling compat-wireless and now I'm trying
>>> backports.  It looks like conf.c and zconf.tab.c are being compiled
>>> as arm and then the build process is trying to run conf on my x86
>>> host.  Results using the below make parameters I was using for
>>> compat-wireless......
> Learned some things....Problem was LTIB (ltib = Freescale tool) 
> environment.  Outside of LTIB, backports cross compiles fine.  To get 
> backports happy in LTIB need to use UNSPOOF/SPOOF_PATH to switch 
> between host and cross environment....
>
(this is for the LTIBs spec file for backports = 
dist/lfs-5.1/backports/backports.spec - forgot to mention in previous post)
> %Build
> export PATH=$UNSPOOF_PATH
>
> make defconfig-cw1200 make prefix=%{_prefix} 
> CROSS_COMPILE=${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX} ARCH=$LINTARCH 
> KLIB=${TOP}/rootfs/lib/modules/%{kversion} 
> KLIB_BUILD=${TOP}/rpm/BUILD/linux
>
> export PATH=$SPOOF_PATH
>
> make prefix=%{_prefix} 
> CROSS_COMPILE=${TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX} ARCH=$LINTARCH 
> KLIB=${TOP}/rootfs/lib/modules/%{kversion} 
> KLIB_BUILD=${TOP}/rpm/BUILD/linux
>
> Jon 
