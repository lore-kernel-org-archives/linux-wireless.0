Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1ARKob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 05:44:31 -0500
Subject: Re: [PATCH 4/5] mac80211: add primarily CAC support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lrodriguez@atheros.com, nbd@openwrt.org, dubowoj@neratec.com,
	zefir.kurtisi@neratec.com, simon.wunderlich@saxnet.de
In-Reply-To: <20110117161133.8150D2084@mx.techwires.net>
References: <201101171621.29863.bernhard.schmidt@saxnet.de>
	 <20110117161133.8150D2084@mx.techwires.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 11:45:15 +0100
Message-ID: <1295347515.3563.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-17 at 11:24 +0100, Bernhard Schmidt wrote:
> ---
>  net/mac80211/radar.c |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/radar.h |    4 +++
>  2 files changed, 69 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/radar.c b/net/mac80211/radar.c
> index e90b8bf..afb2ae1 100644
> --- a/net/mac80211/radar.c
> +++ b/net/mac80211/radar.c
> @@ -15,6 +15,66 @@
>  #include "driver-ops.h"
>  #include "radar.h"
>  
> +static void cac_timer(unsigned long data)
> +{
> +	struct ieee80211_local *local = (void *) data;
> +	struct ieee80211_radar *radar = &local->radar;
> +	struct ieee80211_channel *chan;
> +
> +	printk(KERN_INFO "CAC done\n");
> +
> +	chan = local->oper_channel;
> +	mutex_lock(&radar->mtx);

Clearly, you haven't even tested this code. I'm not sure why I'm even
reviewing it.

johannes

