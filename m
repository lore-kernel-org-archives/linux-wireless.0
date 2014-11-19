Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40412 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbaKSSzM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 13:55:12 -0500
Message-ID: <1416423309.9374.25.camel@sipsolutions.net> (sfid-20141119_195517_032547_81F148D4)
Subject: Re: [PATCH 6/6] mac80211: add ieee80211_tx_status_noskb
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Nov 2014 19:55:09 +0100
In-Reply-To: <546CE5B3.6080005@openwrt.org>
References: <1416094080-49220-1-git-send-email-nbd@openwrt.org>
		 <1416094080-49220-6-git-send-email-nbd@openwrt.org>
	 <1416422321.9374.24.camel@sipsolutions.net> <546CE5B3.6080005@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 19:47 +0100, Felix Fietkau wrote:

> >> + * This function may not be called in IRQ context. Calls to this function
> >> + * for a single hardware must be synchronized against each other. Calls
> >> + * to this function, ieee80211_tx_status_ni() and ieee80211_tx_status_irqsafe()
> >> + * may not be mixed for a single hardware. Must not run concurrently with
> >> + * ieee80211_rx() or ieee80211_rx_ni().
> > 
> > None of that seems very likely. Did you just copy/paste it? :)
> Yes, I copy/pasted it. I wasn't sure if these requirements would be
> necessary for the no-skb status as well, just figured it'd be safe to
> leave them in.

I think if you move the eosp() that leaves you pretty much with only
things that are safe? 

johannes

