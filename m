Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:51874 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab0I1Ivi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 04:51:38 -0400
Message-ID: <4CA1AC8F.6000802@openwrt.org>
Date: Tue, 28 Sep 2010 10:51:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k:  Check for identical channels when changing
 channels.
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-28 2:07 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Don't do un-needed work.  Should be useful when scanning on
> only the working channel.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 a133878... 4d34ba5... M	drivers/net/wireless/ath/ath9k/main.c
>  drivers/net/wireless/ath/ath9k/main.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a133878..4d34ba5 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1602,6 +1602,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>  		struct ieee80211_channel *curchan = hw->conf.channel;
>  		int pos = curchan->hw_value;
>  
> +		/* If channels are the same, then don't actually do anything.
> +		 */
> +		if (sc->sc_ah->curchan == &sc->sc_ah->channels[pos])
> +			goto skip_chan_change;
> +
NACK. This ignores off-channel flag changes, which are important for
calibration.

- Felix
