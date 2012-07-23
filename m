Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab2GWM7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 08:59:13 -0400
Message-ID: <1343048346.4584.11.camel@jlt3.sipsolutions.net> (sfid-20120723_145916_954759_15B835E9)
Subject: Re: [PATCH] mac80211: VHT (11ac) Association
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 23 Jul 2012 14:59:06 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E31@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E31@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-23 at 09:13 +0000, Mahesh Palivela wrote:

> @@ -359,6 +359,7 @@ enum ieee80211_sta_flags {
>  	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
>  	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
>  	IEEE80211_STA_DISABLE_40MHZ	= BIT(10),
> +	IEEE80211_STA_DISABLE_11AC	= BIT(11),

I'd prefer this being named DISABLE_VHT, even though we never renamed
the old DISABLE_11N (yet)


> +	BUILD_BUG_ON(sizeof(vht_cap) != sizeof(sband->vht_cap));
> +
> +	memcpy(&vht_cap, &sband->vht_cap, sizeof(vht_cap));
> +	//ieee80211_apply_vhtcap_overrides(sdata, &ht_cap);

Please just remove that line

>  static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
>  {
>  	struct ieee80211_local *local = sdata->local;
> @@ -503,6 +524,10 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
>  		ieee80211_add_ht_ie(sdata, skb, assoc_data->ap_ht_param,
>  				    sband, local->oper_channel, ifmgd->ap_smps);
>  
> +	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11AC))
> +		ieee80211_add_vht_ie(sdata, skb, sband);
> +
> +

Please remove the extra blank line. You also forgot to account for the
size of this field so the skb might be too short.

johannes

