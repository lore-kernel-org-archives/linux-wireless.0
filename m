Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infineon.com ([217.10.60.22]:18340 "EHLO
	smtp1.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYHGNA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 09:00:59 -0400
From: <Friedrich.Beckmann@infineon.com>
To: <johannes@sipsolutions.net>
CC: <tomasw@gmail.com>, <linux-wireless@vger.kernel.org>, <j@w1.fi>
Date: Thu, 7 Aug 2008 15:00:56 +0200
Subject: RE: mac80211 aggregation (was: iwlwifi aggregation info)
Message-ID: <8469FC7DDCBE054D9653D8506E1FF0F001F1FE21A9@mucse406.eu.infineon.com> (sfid-20080807_150104_741222_D10EEB5D)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 <1217509511.10489.140.camel@johannes.berg>
	 <1ba2fa240807311114t3e1b4fb3oe6643fbe28f2c2ac@mail.gmail.com>
	 <1217528597.10489.150.camel@johannes.berg>
	 <1ba2fa240807311216u1a45cf22j219046ab357b0910@mail.gmail.com>
	 <1217592554.8621.23.camel@johannes.berg>
	 <1ba2fa240808010540g660cdaa9p1158a27061e3fcd@mail.gmail.com>
	 <1217595279.8621.38.camel@johannes.berg>
	 <1ba2fa240808061531i9b71df5l21475455d8115f3f@mail.gmail.com>
	 (sfid-20080807_003152_933183_1A6EF13B)
 <1218107628.23048.130.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1FE2164@mucse406.eu.infineon.com>
 <1218112297.23048.161.camel@johannes.berg>
In-Reply-To: <1218112297.23048.161.camel@johannes.berg>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> > The AC has first hand only to do with the access priority
> to the air,
> > but as a consequence the order of packets is only guaranteed within
> > each AC. So each AC needs an individual TID and as a result an
> > individual sequence number counter in order to do the duplicate
> > detection.
>
> This is a bit confusing to me, I don't think each AC has a
> TID, rather more than one TIDs map into a single AC.

That is true. You cannot map packets with the same TID to
several AC queues. The reason is retransmission. Each TID stream
has to be mapped to one AC. My understanding from the previous email
was different.

>
> > The atheros way is for sure possible but it comes with some
> > constraints in building the aggregates.
> >
> > a) You can not dynamically adapt the A-MPDU to the remaining TXOP.
> > b) You need to start a retransmission process of the
> aggregate packets in
> >    the AC queue immediatly, because otherwise you cannot release the
> >    buffers.
>
> I wouldn't be so sure about either of these, Atheros hardware
> has an elaborate scheme for suppressing frames and asking
> software to requeue them to the hardware at a later time. I
> suspect they can use it here to adapt the A-MPDU to the TXOP
> and suppress the remaining MPDUs if they need to, and tell
> the driver which of the aggregate packets needs to be retried
> later. I suppose that would need fairly shallow DMA queues,
> but that's doable.
>
> johannes
>

You are right, with software requeue of frames you get rid of the
retransmission problem. With the tailoring of the A-MPDU to the
TXOP I am more concerned of not having enough packets. In order to
have some efficient aggregation you need to collect a number of
packets but you have to make sure that if you have just one packet
that you release it after some waiting time.

Regards

Friedrich
