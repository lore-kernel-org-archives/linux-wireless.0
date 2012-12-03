Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2LCLDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 06:03:53 -0500
Message-ID: <1354532654.9717.2.camel@jlt4.sipsolutions.net> (sfid-20121203_120356_608615_632125CB)
Subject: Re: [RFCv2 08/13] mac80211: add power save support structure to
 mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Date: Mon, 03 Dec 2012 12:04:14 +0100
In-Reply-To: <50B8E787.2090903@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	  <1353701934-12752-9-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1354277360.10035.20.camel@jlt4.sipsolutions.net>
	 <50B8E787.2090903@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 09:06 -0800, Marco Porsch wrote:
> Thanks again for all your comments!
> 
> On 11/30/2012 04:09 AM, Johannes Berg wrote:
> > On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> >
> >> +++ b/net/mac80211/mesh.c
> >> @@ -657,10 +657,16 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
> >>   	ifmsh->mesh_id_len = 0;
> >>   	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
> >>
> >> +	/* free all potentially still buffered group-addressed frames */
> >> +	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
> >> +	skb_queue_purge(&ifmsh->ps.bc_buf);
> >> +
> >>   	/* flush STAs and mpaths on this iface */
> >>   	sta_info_flush(sdata->local, sdata);
> >>   	mesh_path_flush_by_iface(sdata);
> >
> > the queue purge would seem to be in the wrong spot
> 
> Where would you recommend to put it then?
> My idea was that after the (DTIM) beacon is disabled these buffered 
> broadcasts are stuck either way, so they can be purged.

But if the stations aren't all deleted yet, new frames might be added.

johannes

