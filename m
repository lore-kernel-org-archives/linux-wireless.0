Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVIVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 03:21:51 -0500
Message-ID: <1390378907.4334.2.camel@jlt4.sipsolutions.net> (sfid-20140122_092200_769927_71F38F5B)
Subject: Re: [PATCH] mac80211: mesh: fix mesh_id check
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Date: Wed, 22 Jan 2014 09:21:47 +0100
In-Reply-To: <CAHS2MGOVvv92L7c85Z0J70mt8kM9nG-P=2G-diL4UsC6MVTJgg@mail.gmail.com> (sfid-20140122_074536_150907_F7F99D56)
References: <1390334699.6199.67.camel@jlt4.sipsolutions.net>
	 <CAHS2MGOVvv92L7c85Z0J70mt8kM9nG-P=2G-diL4UsC6MVTJgg@mail.gmail.com>
	 (sfid-20140122_074536_150907_F7F99D56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:45 +0800, Chun-Yeow Yeoh wrote:

> > @@ -866,7 +866,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
> >         if (sdata->vif.csa_active)
> >                 return true;
> >
> > -       if (!ifmsh->mesh_id)
> > +       if (!ifmsh->mesh_id_len)
> 
> I don't see this in mac80211-next. Anyway, I think that this is not
> needed since the checking (sdata->wdev.mesh_id_len) is done at
> ieee80211_mesh_rx_queued_mgmt prior to
> ieee80211_mesh_process_chnswitch.

Indeed, this part seems to only be in 3.13 - probably got cleaned up in
somebody else's patches. I think though mac80211 should probably check
ifmsh->mesh_id_len and not sdata->wdev.mesh_id_len? Also, cfg80211 seems
to be missing this check in nl80211_channel_switch(), no?

johannes

