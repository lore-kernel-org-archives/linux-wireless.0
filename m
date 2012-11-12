Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11921 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab2KLO6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 09:58:10 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, <j@w1.fi>
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver for 60GHz card wil6210)
Date: Mon, 12 Nov 2012 16:57:50 +0200
Message-ID: <5760018.dRG2Gq6GXs@lx-vladimir> (sfid-20121112_155814_073399_716F887E)
In-Reply-To: <1352715850.9525.17.camel@jlt4.sipsolutions.net>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1352715356.9525.12.camel@jlt4.sipsolutions.net> <1352715850.9525.17.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 12, 2012 11:24:10 AM Johannes Berg wrote:
> On Mon, 2012-11-12 at 11:15 +0100, Johannes Berg wrote:
> > > I suppose we can have MAC stuff in the kernel as-is, and at least at the
> > > beginning try to handle multi-band entirely in the supplicant.
> > 
> > But it does raise the question of what happens if a single device
> > supports both 2.4 and 60 GHz, or maybe all three of 2.4, 5 and 60 GHz.
> > 
> > If that would be on a single wiphy, I think we might run into issues
> > with re-using the interface types?
> 
> Let me elaborate on this. Lets say we have a hypothetical device that
> supports
> 
>  2.4 GHz - client mode
>  60 GHz  - AP and PCP mode
> 
> Yes, that would be pretty stupid, but let's say it exists, and even
> worse than that, it only supports 2.4 GHz *or* 60 GHz, not both at the
> same time (1).
> 
> Now how do you express its capabilities? Obviously it has both 2.4 and
> 60 GHz channels, and the list of interface types it supports would be
> client, AP, PCP -- however there's no way to tell which it supports on
> which bands.
> 
> Yes, this is a contrived example, but are you sure it won't exist? The
> sticking point is the fact that this device only has a single MAC that
> handles both 2.4 and 60 GHz, as it is usually the case for 2.4 and 5
> GHz, but then the capabilities are the same, since things *are* the
> same. Evidently though, a 2.4 GHz client and 60 GHz client are
> different.
> 
> johannes
> 
> 
> (1) If it did support both at the same time, it would register two wiphy
> structs with cfg80211.

I wonder how do we do so if I substitute 5G instead of 60G, i.e. 2.4G client 
and 5G AP, not same time. How do we handle per-band cababilities in this case?

Something makes me think that in your example it should be 2 wiphy structs; 
but need then I need to express inter-device restriction. I don't know right 
answer to this.

