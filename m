Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-72-92-88-10.phlapa.fios.verizon.net ([72.92.88.10]:56437
	"EHLO smtp.roinet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbZLDQIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 11:08:15 -0500
Message-ID: <4B1933F5.2010408@roinet.com>
Date: Fri, 04 Dec 2009 11:08:21 -0500
From: David Acker <dacker@roinet.com>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com> <878wdi69u9.fsf@purkki.valot.fi>
In-Reply-To: <878wdi69u9.fsf@purkki.valot.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> David Acker <dacker@roinet.com> writes:
>> What do think of also supporting a method 4, VLAN priority field (0-7)?
> 
> Sorry, I haven't heard about this. I don't even know how applications
> should set this. Can you show an example, please?

Sure.  A system could be setup with multiple VLANs available on its 
outgoing port.  Imagine eth0.1, eth0.2 and eth0.7.  Each one is a 
different VLAN with a different priority mapping setup.  The application 
can use the high priority VLAN which should then be reflected in the 
over the air packets using a high priority WMM queue.  If the driver 
implements the appropriate VLAN functionality it should be able to 
detect VLAN tagged packets and pick the appropriate WMM hardware queue. 
  I think a driver can use vlan_get_tag to get the Tag Control 
Information (TCI) field.  The TCI field contains a 3-bit Priority Code 
Point (PCP) field for 8 different priorities.

I am not an expert on how the kernel handles vlans, but it appears that 
the priority field's value is set by the user space VLAN creation tools 
through an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls 
vlan_dev_set_egress_priority to map an skb priority to a vlan priority.
vlan_dev_hard_header then uses this information to populate the vlan 
priority field based on the skb priority field.

In this case it would seem that skb priority and the vlan priority are 
both set and there may be a non-trivial mapping between the two. 
pkt_sched.h defines some skb priorities but also leaves many undefined. 
  The skb->priority is also larger then the vlan priority.  If both are 
set, which will take precedence?
-ack
