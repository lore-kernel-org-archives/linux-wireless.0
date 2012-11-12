Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2KLPQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 10:16:44 -0500
Message-ID: <1352733436.9445.2.camel@jlt4.sipsolutions.net> (sfid-20121112_161648_183740_D946758F)
Subject: Re: 60 GHz interface types (was: [PATCH v5 1/2] wireless: Driver
 for 60GHz card wil6210)
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>, j@w1.fi
Date: Mon, 12 Nov 2012 16:17:16 +0100
In-Reply-To: <5760018.dRG2Gq6GXs@lx-vladimir>
References: <1351701417-3140-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352715356.9525.12.camel@jlt4.sipsolutions.net>
	 <1352715850.9525.17.camel@jlt4.sipsolutions.net>
	 <5760018.dRG2Gq6GXs@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 16:57 +0200, Vladimir Kondratiev wrote:

> > Let me elaborate on this. Lets say we have a hypothetical device that
> > supports
> > 
> >  2.4 GHz - client mode
> >  60 GHz  - AP and PCP mode
> > 
> > Yes, that would be pretty stupid, but let's say it exists, and even
> > worse than that, it only supports 2.4 GHz *or* 60 GHz, not both at the
> > same time (1).
> > 
> > Now how do you express its capabilities? [...]

> I wonder how do we do so if I substitute 5G instead of 60G, i.e. 2.4G client 
> and 5G AP, not same time. How do we handle per-band cababilities in this case?

We don't -- they share the same MAC and everything, so there's no real
difference between 2.4 and 5 GHz that would make a device have such
contrived capabilities with 2.4/5 GHz. (and if we did, we'd have a big
problem :) )

Somehow I have a feeling 60 GHz is different though.

> Something makes me think that in your example it should be 2 wiphy structs; 
> but need then I need to express inter-device restriction. I don't know right 
> answer to this.

Would there be inter-device restrictions though? In my contrived
example, there would be, but with a real device?

With my example, the only way to handle it seems to be separate
interface types for 60 GHz, but maybe you can convince me that the
example is stupid :)

johannes

