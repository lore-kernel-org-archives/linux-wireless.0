Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29237 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbYJTJBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:01:06 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:01:06 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18684.18492.94865.480736@gargle.gargle.HOWL> (sfid-20081020_110111_208436_ECC87926)
Date: Mon, 20 Oct 2008 14:28:36 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224491480.18024.32.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<1224491480.18024.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
 >  
 > > --- a/include/linux/skbuff.h
 > > +++ b/include/linux/skbuff.h
 > > @@ -244,6 +244,11 @@ typedef unsigned char *sk_buff_data_t;
 > >   *	@tc_verd: traffic control verdict
 > >   *	@ndisc_nodetype: router type (from link layer)
 > >   *	@do_not_encrypt: set to prevent encryption of this frame
 > > + *	@requeue: set to indicate that the wireless core should attempt
 > > + *		a software retry on this frame if we failed to
 > > + *		receive an ACK for it
 > 
 > 
 > 
 > > + *	@is_part_ampdu: set to indicate that the wireless core should should
 > > + *		treat this frame as part of an AMPDU
 > 
 > I thought we said we could keep the flag instead of moving to the skb
 > here?
 > 
 > The next step, imho, is to remove all the "if (hw->num_ampdu_queues)"
 > stuff and figure out what kind of services mac80211 should provide.

Well, currently ath9k maintains a buffer list for each tid.
When mac80211 sends down a frame, if the recipient has an aggr. session going,
it is appended to the tid's buffer list. Non-HT frames are sent out immediately.
On TX completion, we run through all the ACs, STAs and TIDs and send out pending
frames as aggregates.

IMO, this is heavy stuff for a driver.
mac80211 can probably help by maintaining the TX state for each TID, maintain the
buffer list, etc.  and provide appropriate mechanisms for drivers to obtain pending
frames as and when needed.

Sujith
