Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab3CPM44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:56:56 -0400
Message-ID: <1363361148.8656.9.camel@jlt4.sipsolutions.net> (sfid-20130316_135700_207716_664E5A65)
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1363057766.778.8.camel@WLAN-SW-TEST-03>
References: <513DE4BB.9010104@posedge.com>
	 <1363012784.5284.5.camel@jlt4.sipsolutions.net>
	 <513DF675.3000800@posedge.com>
	 <1363015558.5284.11.camel@jlt4.sipsolutions.net>
	 <1363057766.778.8.camel@WLAN-SW-TEST-03>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:25:48 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-12 at 08:39 +0530, Mahesh Palivela wrote:
> On Mon, 2013-03-11 at 17:25 +0200, Johannes Berg wrote:
> > On Mon, 2013-03-11 at 20:51 +0530, Mahesh Palivela wrote:
> > 
> > > I tested this patch. scan works. 
> > 
> > Works how? It never tells the driver to go to a different channel ...
> 
> sorry. I missed this. But my patch takes care of crash in mac80211 once
> we remove 'use_chanctx' check in sw_scan function.

Yes, but it doesn't make it *do* anything, so the patch is completely
pointless. I don't see how chanctx and SW scan/roc can ever possibly
work together.

> > > Anyways chan context is a WIP.
> > 
> > It pretty much works.
> 
> For AP mode yes it works. But for STA mode, we have work I guess.

You may have, but in mac80211 it should work just as designed.

> VHT assoc. To enable VHT on both AP and STA. For VHT to work we need
> chan_ctx. Isn't it?

Right now, yes, you do.

However, I would argue that if you really want only VHT support, you
should remove the channel/channel_type fields from struct ieee80211_conf
and instead add a cfg80211_chan_def. This means a lot of changes in all
the drivers, but I'd hate to see the data all duplicated, and the
changes are trivial anyway.

johannes

