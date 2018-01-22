Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45500 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeAVMl2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:41:28 -0500
Message-ID: <1516624885.2508.12.camel@sipsolutions.net> (sfid-20180122_134131_873617_BD4C2858)
Subject: Re: [PATCH v2] mac80211: mesh: fix wrong mesh TTL offset calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: peter.oh@bowerswilkins.com, linux-wireless@vger.kernel.org
Date: Mon, 22 Jan 2018 13:41:25 +0100
In-Reply-To: <5ab069190f29078c2d621acf10ec9ad8aa0b684c.1516327710.git.peter.oh@bowerswilkins.com> (sfid-20180119_030932_332489_2A13DE94)
References: <5ab069190f29078c2d621acf10ec9ad8aa0b684c.1516327710.git.peter.oh@bowerswilkins.com>
         (sfid-20180119_030932_332489_2A13DE94)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> mesh TTL offset in Mesh Channel Switch Parameters element depends on
> not only Secondary Channel Offset element, but also affected by
> HT Control field and Wide Bandwidth Channel Switch element.
> Hence take those values place in.

This seems wrong, the Wide Bandwidth Channel Switch element should come
*after* the Mesh Channel Switch Parameters, see Figure 9-647—Channel
Switch Announcement frame Action field format in 802.11-2016.

> +	/* mgmt hdr 24 + csa action 15 without sec offset and wide bw */
> +	unsigned int basic_hdrlen = 39;

CSA action really is 24 + 1 + 1 + 5 for header, action type/subtype,
CSA Element. Where do the other 8 bytes come from? Are those the mesh
channel switch parameters?

> +	if (ieee80211_has_order(mgmt->frame_control))
> +		basic_hdrlen += 4;

That would seem somewhat reasonable, but if it's correct here then the
parsing previously done in mesh_rx_csa_frame() is utterly wrong, it
seems?

>  	/* offset_ttl is based on whether the secondary channel
>  	 * offset is available or not. Subtract 1 from the mesh TTL
>  	 * and disable the initiator flag before forwarding.
>  	 */
> -	offset_ttl = (len < 42) ? 7 : 10;
> +	offset_ttl = (len > basic_hdrlen) ? 10 : 7;
>  	*(pos + offset_ttl) -= 1;
>  	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;
>  
> @@ -1323,7 +1332,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
>  
>  	/* forward or re-broadcast the CSA frame */
>  	if (fwd_csa) {
> -		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
> +		if (mesh_fwd_csa_frame(sdata, mgmt, len, &elems) < 0)
>  			mcsa_dbg(sdata, "Failed to forward the CSA frame");

Here, for parsing &elems.

Either way, this really needs to be changed completely to just do

elems->mesh_chansw_params_ie->mesh_ttl--;
elems->mesh_chansw_params_ie->mesh_flags &= ~WLAN_EID_...;

If you then still have problems with the order field, then clearly that
needs to be taken into account *before* parsing the elements.

johannes
