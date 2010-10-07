Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab0JGSAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:00:02 -0400
Subject: Re: [PATCH 2/2] mac80211: use netif_receive_skb in
 ieee80211_tx_status callpath
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101007152708.GA20950@tuxdriver.com>
References: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
	 <1286457360.20974.1.camel@jlt3.sipsolutions.net>
	 <1286457457.20974.2.camel@jlt3.sipsolutions.net>
	 <20101007152708.GA20950@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 20:00:00 +0200
Message-ID: <1286474400.20974.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 11:27 -0400, John W. Linville wrote:

> > > Alternatively, we can require drivers to call ieee80211_tx_status() with
> > > BHs disabled, but somebody would have to go through them...
> > 
> > For RX, we do this with ieee80211_rx_ni().
> 
> Right.  I thought I had checked all these contexts, but ath9k in
> particular is a bit complicated to trace all the potential callpaths
> by hand.
> 
> I'll revert it, and the rtl8180 patch to use napi (which also does
> tx status in that context).

Or you could just add _ni and use it in ath9k all the time -- disabling
already disabled BHs will nest -- and leave it to somebody else to sort
out there later :)

johannes

