Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:43468 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYG2Lm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:42:59 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4676088ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 04:42:57 -0700 (PDT)
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217330667.10489.19.camel@johannes.berg>
References: <1217323927.10489.9.camel@johannes.berg>
	 <1217330604.6379.12.camel@localhost>
	 (sfid-20080729_132329_995714_6D2C9701)  <1217330667.10489.19.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:42:53 +0200
Message-Id: <1217331773.6379.25.camel@localhost> (sfid-20080729_134302_208539_C5344B6E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-29 at 13:24 +0200, Johannes Berg wrote:
> On Tue, 2008-07-29 at 13:23 +0200, Luis Carlos Cobo wrote:
> > On Tue, 2008-07-29 at 11:32 +0200, Johannes Berg wrote:
> > > This patch fixes mac80211 to not use the skb->cb over the queue step
> > > from virtual interfaces to the master. The patch also, for now,
> > > disables aggregation because that would still require requeuing,
> > > will fix that in a separate patch. There are two other places (software
> > > requeue and powersaving stations) where requeue can happen, but that is
> > > not currently used by any drivers/not possible to use respectively.
> > 
> > On net/mac80211/rx.c:ieee80211_data_to_8023() cb is used for mesh frames
> > to save the original mesh header. Then if the frame has to be forwarded,
> > the frame is queued on the virtual interface and
> > net/mac80211/tx.c:ieee80211_subif_start_xmit() expects the mesh header
> > to remain in the cb if the frame is not originally from the local host.
> > It's a different step from the one you mention, but as I understand it
> > it may suffer the same problem right?
> 
> Indeed, that cannot be done. Good point, I'd thought that case was
> different.

One of the options I was thinking about when implemented that was to do
the forwarding in what was once equivalent to ieee80211_data_to_8023()
function. Then we do not have to do 802.11->802.3->802.11 series of
conversions, and we would send the frames to be forwarded directly to
the master device, speeding up things a bit.

I think the most elegant solution would be to add a rx handler to be run
before ieee80211_data_to_8023() dealing with forwarding and sending
frames directly to the master device. Would it make sense to deal there
too with the forwarding for APs and VLAN interfaces done in
ieee80211_deliver_skb?

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


