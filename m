Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56086 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbcFFIIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 04:08:39 -0400
Message-ID: <1465200515.1921.22.camel@coelho.fi> (sfid-20160606_100904_834906_EE01D731)
From: Luca Coelho <luca@coelho.fi>
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"me@bobcopeland.com" <me@bobcopeland.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Mon, 06 Jun 2016 11:08:35 +0300
In-Reply-To: <CAAA5faGOfkWczCBXF5ZuD-Q7RpoYPGP9L-71mJ0XZfFGF+fEXQ@mail.gmail.com>
References: <20160529214059.GA15677@localhost>
	 <CAAA5faFNa1sQrj6Yfq+hrXfUOi0Lek4qL8Zzpdv27-4+Z4n6mQ@mail.gmail.com>
 <20160601125453.GB12977@localhost> <1464787139.2554.74.camel@intel.com>
 <CAAA5faFaPow=Rw-1btgag9wRV-ub8=np2FgpRsoF99MPyb7row@mail.gmail.com>
 <1464841636.11694.10.camel@intel.com>
	 <CAAA5faGpjybA63PMp5pzGOxbw8Zjy+vK1HwnQA4-jGGk8XWJvA@mail.gmail.com>
 <1464855365.11694.35.camel@coelho.fi>
	 <CAAA5faEJuydHyOgoB=R3HrucRLr4mhbwJPp=29SzmaJOzw9Gdw@mail.gmail.com>
 <1464933580.11694.44.camel@coelho.fi>
	 <CAAA5faGOfkWczCBXF5ZuD-Q7RpoYPGP9L-71mJ0XZfFGF+fEXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wireless-testing on 4.7
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-06-05 at 19:09 -0600, Reinoud Koornstra wrote:
> On Thu, Jun 2, 2016 at 11:59 PM, Luca Coelho <luca@coelho.fi> wrote:
> > On Thu, 2016-06-02 at 23:09 -0600, Reinoud Koornstra wrote:
> > > On Thu, Jun 2, 2016 at 2:16 AM, Luca Coelho <luca@coelho.fi> wrote:
> > > > This shows that you have iwlwifi-7260-16.ucode in your file system.
> > > >  But here we are reading it much later.  So it's possible that the
> > > > kernel cannot access the firmware at a very early stage (because
> > > > the
> > > > filesystem that contains it is not mounted yet) when you use in-
> > > > kernel.
> > > > 
> > > > So, first of all, please make sure they're built as modules.  We
> > > > can
> > > > continue from there then.
> > > 
> > > Your suggestion worked. When it's compiled as module, the
> > > iwlwifi-7260-16.ucode loads fine.
> > > No problems detected so far.
> > 
> > Great! :)
> 
> It is. :)
> I git pulled again and build it again.
> This time with gcc 6.1.0
> I couldn't find warning specific to iwlwifi with gcc 6, so that's great.
> Didn't find anything worrysome yet, in addition I am running the cake
> qdisc as well from Dave Taht.
> objdump --full-contents --section=.comment vmlinux
> 
> vmlinux:     file format elf64-x86-64
> 
> Contents of section .comment:
> 0000 4743433a 2028474e 55292036 2e312e30  GCC: (GNU) 6.1.0
> 0010 00
> 
> reinoud@router-dev:~/Downloads/wireless-testing$ objdump
> --full-contents --section=.comment
> /lib/modules/4.7.0-rc1-wt+/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko
> 
> /lib/modules/4.7.0-rc1-wt+/kernel/drivers/net/wireless/intel/iwlwifi/iwlwifi.ko:
>     file format elf64-x86-64
> 
> Contents of section .comment:
> 0000 00474343 3a202847 4e552920 362e312e  .GCC: (GNU) 6.1.
> 0010 30000047 43433a20 28474e55 2920362e  0..GCC: (GNU) 6.
> [SNIP]
> 0180 28474e55 2920362e 312e3000           (GNU) 6.1.0.
> 
> 
> > 
> > 
> > > It does make me think whether this is desired behavior though that
> > > due
> > > to the later reading we cannot have iwlwifi build in the kernel.
> > 
> > It should work, but then you have to make sure the firmware is
> > available at very early stages of boot.  If you add it to the proper
> > place in your initrd, the kernel should find it when the driver
> > requests it.
> > 
> > I didn't want to go into the details of this, because in most cases the
> > best option is to have the driver as a module.  If you really need it
> > in-kernel, then you need to make sure all the needed pieces are
> > available very early as well.
> 
> Ah, thanks, I'll study this as how to have it inside initrd at the right place.
> Any pointers would be great.

It should be really straightforward.  It just depends on how your
distro creates and uses initrd images.  You only need to add the
appropriate .ucode file to /lib/firmware in the initrd image, nothing
else.  Google for it, I'm sure there is a lot of info on how to do it
readily available.



> Btw, I did build gcc 6.1.0 like this, if you have hints or ways I
> should build it differently I would like to know.
> 
> reinoud@router-dev:~/Downloads/wireless-testing$ gcc -v
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/home/reinoud/GCC/libexec/gcc/x86_64-linux-gnu/6.1.0/lto-wrapper
> Target: x86_64-linux-gnu
> Configured with: ../gcc-6.1.0/configure -v
> --enable-languages=c,c++,go,fortran,objc,obj-c++
> --prefix=/home/reinoud/GCC --enable-shared --enable-linker-build-id
> --without-included-gettext --enable-threads=posix --enable-nls
> --with-sysroot=/ --enab
> le-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes
> --with-default-libstdcxx-abi=new --enable-gnu-unique-object
> --disable-vtable-verify --enable-libmpx --enable-plugin
> --with-system-zlib --disable-browser-plugin --with-arch-direct
> ory=amd64 --enable-objc-gc --enable-multiarch --disable-werror
> --with-abi=m64 --enable-checking=release --build=x86_64-linux-gnu
> --host=x86_64-linux-gnu --target=x86_64-linux-gnu
> Thread model: posix
> gcc version 6.1.0 (GCC)
> 
> The --with-tune=skylake didn't work as it didn't know it. unfortunately.

I'm sorry, but I have no clue.  This is probably a question to some gcc
development mailing list. ;)

--
Cheers,
Luca.
