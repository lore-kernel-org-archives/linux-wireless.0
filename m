Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:56594 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932796AbXBTC2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 21:28:13 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJKiL-0001Mu-Ny
	for linux-wireless@vger.kernel.org; Mon, 19 Feb 2007 21:26:45 -0500
Subject: Re: Capture of unsuccessful ARP exchange
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <j@w1.fi>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20070220015851.GE5279@jm.kir.nu>
References: <1171935085.8133.42.camel@dv>  <20070220015851.GE5279@jm.kir.nu>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 21:28:03 -0500
Message-Id: <1171938483.10139.13.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Jouni!

Thanks for quick and helpful reply!

On Mon, 2007-02-19 at 17:58 -0800, Jouni Malinen wrote:
> On Mon, Feb 19, 2007 at 08:31:25PM -0500, Pavel Roskin wrote:

> > STA broadcasts another ARP request, this time at 1Mbps.  It's a non-QoS
> > data frame.  However, the flags indicate that it's a frame from DS not
> > to DS, unlike the previous ARP request that got that part correctly!
> 
> This is the same ARP packet being sent out by the AP and this time it is
> actually transmitted to broadcast address (and no ACK, as expected).

That's a relief.  I should pay more attention to the order of addresses,
not just to the contents of the "source" column.

> > AP rends APR reply at 5.5Mbps.  QoS field requests normal ACK, which
> > never arrives.
> > 
> > AP sends another such frame with retry bit set, followed by 6 more
> > frames at 1Mbps.  QoS field requests normal ACK, which never arrives.
> 
> It looks like the client has some problems receiving this frame or
> ACKing it..

My first assumption was that the field QoS confuses it, but looking at
the code, it's more likely a low-level problem.  I'll try to see if the
frame is even seen by the driver.

> > STA broadcasts an ARP request at 36Mbps.  To-DS is set correctly.  Retry
> > bit is set.  QoS field requests normal ACK.
> > 
> > STA receives ACK at 24Mbps.
> 
> This is odd.. This frame is a retry of the first ARP request. In other
> words, it looks like the non-AP STA did not receive the ACK from the AP.
> What's even stranger is that it took so long to retry the frame that the
> AP had enough time to actually send its reply multiple times.. It looks
> like the non-AP STA is just not receiving any frames from the AP at this
> point.

I agree.  The frames are either not received physically or thrown out.
Which makes me wonder why the association happens so quickly.  Perhaps
it's done at lower rates.

When ping finally starts working, all the data is transmitted at 1Mbps.
And the QoS field is still there , so it's not a problem by itself.

> > 2) STA doesn't send ACK to frames specifically requesting it (if I
> > understand the Wireshark interpretation correctly).
> 
> And continues retrying a packet ACK'ed by the AP. In other words, the
> non-AP STA does not seem to be receiving anything here (either data or
> ACK to stop retransmission of its own data frame). And this is not only
> OFDM frames getting lost (all ACKs were using 24 Mbps), but also 1 and
> 5.5 Mbps frames in the case of ARP response..

That's the most interesting part, especially that ARP responses at 1Mbps
are ignored.

It looks like my doubts about the d80211 stack were wrong, and the
solution is deeper in the driver, almost certainly on the receiving
side.

-- 
Regards,
Pavel Roskin

