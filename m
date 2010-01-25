Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab0AYUu3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 15:50:29 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1264450301.23766.65.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <20100125183543.GB19528@jm.kir.nu>
	 <1264450301.23766.65.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 12:46:59 -0800
Message-Id: <1264452419.11524.26.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-01-25 at 12:11 -0800, Johannes Berg wrote:
> On Mon, 2010-01-25 at 10:35 -0800, Jouni Malinen wrote:
> > On Fri, Jan 22, 2010 at 08:03:01PM +0100, Johannes Berg wrote:
> > > The other solution I see is that we add a new step before or after the
> > > direct probe step, which would just be "wait for a beacon". This would
> > > ensure we have both probe and beacon information always ready. It would
> > > also ensure we have both probe and beacon info for our new userspace
> > > reporting of that.
> > 
> > I'm somewhat concerned about this as an unconditional change for our
> > association process due to the extra latency it adds. At minimum, I
> > would like to see a driver flag that can be used to indicate that such
> > behavior is really required and skip the extra wait if the driver does
> > not need the Beacon frame before association.
> > 
> > For most cases, I would also assume it should be possible to update the
> > PS settings after having received the first Beacon frame after
> > association, but if that is not enough, allowing the driver to request
> > mac80211 to wait with association sounds reasonable. I just don't want
> > to see additional 50 msec or so (or much worse if the AP is configured
> > with insanely long beacon interval) delay popping up with every
> > association by default..
> 
> Yeah that's a good point, I wondered about that too. I'll look into this
> in more detail and see if we can tell the driver about the DTIM period
> only with CONF_PS and enable that only after a beacon.
> 
I really like the idea of using CONF_PS which will not cause any delay
for association, plus the only STA need to know DTIM is the station in
power save mode.
  

