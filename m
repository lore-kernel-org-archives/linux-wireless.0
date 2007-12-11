Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47433 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752042AbXLKRXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 12:23:12 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197384754.4037.23.camel@johannes.berg>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost>
	 (sfid-20071210_205142_109612_504EEC93)  <1197384754.4037.23.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 18:23:08 +0100
Message-Id: <1197393788.7528.5.camel@localhost> (sfid-20071211_172315_849349_5E1959B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-11 at 15:52 +0100, Johannes Berg wrote:
> > > 2) that can be changed in userspace, but we couldn't figure out a scenario
> > > where it would make any sense. Johannes, any comments? Wouldn't it make
> > > sense to just forbid to change this in userspace?
> > 
> > I don't agree. For example, what if you have some broken 802.11b only
> > hardware that you desperately need to get going, but it freaks out on
> > 802.11g encoded frames. Now if your AP is hostapd on a Linux machine,
> > you'll want to change the mode. Hence, also the number of available
> > rates change.
> > 
> > Moreover, I think we can do better than just disallowing changes to the
> > rate set, don't you think?
> 
> All of this is going to change anyway, but disallowing mode/rateset
> changes while associated is definitely the right thing to do.

Just to sum up the issue for Johannes: Stefano's patch adds per-rate
information to the PID algorithm state. This is fine, however we need to
make sure the rate control algorithm gets reinitialized when the number
of rates changes (i.e. due to a mode change, what about about regulatory
domain changes?), as otherwise we might be indexing array entries we
don't have allocated. Now this spawned the more general discussion about
when the stack should allow changing modes etc.

So let's go back to the original issue: Johannes, can we assume rate
control always gets reinitialized when the number of rates or even the
hardware mode is changed?

Mattias

