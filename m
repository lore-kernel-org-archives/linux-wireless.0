Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34533 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbIZRy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2015 13:54:58 -0400
Subject: Re: [PATCH V2] staging: rtl8723au: Remove unneeded endianness
 conversions
To: Lars Svensson <lars1.svensson@sonymobile.com>
References: <20150923101109.GA1107@sonymobile.com>
 <1443078672-23970-1-git-send-email-lars1.svensson@sonymobile.com>
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	m.v.b@runbox.com, gdonald@gmail.com, joe@perches.com,
	ruchandani.tina@gmail.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5606DBEF.3010409@lwfinger.net> (sfid-20150926_195525_764837_F0909DE6)
Date: Sat, 26 Sep 2015 12:54:55 -0500
MIME-Version: 1.0
In-Reply-To: <1443078672-23970-1-git-send-email-lars1.svensson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2015 02:11 AM, Lars Svensson wrote:
> Fixing Sparse warnings in rtw_security.c. When checking crc, both
> actual and expected value was converted to cpu endianness before
> comparing, causing sparse warnings as below. Since the values are
> read from the buffer in correct byte order the extra conversions
> should not be needed.
>
> Thanks to Larry Finger for help sorting this out.
>
>    CHECK   drivers/staging/rtl8723au/core/rtw_security.c
> drivers/staging/rtl8723au/core/rtw_security.c:248:22: \
> warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:249:24: \
> warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:776:22: \
> warning: cast to restricted __le32
> drivers/staging/rtl8723au/core/rtw_security.c:777:24: \
> warning: cast to restricted __le32
>
> Signed-off-by: Lars Svensson <Lars1.Svensson@sonymobile.com>
> ---
> Patch V2: Reworked as adviced.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

> ---
>   drivers/staging/rtl8723au/core/rtw_security.c | 9 ++++-----
>   1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index 3d40bab..a44c606 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -245,8 +245,8 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
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
> @@ -772,9 +772,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>   	/* 4 decrypt payload include icv */
>   	arcfour_init(&mycontext, rc4key, 16);
>   	arcfour_encrypt(&mycontext, payload, payload, length);
> -
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	actual_crc = getcrc32(payload, length - 4);
> +	expected_crc = get_unaligned_le32(&payload[length - 4]);
>
>   	if (actual_crc != expected_crc) {
>   		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
>

