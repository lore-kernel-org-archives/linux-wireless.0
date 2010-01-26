Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:51420 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0AZI1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 03:27:05 -0500
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: Network QoS support in applications
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 26 Jan 2010 10:27:00 +0200
Message-ID: <87k4v5nuej.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have been trying to understand how applications should use network
QoS. My interest have been mostly from wireless perspective,
especially how to utilise WMM and U-APSD properly, but naturally this
applicable to all networks.

I have done some research about this, but I haven't managed to get
anywhere. For example, from my point of view DiffServ is just one big
mess and I can't see how in practise it can help applications.

I wrote a small wiki page to sum up my findings:

http://wireless.kernel.org/en/developers/Documentation/qos

I would like to clear up all this by and I'm willing to write a
document for application developers about network QoS. But I need help
to understand what's the proper way to mark different QoS
prioritities.

In the wiki page I have tried to come up with different possible
solutions (copied below), but I'm sure there are even more ways.

Please comment. I would like to get some understanding about this.


----------------------------------------------------------------------
Solution 1: SO_PRIORITY with values 0-7

Easy, applications need to just use setsockopt() and be done with it.
It's unknown how widely supported values 0-7 are and the exact meaning
of them, but at least they make sense (0 default, 1 lowest priority
and 7 highest priority). The problem is that the priority is used only
in the first link, rest of the route is not able to benefit from the
classification.

Pros:

    * easy for applications
    * works with both IPv4 and IPv6 

Cons:

    * only visible in in the first L2 link, not visible to upper
      layers (IP)
    * no well defined meaning for the priority values 

Solution 2: SO_PRIORITY with values 256-263

mac80211 uses these values to map the packets to DSCP classes. Most
probably non other stack or driver (even non-wifi ones) use these
values. Otherwise similar as Solution 1.

Pros:

    * easy for applications
    * works with both IPv4 and IPv6 

Cons:

    * only visible in in the first L2 link, not visible to upper
      layers (IP)
    * no well defined meaning for the priority values
    * using values over 256 is not intuitive 

Solution 3: IPv4 DSCP field with values 0-7

Most, if not all, wifi drivers should use it. And, in theory, the
receiver should also benefit from the classification, unless ISPs
modify it of course. But the standardisation for IPv4 QoS bits is a
mess.

Pros:

    * visible in IP layer (but ISPs change the value often?) 

Cons:

    * applications need to handle IPv4 and IPv6 separately 
----------------------------------------------------------------------

-- 
Kalle Valo
