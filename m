Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46981 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZDVXR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 19:17:58 -0400
Subject: Re: Measure RSSI in adhoc networks
From: Dan Williams <dcbw@redhat.com>
To: Kai Timmer <email@kait.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
References: <5b8543210904220608l484d0d2dv73b0d66cdc167ce@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 19:18:54 -0400
Message-Id: <1240442334.14995.12.camel@localhost.localdomain> (sfid-20090423_011801_918552_51A4450B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-04-22 at 15:08 +0200, Kai Timmer wrote:
> Hello,
> I need to get the rssi values in an adhoc network from every available
> node separately.
> I noticed that on some of my devices, in a adhoc network, there are
> all values set to 0. Some other devices are showing values. I am not
> sure how to interpret this values. If there are more than 2 nodes in
> the adhoc network, it has to be some kind of average value. Am I right
> with this? And if yes, is there any way to get the rssi value for
> every available node?

You can only get an RSSI if there are other nodes in the network, and
then you get the RSSI of *that* node, as received by your node.  You
can't measure your own RSSI, because RSSI = *Received* Signal Strength
Indicator, and you can't really receive your own traffic since you're
radiating tons of power on TX and that completely deafens the RX chain.

Not all drivers report RSSI in adhoc mode at this time.  But even if
they did, they could only report RSSI when they receive a beacon or
traffic from some other node in the adhoc network, and that's pretty
useless because it doesn't give you a general quality of the "network",
it gives you a specific quality of the radio path between two points in
the network.

Dan

> I am not sure if this is the right place to ask these questions, if it
> is not, please redirect me to a more fitting place.
> 
> Greets,

