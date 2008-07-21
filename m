Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:53933 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYGUMtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 08:49:42 -0400
Received: by nf-out-0910.google.com with SMTP id d3so456412nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 05:49:39 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211 deadlock detection triggering with rt61pci
Date: Mon, 21 Jul 2008 15:05:31 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <1216197369.3422.5.camel@johannes.berg> <200807191647.13517.IvDoorn@gmail.com> <1216489342.29432.5.camel@johannes.berg>
In-Reply-To: <1216489342.29432.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807211505.31571.IvDoorn@gmail.com> (sfid-20080721_144946_135716_7ED599AE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 July 2008, Johannes Berg wrote:
> On Sat, 2008-07-19 at 16:47 +0200, Ivo van Doorn wrote:
> > On Friday 18 July 2008, Ivo van Doorn wrote:
> 
> > It might be me, but looking at those traces, aren't they triggered by:
> > 
> > static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
> > {
> > ...
> > 		if (WARN_ON(queue >= ieee80211_num_regular_queues(&local->hw)))
> > 			goto drop;
> > ...
> > }
> > 
> > Which would suggest that when MAC80211_QOS is disabled, the skb_queue_mapping
> > still returns something higher then 1.
> 
> Oh, interesting, could be, I'll check it out.

I think I was wrong, just received a report which indeed marked the line:
	if (WARN_ON_ONCE(retries > 5))

recent mac80211 patches had moved the WARN_ON line more then I thought. ;)

In any case, I am still not sure why this bug is being triggered, but I am following a lead
with the rt2x00 errors that come directly before the WARN_ON is being triggered.

Ivo
