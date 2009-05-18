Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60715 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZERNaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 09:30:11 -0400
Date: Mon, 18 May 2009 09:17:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alexandre Becholey <alexandre.becholey@epfl.ch>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH]rt73usb: fix for master mode.
Message-ID: <20090518131704.GC2814@tuxdriver.com>
References: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242651336-12621-1-git-send-email-alexandre.becholey@epfl.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 02:55:36PM +0200, Alexandre Becholey wrote:
> Report status unknown as if there were successfully transmitted.
> This will avoid hostapd to disassociate because it doesn't understand what a status unknown is.
> 
> Signed-off-by: Alexandre Becholey <alexandre.becholey@epfl.ch>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 

Seems OK, but...

> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index f227084..0bbee06 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -280,6 +280,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>  	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK)) {
>  		if (test_bit(TXDONE_SUCCESS, &txdesc->flags))
>  			tx_info->flags |= IEEE80211_TX_STAT_ACK;
> +                /* Report unkown status as if it was success */
> +                else if (test_bit(TXDONE_UNKNOWN, &txdesc->flags))
> +                        tx_info->flags |= IEEE80211_TX_STAT_ACK;
>  		else if (test_bit(TXDONE_FAILURE, &txdesc->flags))
>  			rt2x00dev->low_level_stats.dot11ACKFailureCount++;
>  	}

Please use tabs...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
