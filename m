Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16563 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab2DRPCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 11:02:09 -0400
Date: Wed, 18 Apr 2012 18:02:53 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
Message-ID: <20120418150252.GI19228@aemeltch-MOBL1> (sfid-20120418_170228_060334_24B6873C)
References: <20120411070514.GB17779@aemeltch-MOBL1>
 <1334714841.3725.37.camel@jlt3.sipsolutions.net>
 <20120418112017.GC19228@aemeltch-MOBL1>
 <1334749879.16897.221.camel@aeonflux>
 <20120418121014.GD19228@aemeltch-MOBL1>
 <1334751359.16897.225.camel@aeonflux>
 <20120418123326.GF19228@aemeltch-MOBL1>
 <1334754717.16897.228.camel@aeonflux>
 <20120418132224.GG19228@aemeltch-MOBL1>
 <1334759395.16897.231.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334759395.16897.231.camel@aeonflux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Wed, Apr 18, 2012 at 04:29:55PM +0200, Marcel Holtmann wrote:
> > > > > > If we create virtual interface then netdev is allocated and we can handle
> > > > > > it with common tools.
> > > > > 
> > > > > what common tools do you wanna use here. We actually do not wanna have
> > > > > them show up as netdev devices at all. AMP connections don't have IP
> > > > > addresses or anything else for that matter.
> > > > 
> > > > I might want to set up MAC address. Otherwise I might not need netdev. I
> > > > feel that I need it for interface separation.
> > > 
> > > what MAC address? And where do you get this MAC address from? AMP
> > > controllers do not have MAC addresses.
> > 
> > I assume I need some address to send/receive data over wireless.
> 
> from a Bluetooth point, we do not have to deal with the MAC address.
> When looking at the mac80211 part, I do not know. However even then,
> that address should come from the driver and not from userspace.

The MAC address coming from driver might be already used in default
wireless interface. I am not very familiar with wireless devices, maybe
they have pool of MAC addresses we might choose from ...

My point here: we create virtual interface and separate it from other
wireless interfaces => hence we do not need to worry (much) about
concurrency between wireless interfaces. Those interfaces need to have
separate MAC addresses assigned if I understand virtual interfaces concept
right.

Best regards 
Andrei Emeltchenko 
