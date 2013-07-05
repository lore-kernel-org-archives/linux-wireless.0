Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:54738 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3GEOkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 10:40:03 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr> <1373018378.8548.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1373018378.8548.6.camel@jlt4.sipsolutions.net>
Subject: RE: [PATCH V2] vlan priority handling in WMM
Date: Fri, 5 Jul 2013 16:39:58 +0200
Message-ID: <002b01ce798d$865cee70$9316cb50$@acksys.fr> (sfid-20130705_164006_955364_50B78A54)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >+	vlan_priority = (skb->vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
> >+	if (vlan_priority > 0)
>> +		return vlan_priority;

>Is this really correct? For once, checking vlan_priority for non-zero seems weird since that ought to be a valid value -- is there no other way to determine that the value is valid?
The vlan Tag contain three bit for priority. The value 0 indicate no priority (on this case the VLAN tag contain only VID). The vlan_tci field is set to zero if the frame do not contain the vlan tag. So if we have not a vlan tag or no priority in VLAN tag the priority value is always 0. 

>Also, this gives you a 2-bit value, while the return value should be a 3-bit value, maybe you need to shift this up by one to spread into the correct buckets?
Sorry but I don't understand. The vlan_tci field it is a __u16 value (defined in include/linux/skbuff.h), the VLAN_PRIO_MASK is set to 0xE000 and VLAN_PRIO_SHIFT is set to 13 (defined in  include/linux/if_vlan.h), the vlan_priority is an unsigned char. For me the vlan_priority contain a 3-bit value (0xE000 >>13 = 0x0003), why 2 ?

If you are agree with me, I'll resend a V3 patch with a correct subject.

Cedric

>johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

