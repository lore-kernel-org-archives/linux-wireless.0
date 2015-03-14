Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:34281 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbCNQfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 12:35:43 -0400
Received: by ykft125 with SMTP id t125so4438018ykf.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 09:35:42 -0700 (PDT)
Date: Sat, 14 Mar 2015 12:35:39 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8188ee: fix build break due to missing
 rtl_hal_pwrseqcmdparsing definition
Message-ID: <20150314123539.6f3c4201@tlielax.poochiereds.net> (sfid-20150314_173547_603338_DBC2B4F7)
In-Reply-To: <550461CC.5060602@lwfinger.net>
References: <1426349237-7501-1-git-send-email-jeff.layton@primarydata.com>
	<550461CC.5060602@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 14 Mar 2015 11:29:00 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> On 03/14/2015 11:07 AM, Jeff Layton wrote:
> > I've been getting this error when building mainline kernels using
> > Fedora's config files:
> >
> >      drivers/net/wireless/rtlwifi/rtl8188ee/hw.c: In function ‘_rtl88ee_init_mac’:
> >      drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:853:2: error: implicit declaration of function ‘rtl_hal_pwrseqcmdparsing’ [-Werror=implicit-function-declaration]
> >        if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
> >        ^
> >      cc1: some warnings being treated as errors
> >      scripts/Makefile.build:258: recipe for target 'drivers/net/wireless/rtlwifi/rtl8188ee/hw.o' failed
> >
> > I'm not sure if this is the correct fix, but it does seem to allow the
> > build to complete. I suspect that this was broken by commit 34ed780a6afc
> > (rtlwifi: Fix problems with building an allyesconfig). Most of the files
> > that removed the include of pwrseqcmd.h, added one for ../pwrseqcmd.h.
> > The rtl8188ee driver had it removed it but didn't add the include of the
> > file in the parent directory.
> >
> > Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
> > ---
> >   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 1 +
> >   1 file changed, 1 insertion(+)
> 
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> This fix is certainly OK. What I do not understand is why neither I nor the 
> build testing computers see the problem. Does this show for all architectures? I 
> have only built this driver for x86_64.
> 
> Thanks,
> 
> Larry
> 
> >
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > index f2b9713c456e..e6fae1b5c211 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> > @@ -30,6 +30,7 @@
> >   #include "../cam.h"
> >   #include "../ps.h"
> >   #include "../pci.h"
> > +#include "../pwrseqcmd.h"
> >   #include "reg.h"
> >   #include "def.h"
> >   #include "phy.h"
> >
> 

I'm a little baffled too as to why it's failing for me. At first I had
assumed that it was temporary breakage, but I've been seeing this fail
to build for a while now (at least a few months). I'm also building on
x86_64 (Fedora 21, fwiw).

Here's a verbose build output of that file without this patch. Maybe
you can spot some difference? It's possible I have something configured
wrong, but everything else seems to build just fine...

[jlayton@tlielax linux]$ make M=drivers/net/wireless/rtlwifi/rtl8188ee -j4 V=1
test -e include/generated/autoconf.h -a -e include/config/auto.conf || (		\
echo >&2;							\
echo >&2 "  ERROR: Kernel configuration is invalid.";		\
echo >&2 "         include/generated/autoconf.h or include/config/auto.conf are missing.";\
echo >&2 "         Run 'make oldconfig && make prepare' on kernel src to fix it.";	\
echo >&2 ;							\
/bin/false)
mkdir -p drivers/net/wireless/rtlwifi/rtl8188ee/.tmp_versions ; rm -f drivers/net/wireless/rtlwifi/rtl8188ee/.tmp_versions/*
make -f ./scripts/Makefile.build obj=drivers/net/wireless/rtlwifi/rtl8188ee
  gcc -Wp,-MD,drivers/net/wireless/rtlwifi/rtl8188ee/.hw.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.9.2/include -I./arch/x86/include -Iarch/x86/include/generated/uapi -Iarch/x86/include/generated  -Iinclude -I./arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi -include ./include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -std=gnu89 -m64 -mno-80387 -mno-fp-ret-in-387 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args -DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1 -DCONFIG_AS_CFI_SECTIONS=1 -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 -DCONFIG_AS_AVX2=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fno-delete-null-pointer-checks -O2 --param=allow-store-data-races=0 -Wframe-larger-than=2048 -fstack-protector-strong -Wno-unused-but-set-variable -fno-omit-frame-pointer -fno-optimize-sibling-calls -fno-var-tracking-assignments -g -pg -mfentry -DCC_USING_FENTRY -Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Werror=date-time -DCC_HAVE_ASM_GOTO -Idrivers/net/wireless/rtlwifi -D__CHECK_ENDIAN__  -DMODULE  -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(hw)"  -D"KBUILD_MODNAME=KBUILD_STR(rtl8188ee)" -c -o drivers/net/wireless/rtlwifi/rtl8188ee/hw.o drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
(cat /dev/null;   echo kernel/drivers/net/wireless/rtlwifi/rtl8188ee/rtl8188ee.ko;) > drivers/net/wireless/rtlwifi/rtl8188ee/modules.order
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c: In function ‘_rtl88ee_init_mac’:
drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:853:2: error: implicit declaration of function ‘rtl_hal_pwrseqcmdparsing’ [-Werror=implicit-function-declaration]
  if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
  ^
cc1: some warnings being treated as errors
scripts/Makefile.build:258: recipe for target 'drivers/net/wireless/rtlwifi/rtl8188ee/hw.o' failed
make[1]: *** [drivers/net/wireless/rtlwifi/rtl8188ee/hw.o] Error 1
Makefile:1390: recipe for target '_module_drivers/net/wireless/rtlwifi/rtl8188ee' failed
make: *** [_module_drivers/net/wireless/rtlwifi/rtl8188ee] Error 2


-- 
Jeff Layton <jeff.layton@primarydata.com>
