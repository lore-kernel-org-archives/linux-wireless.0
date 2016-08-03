Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46694 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbcHCGu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 02:50:26 -0400
Message-ID: <1470207019.2638.7.camel@sipsolutions.net> (sfid-20160803_085052_343811_C3941FDE)
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org,
	Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 03 Aug 2016 08:50:19 +0200
In-Reply-To: <bb69b031-53ad-4649-bd1d-e95ca7a0cc70@gmail.com> (sfid-20160803_045115_384009_92A3AB68)
References: <20160713200755.26839-1-yanivma@ti.com>
 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
 <1470045822.3389.24.camel@sipsolutions.net>
 <75fef3ce-41a6-5845-e9be-d7ff052a07da@gmail.com>
 <1c2d3cfc-b7fd-c8fd-4f74-14dd3aa3076e@gmail.com>
 <1470122837.2665.5.camel@sipsolutions.net>
	 <bb69b031-53ad-4649-bd1d-e95ca7a0cc70@gmail.com>
	 (sfid-20160803_045115_384009_92A3AB68)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-08-03 at 11:51 +0900, Masashi Honma wrote:
> On 2016年08月02日 16:27, Johannes Berg wrote:
> > This explicitly configures *HT capability* though - that's even the
> > name of the parameter. If you enable HT40 in the capability, the
> > resulting BSS might still not actually *use* 40 MHz bandwidth, as
> > required by overlapping BSS detection.
> 
> OK, I see.
> 
> HT Capabilities element = Defined by hardware and software spec of
> the node. So it does not be modified after boot.

It shouldn't really need to be modified, but perhaps for
interoperability reasons one might want to, like for example we do in
assoc request (we restrict our own capabilities to what the AP
supports, because some APs are stupid.)

That said, I'm basically only objecting to calling this a bugfix. If
the behaviour of restricting the information is desired, I see no real
problem with that, I just don't see how it could possibly be a bugfix.

> HT Operation element = Defined by surrounding environment and 
> configuration of the node. So it could be modified after boot.
> 
> So, if the node supports HT40, HT Capabilities shows HT40 is capable.
> Now, I understand why you rejected this patch.
> 
> But now, when disable_ht=1, no HT Capabilities element in beacon even
> though the node supports HT.
> 
> My trailing patch could solve the issue.

Actually, *this* one I'm not sure is correct. If you want to disable HT
completely, then HT operation can't actually indicate that, and having
HT capabilities without HT operation would likely just confuse peers,
so I think in this case it's quite possibly necessary to remove HT
capabilities.

johannes
