Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:46459 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966302AbeCAKXG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:23:06 -0500
Subject: Re: [PATCH] mt7601u: remove a warning in
 mt7601u_efuse_physical_size_check()
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
 <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
From: Bas Vermeulen <bvermeul@blackstar.nl>
Message-ID: <3263f88f-daec-837c-e58c-bee907295d47@blackstar.nl> (sfid-20180301_112412_306938_B25EF930)
Date: Thu, 1 Mar 2018 11:22:12 +0100
MIME-Version: 1.0
In-Reply-To: <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-02-18 15:26, Lorenzo Bianconi wrote:
> Fix the following sparse warning in mt7601u_efuse_physical_size_check:
> - drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
>    Variable length array is used
>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>   drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> index da6faea092d6..a462064b5c91 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> @@ -74,7 +74,7 @@ static int
>   mt7601u_efuse_physical_size_check(struct mt7601u_dev *dev)
>   {
>   	const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
> -	u8 data[map_reads * 16];
> +	u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
Shouldn't this be u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE,16)*16]; to 
get the
same array size as before?

Bas Vermeulen

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
