Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38497 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab3KYQOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:14:32 -0500
Message-ID: <1385396070.4443.43.camel@jlt4.sipsolutions.net> (sfid-20131125_171453_478767_4384C4D3)
Subject: Re: [PATCH 2/2] mac80211: Update opmode  during adding new station
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:14:30 +0100
In-Reply-To: <1385040495-13482-2-git-send-email-marek.kwaczynski@tieto.com> (sfid-20131121_142847_841092_54CEEC02)
References: <1385040495-13482-1-git-send-email-marek.kwaczynski@tieto.com>
	 <1385040495-13482-2-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20131121_142847_841092_54CEEC02)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 14:28 +0100, Marek Kwaczynski wrote:
> Update Operating mode is needed when User Space received Assoc
> Request contains Operating mode notification element.
> ---

Need signed-off-by, there are two spaces in the subject where it should
only be one.

> +++ b/net/mac80211/cfg.c
> @@ -1383,6 +1383,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
>  	struct ieee80211_sub_if_data *sdata;
>  	int err;
>  	int layer2_update;
> +	enum ieee80211_band band;
>  
>  	if (params->vlan) {
>  		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
> @@ -1425,6 +1426,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
>  	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER))
>  		rate_control_rate_init(sta);
>  
> +	if (params->vht_opmode_used) {
> +		band = ieee80211_get_sdata_band(sdata);

could declare band right here?

> +		ieee80211_vht_handle_opmode(sdata, sta, params->vht_opmode,
> +					    band, 0);
> +	}

Are you sure this should be at this place and not before moving the
station to ASSOC/initialising rate control?

johannes

