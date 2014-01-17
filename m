Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55232 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaAQGZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 01:25:00 -0500
Message-ID: <1389939896.8062.53.camel@porter.coelho.fi> (sfid-20140117_072511_569093_9B631C9A)
Subject: Re: [PATCH 1/2] b43: fix the wrong assignment of status.freq in
 b43_rx()
From: Luca Coelho <luca@coelho.fi>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Date: Fri, 17 Jan 2014 08:24:56 +0200
In-Reply-To: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-17 at 13:27 +0800, ZHAO Gang wrote:
> In following patch, replace b43 specific helper function with kernel
> api to reduce code duplication.
> 
> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
> ---
>  drivers/net/wireless/b43/xmit.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
> index 4ae63f4..50e5ddb 100644
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> @@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>  		 * channel number in b43. */
>  		if (chanstat & B43_RX_CHAN_5GHZ) {
>  			status.band = IEEE80211_BAND_5GHZ;
> -			status.freq = b43_freq_to_channel_5ghz(chanid);
> +			status.freq = b43_channel_to_freq_5ghz(chanid);
>  		} else {
>  			status.band = IEEE80211_BAND_2GHZ;
> -			status.freq = b43_freq_to_channel_2ghz(chanid);
> +			status.freq = b43_channel_to_freq_2ghz(chanid);
>  		}
>  		break;
>  	default:

Why do you need this patch if you're going to remove these calls in the
next patch anyway?

--
Luca.


