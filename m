Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65121 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab3KNQmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 11:42:37 -0500
Received: by mail-wi0-f177.google.com with SMTP id hq4so2880165wib.16
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 08:42:35 -0800 (PST)
Message-ID: <5284FD77.2080702@gmail.com> (sfid-20131114_174251_635464_C46FAB84)
Date: Thu, 14 Nov 2013 17:42:31 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Kevin Lo <kevlo@kevlo.org>, John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: no need to write RF
 register 3 twice for RT5592
References: <20131114055344.GA74271@ns.kevlo.org>
In-Reply-To: <20131114055344.GA74271@ns.kevlo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/14/13 06:53, Kevin Lo wrote:
> In rt2800_init_rfcsr_5592(), there's no need to write RF register 3 twice.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 776aff3..18506f8 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -6602,7 +6602,6 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>  
>  	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
>  	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
> -	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
>  	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
>  	rt2800_rfcsr_write(rt2x00dev, 6, 0xE4);
>  	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
> 
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
> 


-- 
---
Gertjan
