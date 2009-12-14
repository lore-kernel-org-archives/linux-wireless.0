Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38259 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758219AbZLNUVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 15:21:16 -0500
Date: Mon, 14 Dec 2009 15:21:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: Ethernet bridging with wireless
In-Reply-To: <1260809315.2442.408.camel@johannes.local>
Message-ID: <Pine.LNX.4.44L0.0912141519420.2690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 14 Dec 2009, Johannes Berg wrote:

> On Mon, 2009-12-14 at 11:35 -0500, Alan Stern wrote:
> > I just tried to set up ethernet bridging between the wireless interface
> > and the wired ethernet interface on my laptop machine.  It didn't work.  
> > As far as I could tell from the tcpdump output, the wireless stack
> > doesn't want to transmit packets with a foreign link-layer source
> > address.
> > 
> > Is there any way around this restriction?  Or must I resort to IP 
> > forwarding instead?
> 
> There's no standard way around this restriction, the on-air packets are
> required to be transmitted with the correct TA (transmitter address) [1]
> which also must be the SA (sender address) in the regular frame format,
> since the DA (destination address) and RA (receiver address) must be
> present and the format only has three addresses. In recent kernels (what
> will be 2.6.33), we have added code to disallow such configurations
> since they cannot work.

Okay, it sounds like the upshot is that (short of some rather unusual
and/or heroic measures) it can't be done.

Thanks for the information.

Alan Stern

