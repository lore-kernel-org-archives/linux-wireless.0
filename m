Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3BON6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:58:33 -0500
Message-ID: <1360936708.15040.18.camel@jlt4.sipsolutions.net> (sfid-20130215_145838_277092_BB6338D7)
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 15 Feb 2013 14:58:28 +0100
In-Reply-To: <511E3CB7.4040207@cozybit.com> (sfid-20130215_144844_328347_5B0B2D91)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
	  	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>
	   <3fance.mi9hwg.2rw1te-qmf@mx.google.com>
	   (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>
	  <511E38B2.40900@cozybit.com>
	 (sfid-20130215_143133_867871_FDF7438A) <1360935431.15040.14.camel@jlt4.sipsolutions.net>
	 <511E3CB7.4040207@cozybit.com> (sfid-20130215_144844_328347_5B0B2D91)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 14:48 +0100, Marco Porsch wrote:

> > I'm talking about this API:
> >
> > mesh_neighbour_update:
> > ...
> > 	tsf = drv_get_tsf()
> > ...
> > 	sync_ops->rx_bcn(..., tsf)
> >
> >
> > mesh_sync_offset_rx_bcn(..., t_r):
> > 	...
> > 	if (have_better_timestamp)
> > 		t_r = get_better_timestamp()
> >
> >
> > You can hardly claim that's an intuitive API.
> 
> Hm, alright. Just saying that ieee80211_mps_sta_tbtt_update still uses 
> the unchanged TSF value. But hey :)

Well, that function doesn't exist in this patch...

> What would be more favourable then?

I guess you can tell I'm not in a good mood today. I think any use of
get_tsf() for operation is a complete waste of time, there's no way you
can get the timings correct. You could be preempted, and suddenly sleep
for a few tens or hundreds milliseconds, so none of this makes any
sense... To properly do it you have to do calculations in relative times
and let the device apply them.

johannes

