Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32994 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934883AbbIVVa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 17:30:58 -0400
Subject: Re: [PATCH] staging: rtl8723au: Mark type casts to __le32 as
 intentional
To: Lars Svensson <lars1.svensson@sonymobile.com>
References: <1442906641-22824-1-git-send-email-lars1.svensson@sonymobile.com>
Cc: Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	m.v.b@runbox.com, gdonald@gmail.com, joe@perches.com,
	ruchandani.tina@gmail.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5601C88E.4010807@lwfinger.net> (sfid-20150922_233133_567769_90098FE6)
Date: Tue, 22 Sep 2015 16:30:54 -0500
MIME-Version: 1.0
In-Reply-To: <1442906641-22824-1-git-send-email-lars1.svensson@sonymobile.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2015 02:24 AM, Lars Svensson wrote:
> Fixing Sparse warnings about intentional type casts in rtw_security.c
> as below.
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
>   drivers/staging/rtl8723au/core/rtw_security.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index 3d40bab..311dfc1 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -213,6 +213,7 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
>   {
>   	/*  exclude ICV */
>   	u32 actual_crc, expected_crc;
> +	__le32 crc_le;
>   	struct arc4context mycontext;
>   	int length;
>   	u32 keylength;
> @@ -245,8 +246,10 @@ void rtw_wep_decrypt23a(struct rtw_adapter *padapter,
>   	arcfour_encrypt(&mycontext, payload, payload, length);
>
>   	/* calculate icv and compare the icv */
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	crc_le = (__force __le32)getcrc32(payload, length - 4);
> +	actual_crc = le32_to_cpu(crc_le);
> +	crc_le = (__force __le32)get_unaligned_le32(&payload[length - 4]);
> +	expected_crc = le32_to_cpu(crc_le);
>
>   	if (actual_crc != expected_crc) {
>   		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
> @@ -717,6 +720,7 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>   	u8 rc4key[16];
>   	u8 ttkey[16];
>   	u32 actual_crc, expected_crc;
> +	__le32 crc_le;
>   	struct arc4context mycontext;
>   	int length;
>   	u32 prwskeylen;
> @@ -772,9 +776,10 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>   	/* 4 decrypt payload include icv */
>   	arcfour_init(&mycontext, rc4key, 16);
>   	arcfour_encrypt(&mycontext, payload, payload, length);
> -
> -	actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
> -	expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
> +	crc_le = (__force __le32)getcrc32(payload, length - 4);
> +	actual_crc = le32_to_cpu(crc_le);
> +	crc_le = (__force __le32)get_unaligned_le32(&payload[length - 4]);
> +	expected_crc = le32_to_cpu(crc_le);
>
>   	if (actual_crc != expected_crc) {
>   		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
>

You may have silenced the Sparse warnings, but the code was not wrong. Your 
version is also correct; however, you end up with some really ugly casts.

Here is my analysis of these two, identical sections:

The output of getcrc32() is an unsigned, 4-byte quantity that has the endianess 
of the cpu. Therefore, the le32_to_cpu() conversion is suspect for a big-endian 
machine. Those statements should be be a simple "actual_crc = getcrc32(....).

The expected crc comes from a byte string that is in little-endian order. For 
that reason, it needs to be converted on big-endian machines, which is exactly 
what get_unaligned_le32() does. Thus, the second statement in each block becomes 
"expected_crc = get_unaligned_le32(....)".

Both the original code and your patch byte swap both quantities, thus they get 
the correct result. at least if all you are doing is to compare the two results.

The *complete* patch to fix the Sparse warnings is

Index: wireless-drivers-next-new/drivers/staging/rtl8723au/core/rtw_security.c
===================================================================
--- wireless-drivers-next-new.orig/drivers/staging/rtl8723au/core/rtw_security.c
+++ wireless-drivers-next-new/drivers/staging/rtl8723au/core/rtw_security.c
@@ -245,8 +245,8 @@ void rtw_wep_decrypt23a(struct rtw_adapt
         arcfour_encrypt(&mycontext, payload, payload, length);

         /* calculate icv and compare the icv */
-       actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-       expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+       actual_crc = getcrc32(payload, length - 4);
+       expected_crc = get_unaligned_le32(&payload[length - 4]);

         if (actual_crc != expected_crc) {
                 RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
@@ -773,8 +773,8 @@ int rtw_tkip_decrypt23a(struct rtw_adapt
         arcfour_init(&mycontext, rc4key, 16);
         arcfour_encrypt(&mycontext, payload, payload, length);

-       actual_crc = le32_to_cpu(getcrc32(payload, length - 4));
-       expected_crc = le32_to_cpu(get_unaligned_le32(&payload[length - 4]));
+       actual_crc = getcrc32(payload, length - 4);
+       expected_crc = get_unaligned_le32(&payload[length - 4]);

         if (actual_crc != expected_crc) {
                 RT_TRACE(_module_rtl871x_security_c_, _drv_err_,

The above compiles with no Sparse warnings, and I think it would work on both LE 
and BE architectures; however, it has only been compile tested.

Larry

