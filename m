Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966638Ab0GSU1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 16:27:01 -0400
Subject: Re: [PATCH] mac80211: set carrier on for monitor interfaces on
 ieee80211_open
From: Johannes Berg <johannes@sipsolutions.net>
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C449CF2.7090800@davizone.at>
References: <4C449CF2.7090800@davizone.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 22:26:57 +0200
Message-ID: <1279571217.30478.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-19 at 20:44 +0200, David Gnedt wrote:
> If a station interface is reused as monitor interface it is possible that
> the carrier is still set to off. This breaks packet injection on that
> monitor interface.
> Force the carrier on in monitor interface initialisation like it is also done
> for other interface types (e.g. adhoc, mesh point, ap).
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>

This looks good,

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/iface.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 910729f..d07d223 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -249,6 +249,8 @@ static int ieee80211_open(struct net_device *dev)
>  			local->fif_other_bss++;
> 
>  		ieee80211_configure_filter(local);
> +
> +		netif_carrier_on(dev);
>  		break;
>  	default:
>  		res = drv_add_interface(local, &sdata->vif);


