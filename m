Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46171 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZKJSci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:32:38 -0500
Received: by ewy3 with SMTP id 3so328084ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:32:43 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix typo in rf programming of rt2800lib.
Date: Tue, 10 Nov 2009 19:32:40 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257803944-5344-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257803944-5344-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911101932.40509.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009, Gertjan van Wingerde wrote:
> Fix a type in rt2800_config_channel_rt3x. The second write to RF register 2 should be to RF register 3.
> This is confirmed by the legacy Ralink code.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> Corrected the subject of the email to state that it is a single patch.
> 
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


