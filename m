Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37166 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966563AbeAONJv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 08:09:51 -0500
Message-ID: <1516021789.410.28.camel@sipsolutions.net> (sfid-20180115_140955_693433_714A5152)
Subject: Re: [RFC v2 3/5] mac80211: Send control port frames over nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 14:09:49 +0100
In-Reply-To: <20180110170938.2341-4-denkenz@gmail.com> (sfid-20180110_180958_612167_81C26F3A)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-4-denkenz@gmail.com>
         (sfid-20180110_180958_612167_81C26F3A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 11:09 -0600, Denis Kenzior wrote:

> Pre-authentication type frames (protocol: 0x88c7) are also forwarded
> over nl80211.

Interesting - maybe userspace should be able to configure a(n) (list
of) ethertype(s)?

> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> ---
>  net/mac80211/cfg.c         |  2 ++
>  net/mac80211/ieee80211_i.h |  1 +
>  net/mac80211/mlme.c        |  2 ++
>  net/mac80211/rx.c          | 31 ++++++++++++++++++++++++++++---
>  4 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 46028e12e216..f53bfb27295f 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -925,6 +925,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>  	 */
>  	sdata->control_port_protocol = params->crypto.control_port_ethertype;
>  	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
> +	sdata->control_port_over_nl80211 = false;

It's probably better to reset this at interface type switching, if it's
not done anyway (we zero a lot of memory there, but not sure precisely
what)

Otherwise we'll surely forget this in some place like mesh or OCB ...

Initially it must be false (0) anyway.

>  	sdata->control_port_protocol = req->crypto.control_port_ethertype;
>  	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
> +	sdata->control_port_over_nl80211 =
> +					req->crypto.control_port_over_nl80211;

Heh. One of the cases where the 80 cols line is just dumb :-)

>  	sdata->encrypt_headroom = ieee80211_cs_headroom(local, &req->crypto,
>  							sdata->vif.type);
>  
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index b3cff69bfd66..28b74ae1ee48 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2326,16 +2326,41 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
>  	}
>  #endif
>  
> -	if (skb) {
> +	if (!skb)
> +		goto try_xmit;

Seems this could be better without the goto, perhaps pulling the code
into a helper function?

> +	skb->protocol = eth_type_trans(skb, dev);
> +	memset(skb->cb, 0, sizeof(skb->cb));
> +
> +	if (unlikely((skb->protocol == sdata->control_port_protocol ||
> +		      skb->protocol == cpu_to_be16(0x88c7)) &&
> +		     sdata->control_port_over_nl80211)) {
> +		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
> +		bool noencrypt;
> +
> +		ehdr = eth_hdr(skb);
> +
> +		if (status->flag & RX_FLAG_DECRYPTED)
> +			noencrypt = false;
> +		else
> +			noencrypt = true;

	noencrypt = status->flags & RX_FLAG_DECRYPTED;
? It's a bool, after all, and you could even roll it into the
declaration.

johannes
