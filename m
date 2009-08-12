Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10427 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHLMAS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 08:00:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 05:00:20 -0700
Date: Wed, 12 Aug 2009 17:28:05 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Roel Kluin <roel.kluin@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath9k: Prevent read buffer overflow
Message-ID: <20090812115803.GA4876@vasanth-laptop>
References: <4A81BB1E.6040904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A81BB1E.6040904@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2009 at 12:10:30AM +0530, Roel Kluin wrote:
> Prevent a read from valid_rate_index[] with a negative index
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Maybe we should add this?
> 
> diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> index ba06e78..a67b7f6 100644
> --- a/drivers/net/wireless/ath/ath9k/rc.c
> +++ b/drivers/net/wireless/ath/ath9k/rc.c
> @@ -1458,7 +1458,7 @@ static void ath_rc_init(struct ath_softc *sc,
>                 ath_rc_priv->rate_max_phy = ath_rc_priv->valid_phy_rateidx[i][j-1];
>         }
>         ASSERT(ath_rc_priv->rate_table_size <= RATE_TABLE_SIZE);
> -       ASSERT(k <= RATE_TABLE_SIZE);
> +       ASSERT(k <= RATE_TABLE_SIZE && k >= 4);


NACK, k is initialized to 0 in the for loop few lines above this
ASSERT.

Vasanth
