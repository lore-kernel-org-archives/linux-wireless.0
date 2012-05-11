Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab2EKS1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 14:27:14 -0400
Message-ID: <1336760829.8739.2.camel@jlt3.sipsolutions.net> (sfid-20120511_202717_486295_040D3FD2)
Subject: RE: [PATCH] mwifiex: remove set_channel cfg80211 hook
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 11 May 2012 20:27:09 +0200
In-Reply-To: <1336760775.8739.1.camel@jlt3.sipsolutions.net> (sfid-20120511_202625_610548_B0B58C36)
References: <1336757074.12801.18.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A57BA86@SC-VEXCH1.marvell.com>
	 <1336760775.8739.1.camel@jlt3.sipsolutions.net>
	 (sfid-20120511_202625_610548_B0B58C36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-11 at 20:26 +0200, Johannes Berg wrote:
> On Fri, 2012-05-11 at 11:21 -0700, Bing Zhao wrote:
> > Hi Johannes,
> > 
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > Since mwifiex only supports managed and IBSS
> > > modes, it doesn't need a set_channel call. The
> > > callback might be called, but it won't matter
> > > as nothing can use the channel.
> > 
> > We still need this set_channel hander for station IBSS mode.
> > User may want to use "iw mlan0 set channel 11" command to configure the channel before starting an IBSS network.
> 
> That doesn't make sense though, since you should give the channel to
> join the IBSS?
> 
> iw mlan0 ibss join <SSID> 2462
> 
> So maybe mwifiex_cfg80211_join_ibss() should use the channel it gets
> instead.

Never mind, it already does. And thereby overrides anything you did with
"iw mlan0 set channel 11".

johannes

