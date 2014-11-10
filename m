Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59446 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752204AbaKJJ1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 04:27:18 -0500
Message-ID: <1415611630.12617.6.camel@coelho.fi> (sfid-20141110_102722_607814_CC26C231)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Mon, 10 Nov 2014 11:27:10 +0200
In-Reply-To: <1415610648-5072-1-git-send-email-johannes@sipsolutions.net>
References: <1415610648-5072-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2] mac80211: add back support for radiotap vendor
 namespace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-10 at 10:10 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Radiotap vendor namespace data might still be useful, but we
> reverted it because it used too much space in the RX status.
> Put it back, but address the space problem by using a single
> bit only and putting everything else into the skb->data.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |  50 +++++++++++++++++
>  include/net/mac80211.h                |  37 +++++++++++++
>  net/mac80211/rx.c                     | 100 ++++++++++++++++++++++++++++------
>  3 files changed, 169 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 209db62ee627..58f11bb0896f 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -984,6 +984,53 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
>  	data->receive = true;
>  }
>  
> +static void mac80211_hwsim_add_vendor_rtap(struct sk_buff *skb)
> +{
> +	/*
> +	 * To enable this code, #define the HWSIM_RADIOTAP_OUI,
> +	 * e.g. like this:
> +	 * #define HWSIM_RADIOTAP_OUI "\x02\x00\x00"
> +	 * (but you should use a valid OUI, not that)
> +	 *
> +	 * If anyone wants to 'donate' a radiotap OUI/subns code
> +	 * please send a patch removing this #ifdef and changing
> +	 * the values accordingly.
> +	 */
> +#ifdef HWSIM_RADIOTAP_OUI

Ah... Thanks! This is now visible even to my aging eyes. :D

--
Luca.

