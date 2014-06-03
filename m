Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60326 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917AbaFCUOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 16:14:10 -0400
Message-ID: <1401826431.4157.52.camel@jlt4.sipsolutions.net> (sfid-20140603_221431_761605_57DD6995)
Subject: Re: [RFC 4/4] mac80211: OCB mode interface configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de,
	Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Tue, 03 Jun 2014 22:13:51 +0200
In-Reply-To: <1401468984-24575-5-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140530_185640_927854_70A2DAA5)
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1401468984-24575-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140530_185640_927854_70A2DAA5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-30 at 18:56 +0200, Rostislav Lisovy wrote:
> +	static u8 bssid_wildcard[ETH_ALEN] = { 0xff, 0xff, 0xff,
> +					       0xff, 0xff, 0xff };

const

that doesn't actually exist anywhere already? Maybe not I guess.

> +int ieee80211_start_ocb(struct ieee80211_sub_if_data *sdata)
> +{
> +	u32 changed = BSS_CHANGED_BEACON_ENABLED;
> +
> +	sdata->vif.bss_conf.enable_beacon = false;
> +	ieee80211_bss_info_change_notify(sdata, changed);

Why would beacon_enabled be changing?

> +	/* MORE TO BE DONE ... */

>From a brief look it seems that you should at least be setting the QoS
parameters, but what, if anything, else is there?

Certainly there should also be some indication to the low-level driver
that it should now consider being part of the OCB network though.

> +	netif_carrier_on(sdata->dev);
> +	return 0;
> +}
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 7e0dd4b..bf4fd61 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1689,6 +1689,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  			ieee80211_bss_info_change_notify(sdata, changed);
>  			sdata_unlock(sdata);
>  			break;
> +		case NL80211_IFTYPE_OCB:
> +			changed |= BSS_CHANGED_IBSS |
> +				   BSS_CHANGED_BEACON_ENABLED;

CHANGED_IBSS?

I guess you need a new CHANGED_OCB flag and ocb_active bool value.

johannes

