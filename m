Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48635 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965603AbcBDEHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 23:07:07 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1aRBCA-0002BJ-IQ
	for linux-wireless@vger.kernel.org; Thu, 04 Feb 2016 05:07:03 +0100
Received: from abts-north-dynamic-242.62.161.122.airtelbroadband.in ([abts-north-dynamic-242.62.161.122.airtelbroadband.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 05:07:02 +0100
Received: from neelansh by abts-north-dynamic-242.62.161.122.airtelbroadband.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 05:07:02 +0100
To: linux-wireless@vger.kernel.org
From: Neelansh Mittal <neelansh@gmail.com>
Subject: Re: =?utf-8?b?QWRqdXN0aW5nX3RidHQ=?= in mesh capability
Date: Thu, 4 Feb 2016 04:06:56 +0000 (UTC)
Message-ID: <loom.20160204T044620-134@post.gmane.org> (sfid-20160204_050718_719316_3F22AFEA)
References: <loom.20160203T210737-307@post.gmane.org> <56B291A8.4000701@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I guess it's to prevent mesh peers from running TBTT adjustment?
That's correct.

But in this scenario(Synchronization) , the beacon would be delayed , 
and the peers running faster than me, would see this as drift and should 
delay their TSFs too.(which they would do if the bit is unset)

On the contrary ,If the adjusting_tbtt bit is set, the faster peers 
would ignore this beacon and hence the "drift due to change in TSF". 
Therefore, every time a node adjusts it's TSF, there would be a TBTT 
drift as seen by the faster mesh nodes.This drift would keep on getting 
added(every time a faster node 'delays' it's TSF).

Peter Oh <poh@...> writes:

> 
> 
> On 02/03/2016 12:18 PM, Neelansh Mittal wrote:
> > Currently, for a mesh node ,the mac80211
> > sync implementation sets the tbtt
> > adjustment bit , when it is adjusting it's
> > tsf as part of Neighbour offset
> > Synchronization(Function:mesh_sync_offset_
> > adjust_tbtt())
> > According to ieee80211s specification,
> > this bit should(only) be set when tbtt
> > adjustment procedure(as part of tbtt
> > selection/mbca) is ongoing.
> > So why does mac80211 set it as part of
> > Offset syncronization, ie , what is
> > advantage the when a mesh node announces
> > that "my tbtt will be delayed" to it's
> > peers?
> I guess it's to prevent mesh peers from running TBTT adjustment?
> Setting TBTT adjustment bit is good idea although the standard is 
> addressing TBTT adjustment bit during MBCA/TBTT selection procedure,
> since the key idea of setting the bit is to run TBTT adjustment by 
only 
> one mesh point at a time IMO.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
wireless"
> > in
> > the body of a message to majordomo@...
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




