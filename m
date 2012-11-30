Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2K3MI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:08:57 -0500
Message-ID: <1354277360.10035.20.camel@jlt4.sipsolutions.net> (sfid-20121130_130900_270902_373EB7C8)
Subject: Re: [RFCv2 08/13] mac80211: add power save support structure to
 mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Nov 2012 13:09:20 +0100
In-Reply-To: <1353701934-12752-9-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-9-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:

> +++ b/net/mac80211/mesh.c
> @@ -657,10 +657,16 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	ifmsh->mesh_id_len = 0;
>  	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>  
> +	/* free all potentially still buffered group-addressed frames */
> +	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
> +	skb_queue_purge(&ifmsh->ps.bc_buf);
> +
>  	/* flush STAs and mpaths on this iface */
>  	sta_info_flush(sdata->local, sdata);
>  	mesh_path_flush_by_iface(sdata);

the queue purge would seem to be in the wrong spot

> +#ifdef CONFIG_MAC80211_MESH
> +	} else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {

maybe use vif_is_mesh anyway for consistency?

johannes

