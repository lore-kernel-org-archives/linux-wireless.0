Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760569Ab0JGNRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 09:17:39 -0400
Subject: Re: [PATCH 2/2] mac80211: use netif_receive_skb in
 ieee80211_tx_status callpath
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286457360.20974.1.camel@jlt3.sipsolutions.net>
References: <1277405253-23735-1-git-send-email-linville@tuxdriver.com>
	 <1286457360.20974.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 15:17:37 +0200
Message-ID: <1286457457.20974.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 15:16 +0200, Johannes Berg wrote:
> On Thu, 2010-06-24 at 14:47 -0400, John W. Linville wrote:
> > This avoids the extra queueing from calling netif_rx.
> 
> John, can you please revert this? It's causing issues because we don't
> necessarily have BHs disabled here with all drivers (see below).
> Depending on the RCU implementation, it might disable BHs, but not all
> of them do or need to.
> 
> Alternatively, we can require drivers to call ieee80211_tx_status() with
> BHs disabled, but somebody would have to go through them...

For RX, we do this with ieee80211_rx_ni().

johannes

