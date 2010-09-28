Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:34033 "EHLO qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0I1GoM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 02:44:12 -0400
Date: Tue, 28 Sep 2010 08:44:07 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: A few questions about modifications in carl9170
Message-ID: <20100928064407.GB31986@zenon.in.qult.net>
References: <20100927132957.GA2977@qubit.lri.fr>
 <20100927230137.GA5702@qubit.lri.fr>
 <20100927232357.GA5869@qubit.lri.fr>
 <201009280139.43745.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009280139.43745.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 01:39:43AM +0200, thus spake Christian Lamparter:
> > I now wonder how that could possibly be due to my modifications in the driver
> > and mac80211 (in a nutshell: retrieve the measurement per frame from the FW
> > and collect it into a stats structure in the sta descriptor, which is later
> > retrieved from userspace through netlink).  I'll try without these and report
> > back if that still happens.
> hm, you could also add a "custom" RADIO_TAP field. This way you could use
> wireshark to monitor the round trip times for each individual frame
> (this way you could also export the frames' duration + tx vectors too)

The thing is, I need to measure that during normal operation, when the card is
not in monitor mode.  At some point (in fact I was then experimenting with
mini-PCI cards running madwifi), I tried to run a monitor in parallel on
another virtual interface.  This turned out not to be working quite right,
because the monitor mode was having an impact on the normal operation of the
regular virtual interface.  Besides, sniffing each packet in userspace just to
retrieve my stats seems a bit overkill.  I don't really need to collect the
service time measurement for each frame independently, but simply to perform
some kind of accounting.

More precisely, I consider frames according to their length, up to 200 bytes,
from 200 to 400, from 400 to 600, ... and so on, up to the maximum frame size,
in 200 bytes intervals.  For each interval, I count the number of frames
transmitted, the cumulated number of bytes and the cumulated service time (all
these numbers are of course maintained *per destination address*).  The
userspace process then retrieves these stats for each interval, which
automatically resets all these values to zero, and computes an approximate
function of average throughput vs. frame length.  This average throughput
being the cumulated bytes over the cumulated service time, it is a maximum
attainable throughput and not the actual throughput.

Regards,

Ignacy

-- 
I drive way too fast to worry about cholesterol.
