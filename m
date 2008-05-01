Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45244
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752523AbYEAJUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 05:20:45 -0400
Date: Thu, 01 May 2008 02:20:41 -0700 (PDT)
Message-Id: <20080501.022041.213526595.davem@davemloft.net> (sfid-20080501_112032_862010_BD55471A)
To: johannes@sipsolutions.net
Cc: mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209632886.4008.8.camel@johannes.berg>
References: <1209607368.7173.20.camel@johannes.berg>
	<200805011058.40197.mb@bu3sch.de>
	<1209632886.4008.8.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 01 May 2008 11:08:06 +0200

> > Seems the skb->destructor messes it up.
> 
> Actually, it seems to be outside of mac80211, I put in a WARN_ON() and
> got this:

You're just seeing who freed it last here.

It could have had it's ->truesize put into an illegal state
elsewhere.
