Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.trained-monkey.org ([178.250.213.29]:37023 "EHLO
	ultrasam.lan.trained-monkey.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751956AbaGAHWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:22:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: rtl8723au: Remove unnecessary null test before kfree
References: <1404027603-4121-1-git-send-email-fabf@skynet.be>
Date: Tue, 01 Jul 2014 09:01:14 +0200
In-Reply-To: <1404027603-4121-1-git-send-email-fabf@skynet.be> (Fabian
	Frederick's message of "Sun, 29 Jun 2014 09:40:03 +0200")
Message-ID: <wrfjzjgtsgud.fsf@ultrasam.lan.trained-monkey.org> (sfid-20140701_092313_130715_09B868E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabian Frederick <fabf@skynet.be> writes:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
> index 1696cb8..6af2b4a 100644
> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
> @@ -516,9 +516,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
>  
>  	psecnetwork = &psecuritypriv->sec_bss;
>  	if (!psecnetwork) {
> -		if (pcmd)
> -			kfree(pcmd);
> -
> +		kfree(pcmd);
>  		res = _FAIL;
>  
>  		RT_TRACE(_module_rtl871x_cmd_c_, _drv_err_,

Thanks, I applied this one to the rtl8723au tree.

Jes
