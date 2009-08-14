Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:44743 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZHNJus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 05:50:48 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFT] ar9170: downgrade BUG_ON() on unexpected mdpu
Date: Fri, 14 Aug 2009 11:50:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <1250215295-11253-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1250215295-11253-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200908141150.54153.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 14 August 2009 04:01:35 Luis R. Rodriguez wrote:
> If someone pulls the harware out while RX'ing a lot of traffic
> I would funky data may be passed, BUG_ON() seems pretty extreme
> so lets just drop the frame as we do when the length does not
> meet our criteria for processing.
> 
> Cc: Christian Lamparter <chunkeey@web.de>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> This one depends on my previous patch.
> 
>  drivers/net/wireless/ath/ar9170/main.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
> index 75c317d..0bbbc36 100644
> --- a/drivers/net/wireless/ath/ar9170/main.c
> +++ b/drivers/net/wireless/ath/ar9170/main.c
> @@ -1068,8 +1068,11 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
>  		break;
>  
>  	default:
> -		BUG_ON(1);
> -		break;
> +		if (ar9170_nag_limiter(ar))
> +			printk(KERN_ERR "%s: rx'd unexpected "
> +			       "type of MPDU.\n",
> +			       wiphy_name(ar->hw->wiphy));
> +		return;
>  	}

no, this is really impossible! really!

But let's take a closer look why should be so:

the switch goes like this:
> switch (mac->status & AR9170_RX_STATUS_MPDU_MASK) {
mac->status is a u8 and AND with AR9170_RX_STATUS_MPDU_MASK.

AR9170_RX_STATUS_MPDU_MASK (etc.) is #define in hw.h
and it's a 0x30 _mask_.

This leaves only four possibilities: 0x00, 0x10, 0x20, 0x30.

>case AR9170_RX_STATUS_MPDU_FIRST: (case 0x20:)
>case AR9170_RX_STATUS_MPDU_LAST: (case 0x10:)
>case AR9170_RX_STATUS_MPDU_MIDDLE: (case 0x30:)
>case AR9170_RX_STATUS_MPDU_SINGLE: (case 0x00:)

so the default case is a deadly dead code path here ;-).
And the reason why you see it was because some checker tool kept
complaining about unlikely _corner_ cases.

>  	if (unlikely(mpdu_len < FCS_LEN))

Regards,
	Chr
