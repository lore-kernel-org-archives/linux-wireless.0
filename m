Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36168 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbXHaW0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 18:26:11 -0400
Message-ID: <46D8957D.2010705@lwfinger.net>
Date: Fri, 31 Aug 2007 17:26:05 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: david@identd.dyndns.org
CC: bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: b43legacy woes
References: <BAY128-W312E506592CDC1EF65AF0C86CE0@phx.gbl>
In-Reply-To: <BAY128-W312E506592CDC1EF65AF0C86CE0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Ellingsworth wrote:
> I've been using the b43legacy driver since it was first posted to this list.
 > The driver has been relatively stable, but my wireless connection has not.
 > In an environment with approximately 26 wireless access points, I experience
 > frequent disconnects and reconnects with the rate stuck at 1Mb/s. The ranges
 > for signal and noise reported under these conditions were (-53db, -59db) and
 > (-93db, -89db) respectively, with an average difference between the two around 20db.
 > The Windows driver under these conditions quickly scaled to 54Mb/s and maintained a
 > connection. In an environment with a single AP, the b43legacy driver performs very
 > similar to the results above where the rate is limited at 1Mb/s and the Windows driver
 > scales significantly higher.
> 

The poor performance of the BCM4306/2 (your chip/card) is known. There has been a report that this 
is a regression since 2.6.20, or so, has not been confirmed. With a 2.6.21 kernel, I got an iperf 
transmit rate of 4 Mbs, but that quickly dropped to 0.3 Mbs without me changing anything - I just 
repeated the iperf command. I will be doing a bisection on bcm43xx to see if I can indeed find a 
regression.

As for the loss of connection in an environment with lots of AP's, I cannot duplicate that 
environment. Has anyone else seen this with b43, or with some other mac80211 driver. Perhaps we can 
localize the problem component. Is there a possibility of buffer overflow in the scan results with 
that many AP's?

Larry

