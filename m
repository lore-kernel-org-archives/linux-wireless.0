Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab2K3L6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:00 -0500
Message-ID: <1354276702.10035.12.camel@jlt4.sipsolutions.net> (sfid-20121130_125906_194586_0BA6F5F6)
Subject: Re: [RFCv2 04/13] mac80211: mesh power mode indication in
 transmitted frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Fri, 30 Nov 2012 12:58:22 +0100
In-Reply-To: <1353701934-12752-5-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-5-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:

> For performance reasons, calls to the function setting the frame flags are
> placed in HWMP routing routines, as there the STA pointer is already availible.

typo: available

> +	/*
> +	 * Nulls are only sent to direct peers for PS and
> +	 * should already be addressed
> +	 */
> +	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
> +		return err;

return 0 would be easier ...

> + * NOTE: sta must be given when an individually-addressed QoS frame header
> + * is handed, for group-addressed and management frames it not used

typo: handled

> +	if (WARN_ON(is_unicast_ether_addr(hdr->addr1) &&
> +	       ieee80211_is_data_qos(hdr->frame_control) &&
> +	       !sta))
> +		return;

last time I'm commenting on whitespace/indentation issues


> +		ieee80211_set_mesh_ps_flags(sdata, NULL,
> +					    (struct ieee80211_hdr *) mgmt);

if you just do (void *)mgmt it'll fit on one line

> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -191,6 +191,15 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
>  
>  	/* qos header is 2 bytes */
>  	*p++ = ack_policy | tid;
> -	*p = ieee80211_vif_is_mesh(&sdata->vif) ?
> -		(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
> +	if (ieee80211_vif_is_mesh(&sdata->vif)) {
> +		/* preserve RSPI and Mesh PS Level bit */
> +		*p &= ((IEEE80211_QOS_CTL_RSPI |
> +			IEEE80211_QOS_CTL_MESH_PS_LEVEL) >> 8);
> +
> +		/* Nulls don't have a mesh header (frame body) */
> +		if (!ieee80211_is_qos_nullfunc(hdr->frame_control))
> +			*p |= (IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8);
> +	} else {
> +		*p = 0;
> +	}
>  }

This looks so much better now :)

johannes

