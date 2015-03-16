Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810AbbCPQi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:38:28 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 15/16] staging: rtl8723au: Correct a typo in a trace log line
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
	<1426378241-32469-16-git-send-email-m.v.b@runbox.com>
Date: Mon, 16 Mar 2015 12:38:03 -0400
In-Reply-To: <1426378241-32469-16-git-send-email-m.v.b@runbox.com> (M. Vefa
	Bicakci's message of "Sat, 14 Mar 2015 20:10:40 -0400")
Message-ID: <wrfj1tkosxsk.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150316_173844_823729_3157BE41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"M. Vefa Bicakci" <m.v.b@runbox.com> writes:
> Correct a typo in rtl8723au's rtw_security.c which was most likely
> caused by a copy and paste mistake. Prior to this commit, the TKIP
> decryption function referred to WEP in its trace log output.
>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_security.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index eb3544866a..e8d3ce53bb 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -757,7 +757,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>  
>  	if (actual_crc != expected_crc) {
>  		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
> -			 ("rtw_wep_decrypt23a:icv CRC mismatch: "
> +			 ("rtw_tkip_decrypt23a:icv CRC mismatch: "

If you made this ("%s:icv ....", __func__, ....

you wouldn't have to worry about matching the function name to the debug
text, in case the function later got renamed.

Cheers,
Jes

>  			  "actual: %08x, expected: %08x\n",
>  			  actual_crc, expected_crc));
>  		res = _FAIL;
