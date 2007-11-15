Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34679 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185AbXKOXLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 18:11:16 -0500
Message-ID: <473CD214.3060000@lwfinger.net> (sfid-20071115_231120_958760_F774DA5B)
Date: Thu, 15 Nov 2007 17:11:16 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: seandarcy2@gmail.com, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/T] b43: Implement the BCM94311MCG rev 02 card with a rev
 13 802.11 core
References: <473bdf5e.LS8yn+6u1JmDiT9C%Larry.Finger@lwfinger.net> <200711151138.17468.mb@bu3sch.de> <473C5F98.1050007@lwfinger.net> <200711152249.12824.mb@bu3sch.de>
In-Reply-To: <200711152249.12824.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 15 November 2007 16:02:48 Larry Finger wrote:
>> It took me a while to figure out where the magic number of 200 came from, and what I needed for the
>> 64-bit case. In fact I think the 200 is a bug and should be 0x200. To me, this change makes it clearer.
> 
> The 200 is just a random number.
> I think we don't really care what the value is. (Except zero, which doesn't
> work on some devices).

I think the specs are missing one word and that this quantity should be called "Descriptor Stop
Index" for RX. My understanding is that the RX process uses the descriptors in order until this
particular value is reached. At this point, it restarts at the beginning making a ring buffer. As we
have just allocated 64 slots, it didn't quite seem right to use only the first 25 of them, which is
what the 200 accomplishes. Of course, 25 DMA RX buffers are quite likely to be more than enough. We
might reconsider cutting the allocation number and not take so much DMAable memory. With 64-bit DMA,
all memory is suitable, but not so for the 30-bit cards.

Larry


