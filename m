Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:52801 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751502AbXLDRpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:45:50 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1196775624.6060.52.camel@johannes.berg>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
	 <1196681514.7470.12.camel@localhost>
	 (sfid-20071203_113229_452420_E8E9CC87)  <1196775624.6060.52.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 18:45:47 +0100
Message-Id: <1196790347.7472.10.camel@localhost> (sfid-20071204_174553_730162_9BAC4453)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-04 at 14:40 +0100, Johannes Berg wrote:
> > I already thought so. But the original "simple" algorithm is totally
> > broken in most cases. Well, maybe except the cases perfect situation ->
> > no tx failures -> full rate and bad situation -> lots of tx failures ->
> > lowest rate. IMHO, we should just get rid of the old simple algorithm.
> 
> I tend to agree, but I guess we should rename it then and change the
> default. Ultimately, we'll need to come up with some nl80211 API for
> rate control algorithms that allows each algorithm to have different
> parameters, similar to what tc(1) does for qdiscs.
> 
> If anybody's interested, here's what I'd do:
> 
>  (a) add new attributes "rate control algorithm" and "rate control
>      algorithm attributes"
>  (b) allow setting them with NL80211_CMD_SET_INTERFACE
>  (c) the "rate control algorithm attributes" attribute is nested and
>      contains per-algorithm information, the indexes in it are specific
>      to each algorithm
> 
> This allows changing the algorithm as well as algorithm parameters.

Ok, sounds good. What is the overall strategy for deciding what goes
into nl80211, what into sysfs?

I'll go ahead and implement the nl80211 way.

Mattias

