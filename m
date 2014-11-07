Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:58051 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751299AbaKGMh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 07:37:58 -0500
Message-ID: <1415363870.12617.0.camel@coelho.fi> (sfid-20141107_133802_481495_256D658F)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 07 Nov 2014 14:37:50 +0200
In-Reply-To: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor
 namespace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 23:29 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Radiotap vendor namespace data might still be useful, but we
> reverted it because it used too much space in the RX status.
> Put it back, but address the space problem by using a single
> but only and putting everything else into the skb->data.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |  43 +++++++++++++++
>  include/net/mac80211.h                |  33 +++++++++++
>  net/mac80211/rx.c                     | 100 ++++++++++++++++++++++++++++------
>  3 files changed, 158 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index 209db62ee627..89e14fa6c884 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -984,6 +984,46 @@ static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
>  	data->receive = true;
>  }
>  
> +static void mac80211_hwsim_add_vendor_rtap(struct sk_buff *skb)
> +{
> +#if 0
> +	struct ieee80211_vendor_radiotap *rtap;
> +
> +	rtap = (void *)skb_push(skb, sizeof(*rtap) + 8 + 4);
> +	/*
> +	 * Don't enable this code by default as the OUI 00:00:00
> +	 * is registered to Xerox so we shouldn't use it here, it
> +	 * might find its way into pcap files.
> +	 * Note that this code requires the headroom in the SKB
> +	 * that was allocated earlier.
> +	 */
> +	rtap->oui[0] = 0x00;
> +	rtap->oui[1] = 0x00;
> +	rtap->oui[2] = 0x00;
> +	rtap->subns = 127;
> +
> +	/*
> +	 * Radiotap vendor namespaces can (and should) also be
> +	 * split into fields by using the standard radiotap
> +	 * presence bitmap mechanism. Use just BIT(0) here for
> +	 * the presence bitmap.
> +	 */
> +	rtap->present = BIT(0);
> +	/* We have 8 bytes of (dummy) data */
> +	rtap->len = 8;
> +	/* For testing, also require it to be aligned */
> +	rtap->align = 8;
> +	/* And also test that padding works, 4 bytes */
> +	rtap->pad = 4;
> +	/* push the data */
> +	memcpy(rtap->data, "ABCDEFGH", 8);
> +	/* make sure to clear padding, mac80211 doesn't */
> +	memset(rtap->data + 8, 0, 4);
> +
> +	IEEE80211_SKB_RXCB(skb)->flag |= RX_FLAG_RADIOTAP_VENDOR_DATA;
> +#endif

Is this #if 0'ed section here on purpose? If yes, maybe explain it in
the commit message?

--
Luca.

