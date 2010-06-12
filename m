Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60723 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725Ab0FLR63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:58:29 -0400
Subject: Re: [PATCH v2] mac80211: Use a separate CCMP PN receive counter
 for management frames
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1276364839.7894.2.camel@jlt3.sipsolutions.net>
References: <20100611024625.GB3985@jm.kir.nu>
	 <20100611172733.GA21347@jm.kir.nu>  <1276364067.2625.12.camel@ct>
	 <1276364839.7894.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Sat, 12 Jun 2010 13:58:26 -0400
Message-Id: <1276365506.2625.31.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-12 at 19:47 +0200, Johannes Berg wrote:
> On Sat, 2010-06-12 at 13:34 -0400, Pavel Roskin wrote:
> > On Fri, 2010-06-11 at 10:27 -0700, Jouni Malinen wrote:
> > 
> > > -		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
> > > +		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
> > 
> > Perhaps we could have a define for NUM_RX_DATA_QUEUES + 1, e.g.
> > NUM_RX_ALL_QUEUES
> 
> I kinda disagree. Yes, this is tricky code, but adding a define wouldn't
> make it clearer. In fact, it isn't really related to queues to start
> with, and ALL_QUEUES would just strengthen that mostly wrong notion.

That's certainly not my intention to strengthen wrong notions.

> I guess it really should be renamed to TIDs with the last two being
> special for non-QoS (so no TID) traffic + mgmt traffic. But then
> sequence numbers are allocated from the same counter (so there we just
> have 17 possibilities) while PNs have 18 counters...

Then let's replace QUEUE with TID in all RX defines.  Two special TIDs
could be used for non-QoS traffic and management frames when
appropriate.

-- 
Regards,
Pavel Roskin
