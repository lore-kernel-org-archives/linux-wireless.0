Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbbIBMzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 08:55:53 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: =?utf-8?Q?Micha=C5=82?= Bartoszkiewicz <mbartoszkiewicz@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: remove unnecessary le32_to_cpu
References: <1441150500-14023-1-git-send-email-mbartoszkiewicz@gmail.com>
Date: Wed, 02 Sep 2015 08:55:50 -0400
In-Reply-To: <1441150500-14023-1-git-send-email-mbartoszkiewicz@gmail.com>
	(=?utf-8?Q?=22Micha=C5=82?= Bartoszkiewicz"'s message of "Wed, 2 Sep 2015
 01:35:00
	+0200")
Message-ID: <wrfj1tehvv3d.fsf@redhat.com> (sfid-20150902_145613_547098_27D942FE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michał Bartoszkiewicz <mbartoszkiewicz@gmail.com> writes:
> The values passed to le32_to_cpu are already in the correct byte order.
> This fixes four "cast to restricted __le32" sparse warnings.
>
> Signed-off-by: Michał Bartoszkiewicz <mbartoszkiewicz@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_security.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Sounds OK to me - the fact we never hit problems with this is a good
indicator the hw crypt functions work.

Cheers,
Jes

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index 3d40bab..9d1cce1 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -245,8 +245,8 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
>  	arcfour_encrypt(&mycontext, payload, payload, length);
>  
>  	/* calculate icv and compare the icv */
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	actual_crc = getcrc32(payload, length - 4);
> +	expected_crc = get_unaligned_le32(&payload[length - 4]);
>  
>  	if (actual_crc != expected_crc) {
>  		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
> @@ -773,8 +773,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>  	arcfour_init(&mycontext, rc4key, 16);
>  	arcfour_encrypt(&mycontext, payload, payload, length);
>  
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	actual_crc = getcrc32(payload, length - 4);
> +	expected_crc = get_unaligned_le32(&payload[length - 4]);
>  
>  	if (actual_crc != expected_crc) {
>  		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
