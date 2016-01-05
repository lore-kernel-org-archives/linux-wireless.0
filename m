Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36255 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbcAEJZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:25:29 -0500
Message-ID: <1451985926.12357.16.camel@sipsolutions.net> (sfid-20160105_102541_608022_F959444F)
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jan 2016 10:25:26 +0100
In-Reply-To: <1450959550-19655-2-git-send-email-arend@broadcom.com>
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
	 <1450959550-19655-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-24 at 13:19 +0100, Arend van Spriel wrote:
> Introducing a new extended feature that the driver can support which
> indicate the driver/firmware supports configuration of BSS selection
> criteria upon CONNECT command.

Can you edit the commit message to include some of the 0/2 email here?

>  /**
> + * struct cfg80211_bss_selection - Connection parameters for BSS selection.
> + *
> + * @present: indicates whether parameters are set.
> + * @pref_band: preferred band.
> + * @rssi_adjust: adjustment for RSSI level of the preferred band.
> + * @ignore_rssi: indicates whether BSS in preferred band is to be selected
> + *> 	> regardless its RSSI level.
> + */
> +struct cfg80211_bss_selection {
> +> 	> bool present;
> +> 	> enum nl80211_band pref_band;
> +> 	> u8 rssi_adjust;
> +> 	> bool ignore_rssi;
> +};

Hm. Isn't it possible to specify *some* parameters of these? Or at
least, in the future (if we extend this), it would be?

Seems that 'present' might want to be a bitmap or so? Or perhaps be
done by using invalid values by default (e.g. NUM_BANDS for no band
preference, etc.)?

> @@ -1910,6 +1926,7 @@ struct cfg80211_connect_params {
>  > 	> struct ieee80211_ht_cap ht_capa_mask;
>  > 	> struct ieee80211_vht_cap vht_capa;
>  > 	> struct ieee80211_vht_cap vht_capa_mask;
> +	struct cfg80211_bss_selection bss_select;

No documentation here?

> +/**
> + * enum nl80211_attr_bss_select - attributes for bss selection.
> + *
> + * @__NL80211_ATTR_BSS_SELECT_INVALID: reserved.
> + * @NL80211_ATTR_BSS_SELECT_BAND_PREF: Required attribute indicating the
> + *> 	> preferred band. The preference by itself still allows RSSI based
> + *> 	> selection of BSS and as such is only a tie breaker. Value according
> + *> 	> %enum nl80211_band.
> + * @NL80211_ATTR_BSS_SELECT_RSSI_ADJUST: When present the RSSI level for
> + *	the BSS in the preferred band is adjusted accordingly (u8).

"adjusted" is a bit vague - should specify more precisely what happens?

> + * @NL80211_ATTR_BSS_SELECT_IGNORE_RSSI: flag attribute which can be used to
> + *> 	> to have the BSS in the preferred band being selected regardless
> + *	of its RSSI level.

Can't that be done by a huge adjustment? Like, say, 255 dB adjustment?

> +> 	> err = nla_parse(attr, NL80211_ATTR_BSS_SELECT_MAX,
> +> 	> 	> 	> nla_data(nla), nla_len(nla), nl80211_bss_select_policy);
> +> 	> if (err)
> +> 	> 	> return err;
> +
> +> 	> bss_select->present = true;
> +> 	> if (!attr[NL80211_ATTR_BSS_SELECT_BAND_PREF])
> +> 	> 	> return -EINVAL;
> +
> +> 	> bss_select->pref_band =
> +> 	> 	> nla_get_u32(attr[NL80211_ATTR_BSS_SELECT_BAND_PREF]);
> +> 	> bss_select->rssi_adjust =
> +		nla_get_u8(attr[NL80211_ATTR_BSS_SELECT_RSSI_ADJUST]);

Need to check the attribute exists, no?


It could be worthwhile to have a "demo" implementation for the code in
cfg80211 that's used when you use CONNECT command with mac80211, maybe?

johannes
