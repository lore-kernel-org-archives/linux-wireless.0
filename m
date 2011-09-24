Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li235-22.members.linode.com ([173.255.225.22]:57236 "EHLO
	erley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1IXPn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 11:43:26 -0400
Message-ID: <4E7DF8BB.1040807@erley.org> (sfid-20110924_174335_028519_A3FC24DA)
Date: Sat, 24 Sep 2011 11:35:23 -0400
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: higher N rates
References: <4E7D4EC4.2040506@lockie.ca>
In-Reply-To: <4E7D4EC4.2040506@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2011 11:30 PM, James wrote:
> $ iw dev wlan0 scan
> 
> printed this for my N (only) router:
> 
> Supported rates: 1.0* 2.0* 5.5* 11.0* 18.0 24.0 36.0 54.0
> Extended supported rates: 6.0 9.0 12.0 48.0
> 
> Why doesn't it print the higher N rates?

I may be WAY off base here, but I believe iw dev wlan0 scan reports 
what's shown in the beacons, and not what rates are actually negotiable.  
Beacons only directly advertise 'pre-n' rates (the basic 802.11abg rates).

If you look at more of the scan results, you should see something like:

	HT capabilities:
		Capabilities: 0x11ce
			HT20/HT40
			SM Power Save disabled
			RX HT40 SGI
			TX STBC
			RX STBC 1-stream
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 8 usec (0x06)
		HT TX/RX MCS rate indexes supported: 0-15
	HT operation:
		 * primary channel: 36
		 * secondary channel offset: above
		 * STA channel width: any
		 * RIFS: 0
		 * HT protection: no
		 * non-GF present: 0
		 * OBSS non-GF present: 0
		 * dual beacon: 0
		 * dual CTS protection: 0
		 * STBC beacon: 0
		 * L-SIG TXOP Prot: 0
		 * PCO active: 0
		 * PCO phase: 0

Which outlines the 802.11n parameters that your device and the AP can use
to negotiate 802.11n operation.  Perhaps there is something more that should
be reported, but you'll see throughputs in the 802.11n range WHEN it's 
warranted.  With my DSL connection, I rarely see rates above 9mbit in use (my 
DSL is 1.5mbit down).

Pat
