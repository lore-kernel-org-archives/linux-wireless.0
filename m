Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36128 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbbHISJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2015 14:09:51 -0400
Subject: Re: [PATCH] type assignment and restricted type cast error fixes for
 rtl8723au/core/rtw_security.c
To: Jacob Kiefer <jtk54@cornell.edu>
References: <1439140941-16008-1-git-send-email-jtk54@cornell.edu>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"M. Vefa Bicakci" <m.v.b@runbox.com>,
	Greg Donald <gdonald@gmail.com>, Joe Perches <joe@perches.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55C7976C.2040504@lwfinger.net> (sfid-20150809_201046_833071_9FF83BBA)
Date: Sun, 9 Aug 2015 13:09:48 -0500
MIME-Version: 1.0
In-Reply-To: <1439140941-16008-1-git-send-email-jtk54@cornell.edu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2015 12:22 PM, Jacob Kiefer wrote:
> This patch fixes the following sparse errors:
>
>    CHECK   drivers/staging/rtl8723au/core/rtw_security.c
> drivers/staging/rtl8723au/core/rtw_security.c:189:39: \
>    warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/core/rtw_security.c:189:39:    \
>    expected unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:189:39:    \
>    got restricted __le32 [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:197:39: \
>    warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/core/rtw_security.c:197:39:    \
>    expected unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:197:39:    \
>    got restricted __le32 [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:246:22: \
>    warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:247:24: \
>    warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:682:39: \
>    warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/core/rtw_security.c:682:39:    \
>    expected unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:682:39:    \
>    got restricted __le32 [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:694:39: \
>    warning: incorrect type in assignment (different base types)
> drivers/staging/rtl8723au/core/rtw_security.c:694:39:    \
>    expected unsigned int [unsigned] [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:694:39:    \
>    got restricted __le32 [usertype] <noident>
> drivers/staging/rtl8723au/core/rtw_security.c:772:22: \
>    warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:773:24: \
>    warning: cast to restricted __le32
>
> Signed-off-by: Jacob Kiefer <jtk54@cornell.edu>
> ---
>   drivers/staging/rtl8723au/core/rtw_security.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)

The subject needs work. I recommend "staging: rtl8723au: Fix Sparse errors in 
rtw_security.c".

You may be clearing the Sparse errors, but I think you are creating real errors 
in the code! The output of getcrc32 needs to be converted to __le32 before 
transmission. On a little-endian machine, it wont make any difference in the 
code, but for big-endian systems, it will.

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index af53c92..004e7c9 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -186,7 +186,7 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
>   			length = pattrib->last_txcmdsz - pattrib->hdrlen -
>   				pattrib->iv_len - pattrib->icv_len;
>
> -			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
> +			*((u32 *)crc) = getcrc32(payload, length);

Here, you need to leave the cpu_to_le32() call alone, and worry about the type 
of crc. It should be __le32, and the cast will no longer be necessary.

>
>   			arcfour_init(&mycontext, wepkey, 3 + keylength);
>   			arcfour_encrypt(&mycontext, payload, payload, length);
> @@ -194,7 +194,7 @@ void rtw_wep_encrypt23a(struct rtw_adapter *padapter,
>   		} else {
>   			length = pxmitpriv->frag_len - pattrib->hdrlen -
>   				pattrib->iv_len - pattrib->icv_len;
> -			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
> +			*((u32 *)crc) = getcrc32(payload, length);

Ditto here.

>   			arcfour_init(&mycontext, wepkey, 3 + keylength);
>   			arcfour_encrypt(&mycontext, payload, payload, length);
>   			arcfour_encrypt(&mycontext, payload + length, crc, 4);
> @@ -243,8 +243,8 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
>   	arcfour_encrypt(&mycontext, payload, payload, length);
>
>   	/* calculate icv and compare the icv */
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	actual_crc = getcrc32(payload, length - 4);
> +	expected_crc = get_unaligned_le32(&payload[length - 4]);
>
>   	if (actual_crc != expected_crc) {
>   		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
> @@ -679,7 +679,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
>   				 "pattrib->iv_len =%x, pattrib->icv_len =%x\n",
>   				 pattrib->iv_len,
>   				 pattrib->icv_len);
> -			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
> +			*((u32 *)crc) = getcrc32(payload, length);

Ditto.

>
>   			arcfour_init(&mycontext, rc4key, 16);
>   			arcfour_encrypt(&mycontext, payload, payload, length);
> @@ -691,7 +691,7 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
>   				  pattrib->iv_len -
>   				  pattrib->icv_len);
>
> -			*((u32 *)crc) = cpu_to_le32(getcrc32(payload, length));
> +			*((u32 *)crc) = getcrc32(payload, length);

Ditto.

>   			arcfour_init(&mycontext, rc4key, 16);
>   			arcfour_encrypt(&mycontext, payload, payload, length);
>   			arcfour_encrypt(&mycontext, payload + length, crc, 4);
> @@ -769,8 +769,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>   	arcfour_init(&mycontext, rc4key, 16);
>   	arcfour_encrypt(&mycontext, payload, payload, length);
>
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	actual_crc = getcrc32(payload, length - 4);
> +	expected_crc = get_unaligned_le32(&payload[length - 4]);
>
>   	if (actual_crc != expected_crc) {
>   		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
>

Larry

