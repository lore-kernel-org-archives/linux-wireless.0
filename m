Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34521 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbbCMPoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 11:44:24 -0400
Message-ID: <550305D5.9080209@lwfinger.net> (sfid-20150313_164446_750346_0C348AC1)
Date: Fri, 13 Mar 2015 10:44:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 14/16] staging: rtl8723au: Improve readability of two
 very long lines
References: <1426216532-24058-1-git-send-email-m.v.b@runbox.com> <1426216532-24058-15-git-send-email-m.v.b@runbox.com>
In-Reply-To: <1426216532-24058-15-git-send-email-m.v.b@runbox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/12/2015 10:15 PM, M. Vefa Bicakci wrote:
> Improve the readability of an if statement and its very long trace
> output line in rtl8723au's rtw_security.c.
>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> ---
>   drivers/staging/rtl8723au/core/rtw_security.c | 18 +++++++++++++++---
>   1 file changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index dbbe7b348d..fd04ae78bb 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -759,9 +759,21 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>
>   	*((u32 *)crc) = le32_to_cpu(getcrc32(payload, length-4));
>
> -	if (crc[3] != payload[length - 1] || crc[2] != payload[length - 2] || crc[1] != payload[length - 3] || crc[0] != payload[length - 4]) {
> -		RT_TRACE(_module_rtl871x_security_c_, _drv_err_, ("rtw_wep_decrypt23a:icv error crc[3](%x)!= payload[length-1](%x) || crc[2](%x)!= payload[length-2](%x) || crc[1](%x)!= payload[length-3](%x) || crc[0](%x)!= payload[length-4](%x)\n",
> -				crc[3], payload[length - 1], crc[2], payload[length - 2], crc[1], payload[length - 3], crc[0], payload[length - 4]));
> +	if (crc[3] != payload[length - 1] ||
> +			crc[2] != payload[length - 2] ||
> +			crc[1] != payload[length - 3] ||
> +			crc[0] != payload[length - 4]) {

The continuation lines should be lined up with the opening paren. This should be

	if (crc[3] != payload[length - 1] ||
	    crc[2] != payload[length - 2] ||
	    crc[1] != payload[length - 3] ||
	    crc[0] != payload[length - 4]) {

> +
> +		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
> +				("rtw_wep_decrypt23a:icv error "
> +				 "crc[3](%x)!= payload[length-1](%x) || "
> +				 "crc[2](%x)!= payload[length-2](%x) || "
> +				 "crc[1](%x)!= payload[length-3](%x) || "
> +				 "crc[0](%x)!= payload[length-4](%x)\n",
> +				 crc[3], payload[length - 1],
> +				 crc[2], payload[length - 2],
> +				 crc[1], payload[length - 3],
> +				 crc[0], payload[length - 4]));

Same problem here.

Larry

