Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161381Ab3BONhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:37:21 -0500
Message-ID: <1360935431.15040.14.camel@jlt4.sipsolutions.net> (sfid-20130215_143728_430614_7E453327)
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Fri, 15 Feb 2013 14:37:11 +0100
In-Reply-To: <511E38B2.40900@cozybit.com> (sfid-20130215_143133_867871_FDF7438A)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
	 	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>
	  <3fance.mi9hwg.2rw1te-qmf@mx.google.com>
	  (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>
	 <511E38B2.40900@cozybit.com> (sfid-20130215_143133_867871_FDF7438A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 14:31 +0100, Marco Porsch wrote:
> Hi,
> 
> On 02/15/2013 01:46 PM, Johannes Berg wrote:
> > On Fri, 2013-02-15 at 12:40 +0000, marco@cozybit.com wrote:
> >> Please check again. The comment is split in two and placed on the respective new positions.
> >
> > Yeah, I see, the API is just total shit. First passing the TSF and then
> > calculating it to override? Why not do the calculation outside the API
> > always?
> 
> The TBTT calculation does intentionally not use the mactime value.
> 
> Synchronization uses the time in local TSF units and the exact same time 
> point in peers TSF units at the time of sending/receiving (mactime field).
> The TBTT calculation uses the time of NOW, i.e. the current TSF after 
> possible delays in firmware/driver/rx-handler which may have outdated 
> the mactime field.

I'm talking about this API:

mesh_neighbour_update:
...
	tsf = drv_get_tsf()
...
	sync_ops->rx_bcn(..., tsf)


mesh_sync_offset_rx_bcn(..., t_r):
	...
	if (have_better_timestamp)
		t_r = get_better_timestamp()


You can hardly claim that's an intuitive API.

johannes

