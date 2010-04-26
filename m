Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4872 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755190Ab0DZUqJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:46:09 -0400
Message-ID: <4BD5FB8F.4040507@gmail.com>
Date: Mon, 26 Apr 2010 22:46:07 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt2x00: remove usage of deprecated noise value
References: <1272312567-22853-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1272312567-22853-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/10 22:09, John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index b93731b..33c2f5f 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -434,7 +434,6 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
>  	rx_status->mactime = rxdesc.timestamp;
>  	rx_status->rate_idx = rate_idx;
>  	rx_status->signal = rxdesc.rssi;
> -	rx_status->noise = rxdesc.noise;
>  	rx_status->flag = rxdesc.flags;
>  	rx_status->antenna = rt2x00dev->link.ant.active.rx;
>  

This could actually go further than just this, as the noise field of rxdesc is only used for this
purpose, so it can actually be removed as well.
However, I guess that can be done as a follow-up, so:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
