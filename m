Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab2DRBlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:41:06 -0400
Message-ID: <1334713232.3725.17.camel@jlt3.sipsolutions.net> (sfid-20120418_034110_906953_97D33FD4)
Subject: Re: [PATCH v2 4/6] wireless: Add util method to get channel index
 from frequency.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Apr 2012 18:40:32 -0700
In-Reply-To: <1334684807-14026-5-git-send-email-greearb@candelatech.com> (sfid-20120417_194726_924640_2523B282)
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>
	 <1334684807-14026-5-git-send-email-greearb@candelatech.com>
	 (sfid-20120417_194726_924640_2523B282)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 27f9561... be6fb62... M	include/net/cfg80211.h
> :100644 100644 6cba001... 2fd0e97... M	net/wireless/util.c
>  include/net/cfg80211.h |    7 +++++++
>  net/wireless/util.c    |   24 ++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 27f9561..be6fb62 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2388,6 +2388,13 @@ ieee80211_get_channel(struct wiphy *wiphy, int freq)
>  }
>  
>  /**
> + * ieee80211_get_channel_idx - get channel index from wiphy for specified freq
> + * @wiphy: the struct wiphy to get the channel for
> + * @freq: the center frequency of the channel
> + */
> +extern int ieee80211_get_channel_idx(struct wiphy *wiphy, int freq);

I prefer you drop the extern, but ...


> +int ieee80211_get_channel_idx(struct wiphy *wiphy, int freq)
> +{
> +       enum ieee80211_band band;
> +       struct ieee80211_supported_band *sband;
> +       int i;
> +       int rv = 0;
> +
> +       for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> +               sband = wiphy->bands[band];
> +
> +               if (!sband)
> +                       continue;
> +
> +               for (i = 0; i < sband->n_channels; i++) {
> +                       if (sband->channels[i].center_freq == freq)
> +                               return rv;
> +                       rv++;
> +               }
> +       }
> +
> +       return NULL;
> +}


"return NULL"? Really?

Also, what use is the index? It's some kind of global channel index, but
that's almost completely useless. I think you need a very very very good
reason to have this function and you're not even stating a single one.

johannes

