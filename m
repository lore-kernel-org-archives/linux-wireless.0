Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-36.dex002.intermedia.net ([64.78.21.121]:2195 "EHLO
	dhost002-36.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbXB0Qrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 11:47:36 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Tue, 27 Feb 2007 08:47:27 -0800
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Penumbra - Enabling unencrypted broadcasts alongside normal traffic
Message-ID: <20070227164727.GA10048@devicescape.com>
References: <45E41A9E.2020908@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45E41A9E.2020908@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2007 at 11:48:46AM +0000, Andy Green wrote:

> There is a start on a formal RFC for the broadcast transport protocol here:
> 
> http://penumbra.warmcat.com/penumbra-rfc-0.0.3.txt

Could you please extend the description of "Wireless Packet Format" to
define all fields in the 802.11 header. I would especially be interested
in seeing what is in the FromDS and ToDS fields of the frame control.
I'm assuming this is using normal data frames, but that (type and
subtype fields) should also be described clearly.

>  - The wireless driver gets the packet for transmission, recognizes the 
> Magic MAC, disables retries and sets the transmission rate (currently 
> fixed 54Mbps, but this will change) and transmits the packet as a broadcast

So this frame is to be sent by the non-AP STAs directly as a broadcast
frame, not through the AP which is the normal way of transmitting
frames(?)

> I hope there is some interest in this new capability for wireless 
> devices in Linux.  To get any kind of widespread use, the capability 
> needs to be already available in stock kernels and drivers so that the 
> user only needs to open iptables and run a userspace daemon rather than 
> patch his wireless drivers and stack.  So this is my reason for 
> presenting this Request For Comments, to see if it can be considered.

You would need to add "and configure the wlan driver/802.11 stack to
enable this". I don't think this has to be disabled by default.

Is this only for Linux at the moment or is someone looking at supporting
this with other OSes?

>  - Hardware promisc is needed to catch the packets because they are not 
> tagged as coming from the local AP.  All the devices I looked at can do 
> hardware promisc separately from the logical promisc for Monitor mode. 
> But perhaps this needs to be enabled and disabled in some modal way.

This has to be disabled by default. There is a reason for such a
filtering in wlan designs and just enabling promiscuous mode at 802.11
level is going to considerable increase power needs for the device which
is not acceptable for many low-power devices.

-- 
Jouni Malinen                                            PGP id EFC895FA
