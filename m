Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:58863 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbXBTCFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 21:05:35 -0500
Date: Mon, 19 Feb 2007 17:58:52 -0800
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: Capture of unsuccessful ARP exchange
Message-ID: <20070220015851.GE5279@jm.kir.nu>
References: <1171935085.8133.42.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171935085.8133.42.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 19, 2007 at 08:31:25PM -0500, Pavel Roskin wrote:

> STA broadcasts an ARP request at 36Mbps.  QoS field requests normal ACK.

That's not broadcast transmission in IEEE 802.11 (or well, the frame is
to broadcast address eventually, but the ToDS frame from non-AP STA is a
unicast transmission to the AP(BSSID).

> STA receives ACK at 24Mbps.

As expected for a unicast transmission.

> STA broadcasts another ARP request, this time at 1Mbps.  It's a non-QoS
> data frame.  However, the flags indicate that it's a frame from DS not
> to DS, unlike the previous ARP request that got that part correctly!

This is the same ARP packet being sent out by the AP and this time it is
actually transmitted to broadcast address (and no ACK, as expected).

> AP rends APR reply at 5.5Mbps.  QoS field requests normal ACK, which
> never arrives.
> 
> AP sends another such frame with retry bit set, followed by 6 more
> frames at 1Mbps.  QoS field requests normal ACK, which never arrives.

It looks like the client has some problems receiving this frame or
ACKing it..

> STA broadcasts an ARP request at 36Mbps.  To-DS is set correctly.  Retry
> bit is set.  QoS field requests normal ACK.
> 
> STA receives ACK at 24Mbps.

This is odd.. This frame is a retry of the first ARP request. In other
words, it looks like the non-AP STA did not receive the ACK from the AP.
What's even stranger is that it took so long to retry the frame that the
AP had enough time to actually send its reply multiple times.. It looks
like the non-AP STA is just not receiving any frames from the AP at this
point.

> Following seems wrong to me:
> 
> 1) STA sends some packets with From-DS instead of To-DS.  I've seen more
> than one such packet, and they are always sent at 1Mbps.

No, it doesn't. This is AP re-transmitting the broadcast frame (this
time as a real broadcast transmission). This is the way IEEE 802.11 is
supposed to work..

> 2) STA doesn't send ACK to frames specifically requesting it (if I
> understand the Wireshark interpretation correctly).

And continues retrying a packet ACK'ed by the AP. In other words, the
non-AP STA does not seem to be receiving anything here (either data or
ACK to stop retransmission of its own data frame). And this is not only
OFDM frames getting lost (all ACKs were using 24 Mbps), but also 1 and
5.5 Mbps frames in the case of ARP response..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
