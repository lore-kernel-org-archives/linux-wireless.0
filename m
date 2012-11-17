Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2KQJkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:40:13 -0500
Message-ID: <1353145246.9543.39.camel@jlt4.sipsolutions.net> (sfid-20121117_104023_156531_79DAEF56)
Subject: Re: [RFC 14/14] mac80211: mesh PS individually-addressed frame
 release
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org
Date: Sat, 17 Nov 2012 10:40:46 +0100
In-Reply-To: <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-15-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:48 -0800, Marco Porsch wrote:

> +static inline bool test_and_set_psp_flag(struct sta_info *sta,
> +					 enum ieee80211_sta_info_flags flag)
> +{
> +	if (!test_and_set_sta_flag(sta, flag)) {
> +		atomic_inc(&sta->sdata->u.mesh.num_psp);

This is ... strange? Can a single station really own *two* num_psp
refcounts?

> +	nullfunc = (struct ieee80211_hdr *) skb->data;
> +	if (!eosp)
> +		nullfunc->frame_control |=
> +				cpu_to_le16(IEEE80211_FCTL_MOREDATA);

This seems wrong -- EOSP and moredata are orthogonal (with the
restriction that "!EOSP => moredata") -- but if you just have that in
the code the moredata bit won't always be set correctly.

> +	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
> +	drv_allow_buffered_frames(sdata->local, sta, BIT(7), 1,
> +				  IEEE80211_FRAME_RELEASE_UAPSD, !eosp);

ditto, passing !eosp definitely seems wrong

> +/**
> + * ieee80211_qos_null_append - append QoS Null as PSP trigger (if necessary)

append? where? why not static?

> +		ieee80211_sta_ps_deliver_response(sta, 1, 0,
> +				IEEE80211_FRAME_RELEASE_UAPSD);

uAPSD?

The standard *explicitly* states that ASPD is *not* supported in mesh.

Ok I don't really get this, need more time I guess .. also it seems
really hacked together.

johannes

