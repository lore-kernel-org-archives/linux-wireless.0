Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54079 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab0JGPaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 11:30:06 -0400
Date: Thu, 7 Oct 2010 11:27:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: use netif_receive_skb in
 ieee80211_tx_status callpath
Message-ID: <20101007152708.GA20950@tuxdriver.com>
References: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
 <1286457360.20974.1.camel@jlt3.sipsolutions.net>
 <1286457457.20974.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286457457.20974.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 03:17:37PM +0200, Johannes Berg wrote:
> On Thu, 2010-10-07 at 15:16 +0200, Johannes Berg wrote:
> > On Thu, 2010-06-24 at 14:47 -0400, John W. Linville wrote:
> > > This avoids the extra queueing from calling netif_rx.
> > 
> > John, can you please revert this? It's causing issues because we don't
> > necessarily have BHs disabled here with all drivers (see below).
> > Depending on the RCU implementation, it might disable BHs, but not all
> > of them do or need to.
> > 
> > Alternatively, we can require drivers to call ieee80211_tx_status() with
> > BHs disabled, but somebody would have to go through them...
> 
> For RX, we do this with ieee80211_rx_ni().

Right.  I thought I had checked all these contexts, but ath9k in
particular is a bit complicated to trace all the potential callpaths
by hand.

I'll revert it, and the rtl8180 patch to use napi (which also does
tx status in that context).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
