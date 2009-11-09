Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36687 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbZKIWBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:01:19 -0500
Received: by ewy3 with SMTP id 3so3629113ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:01:24 -0800 (PST)
Message-ID: <4AF89132.4090508@gmail.com>
Date: Mon, 09 Nov 2009 23:01:22 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Gertjan van Wingerde <gwingerde@wingerd.gvw.nl>
Subject: Re: [PATCH 6/9] rt2x00: Fix typo in rf programming of rt2800lib.
References: <1257803751-5265-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257803751-5265-1-git-send-email-gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/09/09 22:55, Gertjan van Wingerde wrote:
> From: Gertjan van Wingerde <gwingerde@wingerd.gvw.nl>
> 
> Fix a type in rt2800_config_channel_rt3x. The second write to RF register 2 should be to RF register 3.
> This is confirmed by the legacy Ralink code.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 24b3af4..2c91c44 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -774,7 +774,7 @@ static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
>  	u8 rfcsr;
>  
>  	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf1);
> -	rt2800_rfcsr_write(rt2x00dev, 2, rf->rf3);
> +	rt2800_rfcsr_write(rt2x00dev, 3, rf->rf3);
>  
>  	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>  	rt2x00_set_field8(&rfcsr, RFCSR6_R, rf->rf2);


Please disregard this one. I goofed up the subject of the email again. Will resubmit as a single patch.

---
Gertjan.
