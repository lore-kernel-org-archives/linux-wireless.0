Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34213 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbbIJNHb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 09:07:31 -0400
Received: by wicfx3 with SMTP id fx3so27451958wic.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2015 06:07:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix bad rssi reading
Date: Thu, 10 Sep 2015 15:07:26 +0200
Message-ID: <1738409.B3jGDQ6NWL@debian64> (sfid-20150910_150734_213600_29431C73)
In-Reply-To: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com>
References: <1441908285-606-1-git-send-email-hiroaki.kawai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, September 10, 2015 06:04:45 PM Hiroaki KAWAI wrote:
> Fix rssi calculation error which was introduced in otus to ar9170
> porting.
> 
> Signed-off-by: Hiroaki KAWAI <hiroaki.kawai@gmail.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

For reference: Here's the line in the original otus code:
<http://lxr.free-electrons.com/source/drivers/staging/otus/hal/hpusb.c?v=2.6.33#L818>

This value/result isn't used anywhere, so we could also remove it. 

> ---
>  drivers/net/wireless/ath/carl9170/rx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
> index 924135b..d66533c 100644
> --- a/drivers/net/wireless/ath/carl9170/rx.c
> +++ b/drivers/net/wireless/ath/carl9170/rx.c
> @@ -453,7 +453,7 @@ static void carl9170_rx_phy_status(struct ar9170 *ar,
>  	/* post-process RSSI */
>  	for (i = 0; i < 7; i++)
>  		if (phy->rssi[i] & 0x80)
> -			phy->rssi[i] = ((phy->rssi[i] & 0x7f) + 1) & 0x7f;
> +			phy->rssi[i] = ((~phy->rssi[i] & 0x7f) + 1) & 0x7f;
>  
>  	/* TODO: we could do something with phy_errors */
>  	status->signal = ar->noise[0] + phy->rssi_combined;
> 

