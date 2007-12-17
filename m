Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757756AbXLQVMs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:12:48 -0500
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892362.4885.23.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012550.213561122@gmx.de> >
	 (sfid-20071217_012738_361990_F4488E8A)  <1197892362.4885.23.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:12:45 +0100
Message-Id: <1197925965.7505.24.camel@localhost> (sfid-20071217_211254_740225_DDAEDD10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 12:52 +0100, Johannes Berg wrote:
> > +config MAC80211_RCSIMPLE
> > +	bool "'simple' rate control algorithm (DEPRECATED)"
> > +	default n
> > +	depends on MAC80211
> > +	---help---
> 
> I'm pretty sure just "help" is preferred style these days.
> 
> And I already said that I'd rather see a single patch that replaces
> _SIMPLE with _PID.
> 
> I'd split up the patch series as follows:
>  1) API cleanup, including all rate control algorithms
>  2) PID replace SIMPLE

These two refer to stuff I'm happy with.

>  3..N) PID improvements

These are patches that IMHO need further testing. They extend the PID
controller concept in a non-standard way. Stefano says they help in some
situations.

> 
> Although since this is all new code 2..N should probably be collapsed
> into a single patch.

See the comment above for why they're separate patches at the time of
writing this.

Mattias

