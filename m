Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18244 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbXKMQDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 11:03:18 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 05/14] mac80211: adding 802.11n essential A-MPDUaddBAcapability
Date: Tue, 13 Nov 2007 17:58:38 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0403BC29@hasmsx411.ger.corp.intel.com> (sfid-20071113_160343_880662_388B9C8D)
In-Reply-To: <1194886091.5229.66.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	<flamingice@sourmilk.net>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Well, aggregation handling is the next step if these patches are
>> acceptable... :)

> :)

>> You are right, A-MPDU is really in the bottom of the data plane
>> architecture, so in most cases _creating_ it will be an HW feature,
>> while A-MSDU should be implemented in a much higher level place in
the
>> flow.
>> Two reasons why I placed A-MPDU handling in the mac80211:
>> - A-MPDU demands a "session" level management (add BACK, del BACK,
BAR),
>> which looks to me more mac80211 oriented
>> - A-MPDU extends the "Access Category" of 11e into "Traffic
Identifier"
>> (TID) to give finer granularity of frames priority. As mac80211
already
>> handles prioritization in wme.c, it looked like a good starting
point.

> Ok, thanks for the clarification. That means that when you implement
> a-mpdu aggregation handling you'll have some way to tell the hardware
to
> aggregate the next N frames?

Absolutely. Furthermore, as the mac80211 will be the A-MPDU _session_
manager, it will receive requests to start/stop aggregations, and will
decide, upon HT information it has from association, low-driver
capabilities and A-MPDU starting session "handshake", if aggregation is
really desired and needed. This decision will be passed to HW and
aggregation will start/stop.

>> >> +	/* TODO - add here aggregation support */
>> 
>> > I think that comment is misleading. We don't add aggregation
support
>> > here but rather when adding it we must change this code, but
anyway.
>> > Don't bother.
>> 
>> I can remove that, just a reference for development convenience. 

Yes, I will rephrase it for clarity.

> Nah, it's fine. Or maybe rephrase it a bit if you care.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
