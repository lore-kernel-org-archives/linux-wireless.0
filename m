Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:26113 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752052AbYGJLmo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 07:42:44 -0400
From: Bruno Randolf <br1@einfach.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Date: Thu, 10 Jul 2008 13:42:36 +0200
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
In-Reply-To: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807101342.36920.br1@einfach.org> (sfid-20080710_134259_985805_897AA063)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 July 2008 13:28:42 Tomas Winkler wrote:
> Use directly put_unaligned_leX instead of put_unaligned(cpu_to_leX
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

hi!

what about using the generic function to add the radiotap header from 
mac80211? it should be flexible enough to handle all devices by now.

bruno

> ---
>  drivers/net/wireless/iwlwifi/iwl-rx.c |   37
> +++++++++++++++----------------- 1 files changed, 17 insertions(+), 20
> deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
> b/drivers/net/wireless/iwlwifi/iwl-rx.c index d062d4d..6a465d5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -29,6 +29,7 @@
>
>  #include <linux/etherdevice.h>
>  #include <net/mac80211.h>
> +#include <asm/unaligned.h>
>  #include "iwl-eeprom.h"
>  #include "iwl-dev.h"
>  #include "iwl-core.h"
> @@ -829,23 +830,22 @@ static void iwl_add_radiotap(struct iwl_priv *priv,
>  	iwl4965_rt->rt_hdr.it_pad = 0;
>
>  	/* total header + data */
> -	put_unaligned(cpu_to_le16(sizeof(*iwl4965_rt)),
> -		      &iwl4965_rt->rt_hdr.it_len);
> +	put_unaligned_le16(sizeof(*iwl4965_rt), &iwl4965_rt->rt_hdr.it_len);
>
>  	/* Indicate all the fields we add to the radiotap header */
> -	put_unaligned(cpu_to_le32((1 << IEEE80211_RADIOTAP_TSFT) |
> -				  (1 << IEEE80211_RADIOTAP_FLAGS) |
> -				  (1 << IEEE80211_RADIOTAP_RATE) |
> -				  (1 << IEEE80211_RADIOTAP_CHANNEL) |
> -				  (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
> -				  (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
> -				  (1 << IEEE80211_RADIOTAP_ANTENNA)),
> -		      &iwl4965_rt->rt_hdr.it_present);
> +	put_unaligned_le32((1 << IEEE80211_RADIOTAP_TSFT) |
> +			   (1 << IEEE80211_RADIOTAP_FLAGS) |
> +			   (1 << IEEE80211_RADIOTAP_RATE) |
> +			   (1 << IEEE80211_RADIOTAP_CHANNEL) |
> +			   (1 << IEEE80211_RADIOTAP_DBM_ANTSIGNAL) |
> +			   (1 << IEEE80211_RADIOTAP_DBM_ANTNOISE) |
> +			   (1 << IEEE80211_RADIOTAP_ANTENNA),
> +			   &(iwl4965_rt->rt_hdr.it_present));
>
>  	/* Zero the flags, we'll add to them as we go */
>  	iwl4965_rt->rt_flags = 0;
>
> -	put_unaligned(cpu_to_le64(tsf), &iwl4965_rt->rt_tsf);
> +	put_unaligned_le64(tsf, &iwl4965_rt->rt_tsf);
>
>  	iwl4965_rt->rt_dbmsignal = signal;
>  	iwl4965_rt->rt_dbmnoise = noise;
> @@ -853,17 +853,14 @@ static void iwl_add_radiotap(struct iwl_priv *priv,
>  	/* Convert the channel frequency and set the flags */
>  	put_unaligned(cpu_to_le16(stats->freq), &iwl4965_rt->rt_channelMHz);
>  	if (!(phy_flags_hw & RX_RES_PHY_FLAGS_BAND_24_MSK))
> -		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
> -					  IEEE80211_CHAN_5GHZ),
> -			      &iwl4965_rt->rt_chbitmask);
> +		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
> +				   &iwl4965_rt->rt_chbitmask);
>  	else if (phy_flags_hw & RX_RES_PHY_FLAGS_MOD_CCK_MSK)
> -		put_unaligned(cpu_to_le16(IEEE80211_CHAN_CCK |
> -					  IEEE80211_CHAN_2GHZ),
> -			      &iwl4965_rt->rt_chbitmask);
> +		put_unaligned_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
> +				   &iwl4965_rt->rt_chbitmask);
>  	else	/* 802.11g */
> -		put_unaligned(cpu_to_le16(IEEE80211_CHAN_OFDM |
> -					  IEEE80211_CHAN_2GHZ),
> -			      &iwl4965_rt->rt_chbitmask);
> +		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
> +				   &iwl4965_rt->rt_chbitmask);
>
>  	if (rate == -1)
>  		iwl4965_rt->rt_rate = 0;
