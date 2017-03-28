Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34758 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbdC1Wz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 18:55:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170109175222.3162-1-paul.gortmaker@windriver.com>
References: <201701090839.5u37Hdez%fengguang.wu@intel.com> <20170109175222.3162-1-paul.gortmaker@windriver.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 28 Mar 2017 18:55:26 -0400
Message-ID: <CAP=VYLovck5PFD-5C93QahwkGv3ygkWaKjGy90MjNtEodF242Q@mail.gmail.com> (sfid-20170329_005832_455766_A7FBD84F)
Subject: Re: [PATCH v2] nfc: don't be making arch specific unaligned decisions
 at driver level.
To: LKML <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: kbuild test robot <lkp@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 9, 2017 at 12:52 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Currently ia64 fails building allmodconfig with variations of:
>
>    In file included from drivers/nfc/nxp-nci/i2c.c:39:0:
>    ./include/linux/unaligned/access_ok.h:62:29: error: redefinition of =
=E2=80=98put_unaligned_be64=E2=80=99
>     static __always_inline void put_unaligned_be64(u64 val, void *p)

Hi Samuel,

Do you require changes on this commit, or are you happy to queue it as is?
Looking at the NFC git history it seems like you are the right person to as=
k.

Thanks,
Paul.
--

>    In file included from ./arch/ia64/include/asm/unaligned.h:5:0,
>                     from ./arch/ia64/include/asm/io.h:22,
>                     from ./arch/ia64/include/asm/smp.h:20,
>                     from ./include/linux/smp.h:59,
>                     from ./include/linux/topology.h:33,
>                     from ./include/linux/gfp.h:8,
>                     from ./include/linux/slab.h:14,
>                     from ./include/linux/resource_ext.h:19,
>                     from ./include/linux/acpi.h:26,
>                     from drivers/nfc/nxp-nci/i2c.c:28:
>    ./include/linux/unaligned/be_byteshift.h:65:20: note: previous definit=
ion of =E2=80=98put_unaligned_be64=E2=80=99 was here
>     static inline void put_unaligned_be64(u64 val, void *p)
>                        ^~~~~~~~~~~~~~~~~~
>    scripts/Makefile.build:293: recipe for target 'drivers/nfc/nxp-nci/i2c=
.o' failed
>
> The easiest explanation for this is to look at the non-arch users in
> the following output:
>
>    linux$git grep include.*access_ok.h
>    arch/arm64/crypto/crc32-arm64.c:#include <linux/unaligned/access_ok.h>
>    arch/cris/include/asm/unaligned.h:#include <linux/unaligned/access_ok.=
h>
>    arch/m68k/include/asm/unaligned.h:#include <linux/unaligned/access_ok.=
h>
>    arch/mn10300/include/asm/unaligned.h:#include <linux/unaligned/access_=
ok.h>
>    arch/powerpc/include/asm/unaligned.h:#include <linux/unaligned/access_=
ok.h>
>    arch/s390/include/asm/unaligned.h:#include <linux/unaligned/access_ok.=
h>
>    arch/x86/include/asm/unaligned.h:#include <linux/unaligned/access_ok.h=
>
>    drivers/nfc/nfcmrvl/fw_dnld.c:#include <linux/unaligned/access_ok.h>
>    drivers/nfc/nxp-nci/firmware.c:#include <linux/unaligned/access_ok.h>
>    drivers/nfc/nxp-nci/i2c.c:#include <linux/unaligned/access_ok.h>
>    include/asm-generic/unaligned.h:# include <linux/unaligned/access_ok.h=
>
>
> Note that nfc is essentially the only non-arch user in the above.
> When it forces use of access_ok.h, it will break any arch that has
> already selected be_byteshift.h (or other conflicting implementations)
> at the arch level.
>
> The decision of what variant for unaligned access to use needs to be
> left to the arch level and not used at the driver level.  Since not
> all arch will have sourced asm/unaligned.h already, we need to call
> it out and then the arch can give us just the one definition that
> is needed.
>
> See commit 064106a91be5 ("kernel: add common infrastructure for
> unaligned access") as a reference.
>
> Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
> Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: linux-ia64@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>
> [v2: explicitly include asm/uaccess.h since some arch won't be
>  getting any variant of an unaligned access header without it.
>  Build test allmodconfig on x86-64, i386, arm64, ia64. ]
>
>  drivers/nfc/nfcmrvl/fw_dnld.c  | 2 +-
>  drivers/nfc/nxp-nci/firmware.c | 2 +-
>  drivers/nfc/nxp-nci/i2c.c      | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.=
c
> index f8dcdf4b24f6..f3f246ddae06 100644
> --- a/drivers/nfc/nfcmrvl/fw_dnld.c
> +++ b/drivers/nfc/nfcmrvl/fw_dnld.c
> @@ -17,11 +17,11 @@
>   */
>
>  #include <linux/module.h>
> -#include <linux/unaligned/access_ok.h>
>  #include <linux/firmware.h>
>  #include <linux/nfc.h>
>  #include <net/nfc/nci.h>
>  #include <net/nfc/nci_core.h>
> +#include <asm/unaligned.h>
>  #include "nfcmrvl.h"
>
>  #define FW_DNLD_TIMEOUT                        15000
> diff --git a/drivers/nfc/nxp-nci/firmware.c b/drivers/nfc/nxp-nci/firmwar=
e.c
> index 5291797324ba..553011f58339 100644
> --- a/drivers/nfc/nxp-nci/firmware.c
> +++ b/drivers/nfc/nxp-nci/firmware.c
> @@ -24,7 +24,7 @@
>  #include <linux/completion.h>
>  #include <linux/firmware.h>
>  #include <linux/nfc.h>
> -#include <linux/unaligned/access_ok.h>
> +#include <asm/unaligned.h>
>
>  #include "nxp-nci.h"
>
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index 36099e557730..20243dafea21 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -36,9 +36,9 @@
>  #include <linux/of_gpio.h>
>  #include <linux/of_irq.h>
>  #include <linux/platform_data/nxp-nci.h>
> -#include <linux/unaligned/access_ok.h>
>
>  #include <net/nfc/nfc.h>
> +#include <asm/unaligned.h>
>
>  #include "nxp-nci.h"
>
> --
> 2.11.0
>
