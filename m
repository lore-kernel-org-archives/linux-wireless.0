Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:32962 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932489AbXBSTIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 14:08:30 -0500
Date: Mon, 19 Feb 2007 20:08:27 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Support automatic channel/BSSID/SSID  configuration
Message-ID: <20070219200827.35172cbd@griffin.suse.cz>
In-Reply-To: <200702161547.09806.flamingice@sourmilk.net>
References: <200702110326.21623.flamingice@sourmilk.net>
	<20070216181555.71c440bd@griffin.suse.cz>
	<200702161547.09806.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2007 15:47:05 -0500, Michael Wu wrote:
> --- a/net/d80211/ieee80211_sta.c
> +++ b/net/d80211/ieee80211_sta.c
> [...]
> +static int ieee80211_sta_config_auth(struct net_device *dev,
> +				     struct ieee80211_if_sta *ifsta)
> +{
> [...]
> +
> +		if (top_rssi < bss->rssi)
> +			selected = bss;
> +
> +		top_rssi = bss->rssi;

if (top_rssi < bss->rssi) {
	select = bss;
	top_rssi = bss->rssi;
}
?

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
