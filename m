Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3GHMPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 08:15:43 -0400
Message-ID: <1373285738.8312.13.camel@jlt4.sipsolutions.net> (sfid-20130708_141546_583597_3188DD95)
Subject: Re: [PATCH V2] vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jul 2013 14:15:38 +0200
In-Reply-To: <006c01ce7bc7$608c2a30$21a47e90$@acksys.fr>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
		 <1373018378.8548.6.camel@jlt4.sipsolutions.net>
		 <002b01ce798d$865cee70$9316cb50$@acksys.fr>
	 <1373273460.8312.3.camel@jlt4.sipsolutions.net>
	 <006c01ce7bc7$608c2a30$21a47e90$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-08 at 12:39 +0200, voncken wrote:
> > > The vlan Tag contain three bit for priority. The value 0 indicate
> no 
> > > priority (on this case the VLAN tag contain only VID). The
> vlan_tci 
> > > field is set to zero if the frame do not contain the vlan tag. So
> if 
> > > we have not a vlan tag or no priority in VLAN tag the priority
> value 
> > > is always 0.
> 
> > Yes but don't we know that the vlan_tci field is valid?
> 
> > I don't think you're correct in that 0 means "no priority present",
> it actually means "best effort" as far as I can tell. Ignoring the
> VLAN tag when the field is 0 would mean we could use a higher priority
> from the contents of the frame, which would not be desired?
> 
> I can add a test with the macro vlan_tx_tag_present() to verify if the
> vlan_tci field is valid. 
> I test the value 0 to skip the VLAN priority and use the dscp priority
> in this case. The priority 0 in VLAN tag is often use to turn off the
> QOS, because not bit is allowed for it.

What do you mean by "is often used"? I don't see how that would be the
case? Are you saying routers commonly ignore the VLAN priority value if
it's 0? That would seem odd?

> For me is it correct. Nevertheless, if you prefer, I can test only the
> vlan_tci validity and in this case always use the VLAN priority.

I don't know! Since you don't seem to really know either, we should ask
somebody who knows, I think. Maybe you should Cc netdev with this
question on the patch or so?

> Sorry I made a mistake  0xE000 >>13 = 0x0007 and not 0x0003, and 7 is
> a 3 bits value.

Ah yes, I made the same mistake, sorry.

johannes

