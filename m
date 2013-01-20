Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:64957 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3ATKnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 05:43:08 -0500
Message-ID: <50FBCA64.20505@gmail.com> (sfid-20130120_114313_318360_A8763217)
Date: Sun, 20 Jan 2013 18:43:48 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/wireless/iwlegacy: adding check length for
 parameter buf
References: <50FBBEB2.2000306@asianux.com>
In-Reply-To: <50FBBEB2.2000306@asianux.com>
Content-Type: multipart/mixed;
 boundary="------------030204050601060100040608"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030204050601060100040608
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit

  oh, sorry, it is my fault.

  according to fill_write_buffer in fs/sysfs/file.c,
    we can assume that 'const char *buf' must be '\0' based string.

  please skip this patch.


gchen.


于 2013年01月20日 17:53, Chen Gang 写道:
> 
>   the parameter 'const char *buf' may be not '\0' based string.
>   so need check the length before use it.
> 
> additinal info:
>   originally, it had the relative checking.
>   but it was deleted when fix another issues (using strlcpy instead of
> strncpy)
>   and now, we need restore the checking (but still keep strlcpy)
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c
> b/drivers/net/wireless/iwlegacy/3945-mac.c
> index 050ce7c..71cdbac 100644
> --- a/drivers/net/wireless/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/iwlegacy/3945-mac.c
> @@ -3273,7 +3273,7 @@ il3945_store_measurement(struct device *d, struct
> device_attribute *attr,
> 
>  	if (count) {
>  		char *p = buffer;
> -		strlcpy(buffer, buf, sizeof(buffer));
> +		strlcpy(buffer, buf, min(sizeof(buffer), count));
>  		channel = simple_strtoul(p, NULL, 0);
>  		if (channel)
>  			params.channel = channel;
> 


-- 
Chen Gang

Flying Transformer

--------------030204050601060100040608
Content-Type: text/x-vcard; charset=utf-8;
 name="chen_gang_flying_transformer.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="chen_gang_flying_transformer.vcf"

YmVnaW46dmNhcmQNCmZuOkNoZW4gR2FuZw0Kbjo7Q2hlbiBHYW5nDQp2ZXJzaW9uOjIuMQ0K
ZW5kOnZjYXJkDQoNCg==
--------------030204050601060100040608--
