Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbbCPQgG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 12:36:06 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "M. Vefa Bicakci" <m.v.b@runbox.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	joe@perches.com, Larry.Finger@lwfinger.net,
	gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 10/16] staging: rtl8723au: that open brace should be on the previous line
References: <1426378241-32469-1-git-send-email-m.v.b@runbox.com>
	<1426378241-32469-11-git-send-email-m.v.b@runbox.com>
Date: Mon, 16 Mar 2015 12:36:04 -0400
In-Reply-To: <1426378241-32469-11-git-send-email-m.v.b@runbox.com> (M. Vefa
	Bicakci's message of "Sat, 14 Mar 2015 20:10:35 -0400")
Message-ID: <wrfj61a0sxvv.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150316_173625_249792_575D17C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"M. Vefa Bicakci" <m.v.b@runbox.com> writes:
> Correct two instances of the checkpatch.pl error indicating that the
> opening curly braces should not be on new lines:
> 	ERROR: that open brace { should be on the previous line
>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_security.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index 803f8965a4..2d762276d3 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -760,8 +760,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>  
>  	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length - 4));
>  
> -	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4])
> -	{
> +	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
>  	    RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
>  				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
>  		res = _FAIL;

If you are mangling a line like this, don't just fix one ugliness, fix
it up properly by breaking down the line to avoid the > 80 character
mess.

Cheers,
Jes
