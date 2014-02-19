Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51000 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaBSIdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 03:33:41 -0500
Received: by mail-wg0-f49.google.com with SMTP id y10so56423wgg.28
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 00:33:40 -0800 (PST)
Message-ID: <53046C5E.5070208@gmail.com> (sfid-20140219_093353_417307_DF8BA12C)
Date: Wed, 19 Feb 2014 08:33:34 +0000
From: Dave Kilroy <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "Zhao, Gang" <gamerh2o@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] orinoco: replace function ieee80211_{dsss_chan_to_freq,
 freq_to_dsss_chan}
References: <cover.1392728354.git.gamerh2o@gmail.com> <be3f8f8f679b4665e3306869a35f830a94e727df.1392728354.git.gamerh2o@gmail.com>
In-Reply-To: <be3f8f8f679b4665e3306869a35f830a94e727df.1392728354.git.gamerh2o@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/02/2014 13:36, Zhao, Gang wrote:
> Replace ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan} with more
> generic ieee80211_{channel_to_frequency, frequency_to_channel}.
>
> File <net/cfg80211.h> has already been included. It's safe to use
> IEEE80211_BAND_2GHZ here.
>
> This change is a preparation for the removal of function
> ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}.
>
> Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
> ---
>   drivers/net/wireless/orinoco/cfg.c  | 4 ++--
>   drivers/net/wireless/orinoco/hw.c   | 2 +-
>   drivers/net/wireless/orinoco/scan.c | 5 +++--
>   drivers/net/wireless/orinoco/wext.c | 2 +-
>   4 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
> index d01edd2..c5ef3ab 100644
> --- a/drivers/net/wireless/orinoco/cfg.c
> +++ b/drivers/net/wireless/orinoco/cfg.c
> @@ -59,7 +59,7 @@ int orinoco_wiphy_register(struct wiphy *wiphy)
>   	for (i = 0; i < NUM_CHANNELS; i++) {
>   		if (priv->channel_mask & (1 << i)) {
>   			priv->channels[i].center_freq =
> -				ieee80211_dsss_chan_to_freq(i + 1);
> +		     ieee80211_channel_to_frequency(i + 1, IEEE80211_BAND_2GHZ);
>   			channels++;
>   		}
Can you tweak that indentation so that it doesn't unindent here. If it 
has to be on one line I'd prefer to exceed 80 chars than back indent.


Thanks,

Dave.
