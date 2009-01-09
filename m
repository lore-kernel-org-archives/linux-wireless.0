Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1058 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZAIPqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 10:46:19 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
Subject: Re: drivers returning wrong results from their _tx op
Date: Fri, 9 Jan 2009 10:44:22 -0500
Message-Id: <20090109153716.M19288@bobcopeland.com> (sfid-20090109_164624_658637_3BACB417)
In-Reply-To: <87hc4828xn.fsf@litku.valot.fi>
References: <1231193264.3697.41.camel@johannes> <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com> <1231246859.3503.0.camel@johannes> <20090109022347.GA5077@hash.localnet> <87hc4828xn.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 09 Jan 2009 10:13:56 +0200, Kalle Valo wrote
> > @@ -1170,6 +1170,7 @@ enum ieee80211_ampdu_mlme_action {
> >   *	configuration in the TX control data. This handler should,
> >   *	preferably, never fail and stop queues appropriately, more
> >   *	importantly, however, it must never fail for A-MPDU-queues.
> > + *	Returns NETDEV_TX_OK, or NETDEV_TX_BUSY if it fails.
> >   *	Must be implemented and atomic.
> 
> Based on discussion from netdev I have understood that NETDEV_TX_BUSY
> is not recommended, it's better to stop the queue already earlier,
> drop the frame or store the skb somewhere else temporarily. Johannes,
> have I understood this correctly?
> 
> It would be nice to have this documented here.

Read the sentence before the added line :-)

I was just interested in what all the callbacks hope to return.  
There seem to be some discrepancies, e.g. tx_last_beacon returns a 
bool disguised as an int (0=failure), while get_stats returns an 
error code but only checks for 0=OK.  Whether the documentation is
ultimately worthwhile or not is an open question.

Also, unless my grep-fu is weak, get_tx_stats didn't seem to be 
used at all.

-- 
Bob Copeland %% www.bobcopeland.com


