Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46740 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753954AbXLLUG3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 15:06:29 -0500
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197479594.6558.122.camel@johannes.berg>
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte>
	 <1197239150.7543.13.camel@localhost>  <20071210090853.79ea4645@morte>
	 <1197319867.7493.4.camel@localhost>
	 (sfid-20071210_205142_109612_504EEC93)  <1197384754.4037.23.camel@johannes.berg>
	 <1197393788.7528.5.camel@localhost>
	 (sfid-20071211_172341_980688_FC3BC8E2)  <1197479594.6558.122.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 21:06:26 +0100
Message-Id: <1197489986.7491.11.camel@localhost> (sfid-20071212_200633_591979_363C4497)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-12-12 at 18:13 +0100, Johannes Berg wrote:
> > Just to sum up the issue for Johannes: Stefano's patch adds per-rate
> > information to the PID algorithm state. This is fine, however we need to
> > make sure the rate control algorithm gets reinitialized when the number
> > of rates changes (i.e. due to a mode change, what about about regulatory
> > domain changes?), as otherwise we might be indexing array entries we
> > don't have allocated. Now this spawned the more general discussion about
> > when the stack should allow changing modes etc.
> 
> Thanks.
> 
> > So let's go back to the original issue: Johannes, can we assume rate
> > control always gets reinitialized when the number of rates or even the
> > hardware mode is changed?
> 
> I have no idea. Doesn't it get initialised when the interface is brought
> up, and as such it would because those changes can only be done when
> it's down? If we want to be strict and allow changes while it's not
> associated but up then I think the answer is a clear no.

I'm pretty sure we currently don't support switching modulations via
WEXT. Any ideas on how this is going to be implemented with nl80211?
Should we be able to switch e.g. from 802.11g to 802.11b while the
interface is up?

Anyway, I think we don't need any special handling of this situation at
the moment. The stack needs more nl80211/cfg80211 work anyway, so let's
fix this once we've fixed the stack.

Mattias

