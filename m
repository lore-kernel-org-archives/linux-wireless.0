Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab1D1M4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 08:56:20 -0400
Subject: Re: [PATCH 4/4] mac80211: Add IEEE802.11n for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20110428T135917-421@post.gmane.org> (sfid-20110428_141415_832084_99A2E356)
References: <1302604964.2139.5.camel@alex-2>
	 <loom.20110412T130620-109@post.gmane.org>
	 <1302607159.3639.8.camel@jlt3.sipsolutions.net>
	 <loom.20110428T135917-421@post.gmane.org>
	 (sfid-20110428_141415_832084_99A2E356)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 14:56:08 +0200
Message-ID: <1303995368.3558.9.camel@jlt3.sipsolutions.net> (sfid-20110428_145623_723500_A874553B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 12:13 +0000, Alexander Simon wrote:
> > Also what if the IBSS is created with HT40+ and then joins, can it join
> > HT40-? Is the channel type "advisory" like the frequency? Can it join
> > HT20 IBSS as well?
> HT type can`t be advisory, as there may be stations without n.

Yeah, but it's possible to still communicate with them.

> Our card is set to HT40+/- if set by iw.
> Some other station is added into our internal station list by its HT beacons.
> E.g. if we have configured HT40- and there is someone with HT40+, minstrel_ht
> should use HT20 only. But i admit it seems cleaner to AND both caps.

Well. You need to consider more than just this. I have a feeling you're
only considering fixed channel use cases. But if we configure HT40+, and
then find a peer on a channel that may only use HT40-, then what?

johannes

