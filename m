Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab1IOMFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:05:08 -0400
Subject: Re: [RFC] wireless: Do not allow disabled channel in scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316088181-3869-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316088181-3869-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 14:05:06 +0200
Message-ID: <1316088306.3992.10.camel@jlt3.sipsolutions.net> (sfid-20110915_140512_732102_D3D94F3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 17:33 +0530, Rajkumar Manoharan wrote:
> cfg80211_conn_scan allows disabled channels at scan request.
> Hence probe request was seen at the disabled one. This patch
> ensures that disabled channel never be added into the scan
> request's channel list.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Good catch. We should probably refactor this later to go through a
single point...

johannes

> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/wireless/sme.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index dec0fa2..6e86d5a 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -110,17 +110,22 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
>  	else {
>  		int i = 0, j;
>  		enum ieee80211_band band;
> +		struct ieee80211_supported_band *bands;
> +		struct ieee80211_channel *channel;
>  
>  		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> -			if (!wdev->wiphy->bands[band])
> +			bands = wdev->wiphy->bands[band];
> +			if (!bands)
>  				continue;
> -			for (j = 0; j < wdev->wiphy->bands[band]->n_channels;
> -			     i++, j++)
> -				request->channels[i] =
> -					&wdev->wiphy->bands[band]->channels[j];
> -			request->rates[band] =
> -				(1 << wdev->wiphy->bands[band]->n_bitrates) - 1;
> +			for (j = 0; j < bands->n_channels; j++) {
> +				channel = &bands->channels[j];
> +				if (channel->flags & IEEE80211_CHAN_DISABLED)
> +					continue;
> +				request->channels[i++] = channel;
> +			}
> +			request->rates[band] = (1 << bands->n_bitrates) - 1;
>  		}
> +		n_channels = i;
>  	}
>  	request->n_channels = n_channels;
>  	request->ssids = (void *)&request->channels[n_channels];


