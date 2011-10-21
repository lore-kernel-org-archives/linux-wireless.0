Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46110 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab1JUJww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 05:52:52 -0400
Subject: Re: [RFC 1/7] mac80211: mesh power mode indication in QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAG5dHkRULKh90W1MeR3zq+-gpeNUshrHZ0qbKXsW19PMG5enoQ@mail.gmail.com> (sfid-20111021_103637_877411_FF47FAB4)
References: <CAG5dHkRULKh90W1MeR3zq+-gpeNUshrHZ0qbKXsW19PMG5enoQ@mail.gmail.com>
	 (sfid-20111021_103637_877411_FF47FAB4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 11:52:47 +0200
Message-ID: <1319190767.3964.8.camel@jlt3.sipsolutions.net> (sfid-20111021_115320_010747_989C850C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-21 at 12:36 +0400, Ivan Bezyazychnyy wrote:

> +/* mesh power save level subfield mask */
> +#define IEEE80211_QOS_CTL_PS_LEVEL      0x0200

That looks like it could use a better name?

> --- a/include/linux/nl80211.h

Why is this in a mac80211 patch?

> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -765,6 +765,8 @@ struct mesh_config {
>  	u16 dot11MeshMaxPeerLinks;
>  	u8  dot11MeshMaxRetries;
>  	u8  dot11MeshTTL;
> +	/* non-peer mesh power save mode */
> +	u8 power_mode;

Ditto.

> +#ifdef CONFIG_MAC80211_MESH

No ifdefs please. There's no need for these.

>  	ieee80211_set_qos_hdr(sdata, skb);
> +#ifdef CONFIG_MAC80211_MESH
> +	ieee80211_set_mesh_ps_fields(sdata, hdr);
> +#endif /* CONFIG_MAC80211_MESH */

ditto.

>  	/* receiver and we are QoS enabled, use a QoS type frame */
> -	if (wme_sta && local->hw.queues >= 4) {
> +	if ((wme_sta && local->hw.queues >= 4) ||
> +	    (ieee80211_vif_is_mesh(&sdata->vif) &&
> +	     (ieee80211s_get_ps_mode(sdata, &hdr) !=
> +			NL80211_MESH_POWER_ACTIVE))) {
>  		fc |= cpu_to_le16(IEEE80211_STYPE_QOS_DATA);

This should not be necessary.

johannes

