Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36333 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbbCNQ3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 12:29:03 -0400
Received: by oiaz123 with SMTP id z123so8617332oia.3
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 09:29:02 -0700 (PDT)
Message-ID: <550461CC.5060602@lwfinger.net> (sfid-20150314_172907_673763_60CA07D2)
Date: Sat, 14 Mar 2015 11:29:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jeff Layton <jeff.layton@primarydata.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8188ee: fix build break due to missing rtl_hal_pwrseqcmdparsing
 definition
References: <1426349237-7501-1-git-send-email-jeff.layton@primarydata.com>
In-Reply-To: <1426349237-7501-1-git-send-email-jeff.layton@primarydata.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2015 11:07 AM, Jeff Layton wrote:
> I've been getting this error when building mainline kernels using
> Fedora's config files:
>
>      drivers/net/wireless/rtlwifi/rtl8188ee/hw.c: In function ‘_rtl88ee_init_mac’:
>      drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:853:2: error: implicit declaration of function ‘rtl_hal_pwrseqcmdparsing’ [-Werror=implicit-function-declaration]
>        if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
>        ^
>      cc1: some warnings being treated as errors
>      scripts/Makefile.build:258: recipe for target 'drivers/net/wireless/rtlwifi/rtl8188ee/hw.o' failed
>
> I'm not sure if this is the correct fix, but it does seem to allow the
> build to complete. I suspect that this was broken by commit 34ed780a6afc
> (rtlwifi: Fix problems with building an allyesconfig). Most of the files
> that removed the include of pwrseqcmd.h, added one for ../pwrseqcmd.h.
> The rtl8188ee driver had it removed it but didn't add the include of the
> file in the parent directory.
>
> Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8188ee/hw.c | 1 +
>   1 file changed, 1 insertion(+)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

This fix is certainly OK. What I do not understand is why neither I nor the 
build testing computers see the problem. Does this show for all architectures? I 
have only built this driver for x86_64.

Thanks,

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> index f2b9713c456e..e6fae1b5c211 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
> @@ -30,6 +30,7 @@
>   #include "../cam.h"
>   #include "../ps.h"
>   #include "../pci.h"
> +#include "../pwrseqcmd.h"
>   #include "reg.h"
>   #include "def.h"
>   #include "phy.h"
>

