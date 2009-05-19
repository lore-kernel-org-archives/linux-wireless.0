Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:10107 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZESQim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 12:38:42 -0400
Received: by ey-out-2122.google.com with SMTP id 9so1245049eyd.37
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 09:38:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alexandre Becholey <alexandre.becholey@epfl.ch>
Subject: Re: [PATCH v2]rt73usb: fix for master mode
Date: Tue, 19 May 2009 18:38:39 +0200
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1242748376-8993-1-git-send-email-alexandre.becholey@epfl.ch>
In-Reply-To: <1242748376-8993-1-git-send-email-alexandre.becholey@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905191838.40202.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 19 May 2009, Alexandre Becholey wrote:
> Report status unknown as if there were successfully transmitted.
> This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.
> 
> Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>

Looks good. Thanks!

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index f227084..57813e7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -260,7 +260,8 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	 * Update TX statistics.
>  	 */
>  	rt2x00dev->link.qual.tx_success +=
> -	    test_bit(TXDONE_SUCCESS, &txdesc->flags);
> +	    test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
> +	    test_bit(TXDONE_UNKNOWN, &txdesc->flags);
>  	rt2x00dev->link.qual.tx_failed +=
>  	    test_bit(TXDONE_FAILURE, &txdesc->flags);
>  
> @@ -278,14 +279,16 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	tx_info->status.rates[1].idx = -1; /* terminate */
>  
>  	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
> -		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
> +		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
> +				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
>  			tx_info->flags |= IEEE80211_TX_STAT_ACK;
>  		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
>  			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
>  	}
>  
>  	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
> -		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
> +		if (test_bit(TXDONE_SUCCESS, &txdesc->flags) ||
> +				test_bit(TXDONE_UNKNOWN, &txdesc->flags))
>  			rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
>  		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
>  			rt2x00dev->low_level_stats.dot11RTSFailureCount++;


