Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:49378 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYGWQEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:04:52 -0400
Received: by nf-out-0910.google.com with SMTP id d3so896361nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 09:04:51 -0700 (PDT)
To: Daniel Wagner <wagi@monom.org>
Subject: Re: [PATCH] rt2x00mac: In error case stop netdev queue, free skb and return NETDEV_TX_OK
Date: Wed, 23 Jul 2008 18:22:04 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216805279-19149-1-git-send-email-wagi@monom.org>
In-Reply-To: <1216805279-19149-1-git-send-email-wagi@monom.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807231822.04895.IvDoorn@gmail.com> (sfid-20080723_180457_288184_B4DD3DAF)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Daniel Wagner wrote:
> It is not allowed to use NETDEV_TX_BUSY in tx path anymore.

If not, then why is mac80211 checking and handling the return value
and is tx() still a function returning an int. mac80211 is actually requeueing
the frame when the hardware fails to send it, so why should that be completely blocked?

> Signed-off-by: Daniel Wagner <wagi@monom.org>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index 77af1df..64a70c6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -46,7 +46,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
>  	skb = dev_alloc_skb(size + rt2x00dev->hw->extra_tx_headroom);
>  	if (!skb) {
>  		WARNING(rt2x00dev, "Failed to create RTS/CTS frame.\n");
> -		return NETDEV_TX_BUSY;
> +		return -1;

I am kind of missing the point here, this patch seems to come down to:
	We can't return TX_BUSY so we return a random other value

Ivo
