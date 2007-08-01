Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54297 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759878AbXHALqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 07:46:23 -0400
Date: Wed, 1 Aug 2007 13:46:24 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
Subject: Re: Rate control over multiple devices
Message-ID: <20070801134624.481eb856@griffin.suse.cz>
In-Reply-To: <1185960764.14279.2.camel@johannes.berg>
References: <46AFB779.4040003@warmcat.com>
	<20070801004543.GD4719@tuxdriver.com>
	<1185960764.14279.2.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 01 Aug 2007 11:32:44 +0200, Johannes Berg wrote:
> On Tue, 2007-07-31 at 20:45 -0400, John W. Linville wrote:
> 
> > > Just seemed a little strange, maybe it is perfectly fine.
> > > 
> > > iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> > > PM: Adding info for No Bus:phy0
> > > PM: Adding info for No Bus:wmaster0
> > > wmaster0: Selected rate control algorithm 'iwl-3945-rs'
> > > 
> > > ...but then we add an rt73usb...
> > > 
> > > PM: Adding info for No Bus:phy1
> > > PM: Adding info for No Bus:wmaster1
> > > wmaster1: Selected rate control algorithm 'iwl-3945-rs' <----
> > > PM: Adding info for No Bus:wlan1
> > > usbcore: registered new interface driver rt73usb
> 
> Weird. But I guess that's because iwl-3945-rs is loaded and available so
> it's chosen first or something.

Exactly. This is one of things that should be solved in the patch
mentioned below.

> > This looks like the reverse of a dust-up we had a couple of months ago:
> > 
> > 	http://marc.info/?l=linux-wireless&m=117875332512693&w=2
> > 
> > It is possible to change the rate control algorithm now via debugfs.
> > In the past someone proposed letting drivers request their default
> > rate scaling algorithm, and I think that makes a lot of sense.
> > Any thoughts?

Still waiting for a patch from Intel.

> Apply the patch already? IIRC James made a pretty good one around that
> time to let the driver choose a default name as part of the hw structure
> it registers and it can be NULL for the default.
> 
> Of course, in a perfect world we'd have a 'default' rate control setting
> somewhere and apply that for drivers that have rate_control==NULL, while
> default would default to 'simple' to avoid the issue above.

I'd really like to see that in the patch. Seems to be a real issue.

 Jiri

-- 
Jiri Benc
SUSE Labs
