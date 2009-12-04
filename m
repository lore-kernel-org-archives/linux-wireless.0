Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZLDTPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 14:15:50 -0500
Subject: Re: WMM classification guideline for applications?
From: Dan Williams <dcbw@redhat.com>
To: Greg Oliver <oliver.greg@gmail.com>
Cc: David Acker <dacker@roinet.com>, Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
In-Reply-To: <51058d550912040856u5d413a06n40412f8f56eb4b9@mail.gmail.com>
References: <87d42u6dnd.fsf@purkki.valot.fi> <4B19276F.5080604@roinet.com>
	 <878wdi69u9.fsf@purkki.valot.fi> <4B1933F5.2010408@roinet.com>
	 <51058d550912040856u5d413a06n40412f8f56eb4b9@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 Dec 2009 11:15:35 -0800
Message-Id: <1259954135.27022.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-12-04 at 10:56 -0600, Greg Oliver wrote:
> On Fri, Dec 4, 2009 at 10:08 AM, David Acker <dacker@roinet.com> wrote:
> > Kalle Valo wrote:
> >>
> >> David Acker <dacker@roinet.com> writes:
> >>>
> >>> What do think of also supporting a method 4, VLAN priority field (0-7)?
> >>
> >> Sorry, I haven't heard about this. I don't even know how applications
> >> should set this. Can you show an example, please?
> >
> > Sure.  A system could be setup with multiple VLANs available on its outgoing
> > port.  Imagine eth0.1, eth0.2 and eth0.7.  Each one is a different VLAN with
> > a different priority mapping setup.  The application can use the high
> > priority VLAN which should then be reflected in the over the air packets
> > using a high priority WMM queue.  If the driver implements the appropriate
> > VLAN functionality it should be able to detect VLAN tagged packets and pick
> > the appropriate WMM hardware queue.  I think a driver can use vlan_get_tag
> > to get the Tag Control Information (TCI) field.  The TCI field contains a
> > 3-bit Priority Code Point (PCP) field for 8 different priorities.
> >
> > I am not an expert on how the kernel handles vlans, but it appears that the
> > priority field's value is set by the user space VLAN creation tools through
> > an ioctl with SET_VLAN_EGRESS_PRIORITY_CMD which calls
> > vlan_dev_set_egress_priority to map an skb priority to a vlan priority.
> > vlan_dev_hard_header then uses this information to populate the vlan
> > priority field based on the skb priority field.
> >
> > In this case it would seem that skb priority and the vlan priority are both
> > set and there may be a non-trivial mapping between the two. pkt_sched.h
> > defines some skb priorities but also leaves many undefined.  The
> > skb->priority is also larger then the vlan priority.  If both are set, which
> > will take precedence?
> > -ack
> 
> I do nto mean to be negative, but how can vlan based priority mapping
> be anything but "going in reverse" by today's QoS standards?  The
> whole point of packet marking is to alleviate the "this port is better
> than that port", so traffic from any port can be made equal to that of
> another..  Port (vlan/subnet/interface, etc) agnostic...  This would
> seem like a regression to me...  All of the major router/switch
> vendors provide mappings between these techniques already for this
> reason.  Hopefully, they will not be needed much longer.

Also, I think that unless it's a simple as a setsockopt() or some
one-call method like that, app writers aren't really going to use it.
For something as conceptually simple as QoS (even if the implementation
is complex), as an app writer I'd want to say "this packet is priority
3" and not "this packet is priority 4, so I need to find the
corresponding VLAN, and if that's not set up for me already then fail".

Dan

