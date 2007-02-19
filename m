Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33506 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932576AbXBSTkK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 14:40:10 -0500
Date: Mon, 19 Feb 2007 20:40:04 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] d80211: Add software sequence support
Message-ID: <20070219204004.6730a17a@griffin.suse.cz>
In-Reply-To: <1171663926.3575.42.camel@johannes.berg>
References: <200702141423.27823.IvDoorn@gmail.com>
	<20070216135827.7d262ae3@griffin.suse.cz>
	<1171660484.3575.34.camel@johannes.berg>
	<200702162307.16826.IvDoorn@gmail.com>
	<1171663926.3575.42.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2007 23:12:06 +0100, Johannes Berg wrote:
> On Fri, 2007-02-16 at 23:07 +0100, Ivo van Doorn wrote:
> > On Friday 16 February 2007 22:14, Johannes Berg wrote:
> > > Make the counter per-mac address?
> > 
> > Wouldn't that be the same as per-interface?
> 
> Don't WDS interfaces have the same MAC as the corresponding AP
> interface?

They do.

Per-MAC address counters would work but it's another overhead we need
to add (allocate a new reference-counted structure, put a pointer to it
into sdata, correctly deal with it when MAC address changes).

I think we can live with the counter in sdata. It's not perfect but it
should work for all useful cases. The only situation where it won't
work I have been able to imagine is the case I described (STA and WDS
with the same address) and this particular setup is currently being
denied by d80211 (and it's not allowed by 802.11, btw).

If we consider this as a problem later, we can always change to per-MAC
address counters or something as it's completely internal to the stack
and no driver changes would be required.

 Jiri

-- 
Jiri Benc
SUSE Labs
