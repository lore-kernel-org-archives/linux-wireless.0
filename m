Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3GHIvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 04:51:06 -0400
Message-ID: <1373273460.8312.3.camel@jlt4.sipsolutions.net> (sfid-20130708_105110_388598_089BC9F9)
Subject: Re: [PATCH V2] vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jul 2013 10:51:00 +0200
In-Reply-To: <002b01ce798d$865cee70$9316cb50$@acksys.fr>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
	 <1373018378.8548.6.camel@jlt4.sipsolutions.net>
	 <002b01ce798d$865cee70$9316cb50$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-05 at 16:39 +0200, voncken wrote:
> > >+	vlan_priority = (skb->vlan_tci & VLAN_PRIO_MASK) >>
> VLAN_PRIO_SHIFT;
> > >+	if (vlan_priority > 0)
> >> +		return vlan_priority;
> 
> > Is this really correct? For once, checking vlan_priority for
> non-zero seems
> > weird since that ought to be a valid value -- is there no other way
> to
> > determine that the value is valid?

> The vlan Tag contain three bit for priority. The value 0 indicate no
> priority (on this case the VLAN tag contain only VID). The vlan_tci
> field is set to zero if the frame do not contain the vlan tag. So if
> we have not a vlan tag or no priority in VLAN tag the priority value
> is always 0. 

Yes but don't we know that the vlan_tci field is valid?

I don't think you're correct in that 0 means "no priority present", it
actually means "best effort" as far as I can tell. Ignoring the VLAN tag
when the field is 0 would mean we could use a higher priority from the
contents of the frame, which would not be desired?

> >Also, this gives you a 2-bit value, while the return value should be
> a 3-bit value, maybe you need to shift this up by one to spread into
> the correct buckets?
> Sorry but I don't understand. The vlan_tci field it is a __u16 value
> (defined in include/linux/skbuff.h), the VLAN_PRIO_MASK is set to
> 0xE000 and VLAN_PRIO_SHIFT is set to 13 (defined in
> include/linux/if_vlan.h), the vlan_priority is an unsigned char. For
> me the vlan_priority contain a 3-bit value (0xE000 >>13 = 0x0003), why
> 2 ?

Umm? No? Think again about what hweight(0x0003) is.

johannes


