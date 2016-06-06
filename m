Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:32811 "EHLO
	mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbcFFBQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jun 2016 21:16:47 -0400
Received: by mail-qt0-f182.google.com with SMTP id 23so10281620qtq.0
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jun 2016 18:16:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464933580.11694.44.camel@coelho.fi>
References: <20160529214059.GA15677@localhost> <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
 <20160601125453.GB12977@localhost> <1464787139.2554.74.camel@intel.com>
 <CAAA5faFaPow=Rw-1btgag9wRV-ub8=np2FgpRsoF99MPyb7row@mail.gmail.com>
 <1464841636.11694.10.camel@intel.com> <CAAA5faGpjybA63PMp5pzGOxbw8Zjy+vK1HwnQA4-jGGk8XWJvA@mail.gmail.com>
 <1464855365.11694.35.camel@coelho.fi> <CAAA5faEJuydHyOgoB=R3HrucRLr4mhbwJPp=29SzmaJOzw9Gdw@mail.gmail.com>
 <1464933580.11694.44.camel@coelho.fi>
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Date: Sun, 5 Jun 2016 19:09:06 -0600
Message-ID: <CAAA5faGOfkWczCBXF5ZuD-Q7RpoYPGP9L-71mJ0XZfFGF+fEXQ@mail.gmail.com> (sfid-20160606_031655_204333_04CA1E57)
Subject: Re: wireless-testing on 4.7
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 2, 2016 at 11:59 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Thu, 2016-06-02 at 23:09 -0600, Reinoud Koornstra wrote:
>> On Thu, Jun 2, 2016 at 2:16 AM, Luca Coelho <luca@coelho.fi> wrote:
>> > This shows that you have iwlwifi-7260-16.ucode in your file system.
>> >  But here we are reading it much later.  So it's possible that the
>> > kernel cannot access the firmware at a very early stage (because
>> > the
>> > filesystem that contains it is not mounted yet) when you use in-
>> > kernel.
>> >
>> > So, first of all, please make sure they're built as modules.  We
>> > can
>> > continue from there then.
>>
>> Your suggestion worked. When it's compiled as module, the
>> iwlwifi-7260-16.ucode loads fine.
>> No problems detected so far.
>
> Great! :)

It is. :)
I git pulled again and build it again.
This time with gcc 6.1.0
I couldn't find warning specific to iwlwifi with gcc 6, so that's great.
Didn't find anything worrysome yet, in addition I am running the cake
qdisc as well from Dave Taht.
objdump --full-contents --section=.comment vmlinux

vmlinux:     file format elf64-x86-64

Contents of section .comment:
0000 4743433a 2028474e 55292036 2e312e30  GCC: (GNU) 6.1.0
0010 00

reinoud@router-dev:~/Downloads/wireless-testing$ objdump
--full-contents --section=.comment
/lib/modules/4.7.0-rc1-wt+/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko

/lib/modules/4.7.0-rc1-wt+/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko:
    file format elf64-x86-64

Contents of section .comment:
0000 00474343 3a202847 4e552920 362e312e  .GCC: (GNU) 6.1.
0010 30000047 43433a20 28474e55 2920362e  0..GCC: (GNU) 6.
[SNIP]
0180 28474e55 2920362e 312e3000           (GNU) 6.1.0.


>
>
>> It does make me think whether this is desired behavior though that
>> due
>> to the later reading we cannot have iwlwifi build in the kernel.
>
> It should work, but then you have to make sure the firmware is
> available at very early stages of boot.  If you add it to the proper
> place in your initrd, the kernel should find it when the driver
> requests it.
>
> I didn't want to go into the details of this, because in most cases the
> best option is to have the driver as a module.  If you really need it
> in-kernel, then you need to make sure all the needed pieces are
> available very early as well.

Ah, thanks, I'll study this as how to have it inside initrd at the right place.
Any pointers would be great.

Btw, I did build gcc 6.1.0 like this, if you have hints or ways I
should build it differently I would like to know.

reinoud@router-dev:~/Downloads/wireless-testing$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/home/reinoud/GCC/libexec/gcc/x86_64-linux-gnu/6.1.0/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../gcc-6.1.0/configure -v
--enable-languages=c,c++,go,fortran,objc,obj-c++
--prefix=/home/reinoud/GCC --enable-shared --enable-linker-build-id
--without-included-gettext --enable-threads=posix --enable-nls
--with-sysroot=/ --enab
le-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes
--with-default-libstdcxx-abi=new --enable-gnu-unique-object
--disable-vtable-verify --enable-libmpx --enable-plugin
--with-system-zlib --disable-browser-plugin --with-arch-direct
ory=amd64 --enable-objc-gc --enable-multiarch --disable-werror
--with-abi=m64 --enable-checking=release --build=x86_64-linux-gnu
--host=x86_64-linux-gnu --target=x86_64-linux-gnu
Thread model: posix
gcc version 6.1.0 (GCC)

The --with-tune=skylake didn't work as it didn't know it. unfortunately.

>
> --
> Cheers,
> Luca.

Thanks,

Reinoud.
