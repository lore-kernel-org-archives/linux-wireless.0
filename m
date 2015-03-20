Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51265 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbCTGaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 02:30:09 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtl8188ee: fix build break due to missing
 rtl_hal_pwrseqcmdparsingdefinition
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426349237-7501-1-git-send-email-jeff.layton@primarydata.com>
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Message-Id: <20150320063008.965E3140B84@smtp.codeaurora.org> (sfid-20150320_073013_512693_920648A5)
Date: Fri, 20 Mar 2015 06:30:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I've been getting this error when building mainline kernels using
> Fedora's config files:
> 
>     drivers/net/wireless/rtlwifi/rtl8188ee/hw.c: In function ‘_rtl88ee_init_mac’:
>     drivers/net/wireless/rtlwifi/rtl8188ee/hw.c:853:2: error: implicit declaration of function ‘rtl_hal_pwrseqcmdparsing’ [-Werror=implicit-function-declaration]
>       if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
>       ^
>     cc1: some warnings being treated as errors
>     scripts/Makefile.build:258: recipe for target 'drivers/net/wireless/rtlwifi/rtl8188ee/hw.o' failed
> 
> I'm not sure if this is the correct fix, but it does seem to allow the
> build to complete. I suspect that this was broken by commit 34ed780a6afc
> (rtlwifi: Fix problems with building an allyesconfig). Most of the files
> that removed the include of pwrseqcmd.h, added one for ../pwrseqcmd.h.
> The rtl8188ee driver had it removed it but didn't add the include of the
> file in the parent directory.
> 
> Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
