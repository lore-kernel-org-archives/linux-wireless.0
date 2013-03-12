Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:63967
	"EHLO HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754153Ab3CLDJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 23:09:32 -0400
Message-ID: <1363057766.778.8.camel@WLAN-SW-TEST-03> (sfid-20130312_040936_874478_C55302D7)
Subject: Re: [PATCH] mac80211: Enable sw scan with chan context
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 12 Mar 2013 08:39:26 +0530
In-Reply-To: <1363015558.5284.11.camel@jlt4.sipsolutions.net>
References: <513DE4BB.9010104@posedge.com>
	 <1363012784.5284.5.camel@jlt4.sipsolutions.net>
	 <513DF675.3000800@posedge.com>
	 <1363015558.5284.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-11 at 17:25 +0200, Johannes Berg wrote:
> On Mon, 2013-03-11 at 20:51 +0530, Mahesh Palivela wrote:
> 
> > I tested this patch. scan works. 
> 
> Works how? It never tells the driver to go to a different channel ...

sorry. I missed this. But my patch takes care of crash in mac80211 once
we remove 'use_chanctx' check in sw_scan function.

> 
> Besides, telling the driver to go to one channel via the hw_config call,
> and using chanctx for vif configuration seems like a really bad idea.
> 

Agree.

> > Anyways chan context is a WIP.
> 
> It pretty much works.

For AP mode yes it works. But for STA mode, we have work I guess.

> 
> > There is no driver which is using the chan ctx work yet.
> 
> There is, our mvm driver uses it.
> 

Thanks for the info. I will take a look.

> > I will continue adding code for chan ctx.
> 
> What are you trying to achieve anyway?
> 

VHT assoc. To enable VHT on both AP and STA. For VHT to work we need
chan_ctx. Isn't it?


> johannes
> 

