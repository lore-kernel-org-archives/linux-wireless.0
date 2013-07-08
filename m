Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp26.msg.oleane.net ([62.161.4.26]:60850 "EHLO
	smtp26.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3GHKjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 06:39:12 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>	 <1373018378.8548.6.camel@jlt4.sipsolutions.net>	 <002b01ce798d$865cee70$9316cb50$@acksys.fr> <1373273460.8312.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373273460.8312.3.camel@jlt4.sipsolutions.net>
Subject: RE: [PATCH V2] vlan priority handling in WMM
Date: Mon, 8 Jul 2013 12:39:08 +0200
Message-ID: <006c01ce7bc7$608c2a30$21a47e90$@acksys.fr> (sfid-20130708_123926_232557_1FD3A92C)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > The vlan Tag contain three bit for priority. The value 0 indicate no 
> > priority (on this case the VLAN tag contain only VID). The vlan_tci 
> > field is set to zero if the frame do not contain the vlan tag. So if 
> > we have not a vlan tag or no priority in VLAN tag the priority value 
> > is always 0.

> Yes but don't we know that the vlan_tci field is valid?

> I don't think you're correct in that 0 means "no priority present", it actually means "best effort" as far as I can tell. Ignoring the VLAN tag when the field is 0 would mean we could use a higher priority from the contents of the frame, which would not be desired?

I can add a test with the macro vlan_tx_tag_present() to verify if the vlan_tci field is valid. 
I test the value 0 to skip the VLAN priority and use the dscp priority in this case. The priority 0 in VLAN tag is often use to turn off the QOS, because not bit is allowed for it.
For me is it correct. Nevertheless, if you prefer, I can test only the vlan_tci validity and in this case always use the VLAN priority.

> > Sorry but I don't understand. The vlan_tci field it is a __u16 value 
> > (defined in include/linux/skbuff.h), the VLAN_PRIO_MASK is set to
> > 0xE000 and VLAN_PRIO_SHIFT is set to 13 (defined in 
> > include/linux/if_vlan.h), the vlan_priority is an unsigned char. For 
> > me the vlan_priority contain a 3-bit value (0xE000 >>13 = 0x0003), why
> > 2 ?

> Umm? No? Think again about what hweight(0x0003) is.

Sorry I made a mistake  0xE000 >>13 = 0x0007 and not 0x0003, and 7 is a 3 bits value.

Cedric



