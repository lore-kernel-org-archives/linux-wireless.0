Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44560 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbbIBEsl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 00:48:41 -0400
Message-ID: <1441169316.25005.135.camel@coelho.fi> (sfid-20150902_064845_001679_9F522815)
From: Luca Coelho <luca@coelho.fi>
To: James Cameron <quozl@laptop.org>, Shengrong Yin <syin@uh.edu>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Sep 2015 07:48:36 +0300
In-Reply-To: <20150901025307.GE1329@us.netrek.org>
References: <CAAGWusB5n7=62VFdq-=h7BsP3fkwnG6dvjFdixL_SPBhw06S3A@mail.gmail.com>
	 <20150901025307.GE1329@us.netrek.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: How to set a scan on a given frequency
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-01 at 12:53 +1000, James Cameron wrote:
> On Mon, Aug 31, 2015 at 03:53:18PM -0500, Shengrong Yin wrote:
> > Hello,
> > 
> > I was using iw to scan a given frequency.
> > For example,
> > iw wlan0 scan freq 2412 | grep freq:
> > However, the result was scanned ssids with different frequencies
> > across 2.4 GHz band, which is
> > freq: 2462
> > freq: 2462
> > freq: 2437
> > freq: 2412
> > ...
> > Why this happened? Shouldn't it return only the ssid with 2412?
> 
> No.  A radio receiver in a wireless device can receive beacons on
> adjacent frequencies to the frequency it is tuned for.  The signal
> strength will be lower, but not low enough to prevent receive.
> 
> If you want to restrict results to the frequency you are interested
> in, then filter the data after you have received it from the kernel.
> 
> But the data returned to you isn't the frequency of the received 
> radio
> burst, but is the frequency value in the beacon packet.  Usually this
> is the same, but faulty devices, deceptive devices, or high speed
> movement could make it different.
> 
> You should specify a frequency in your scan request if you can,
> because it shortens the time taken by the scan.  If you do not 
> specify
> a frequency, then the scan must be repeated for every channel.  There
> is a time cost for switching, and a time spent listening on each
> channel.

Yes, the results found in a scan are not filtered.  It's the same thing
if you specify an SSID in the scan command.  That only causes a
probe_req with the SSID to be sent out (instead of the default
"wildcard" SSID).  If other APs happen to beacon on the channels you're
scanning, you'll receive those results too (even if they are from other
SSIDs).

Additionally, you will also get results that were in the cache (which
lasts ~15 seconds).  This means that if you issue a full scan followed
by a scan on a single scan within 15 seconds of each other, the latter
will also return all the results found in the first one.

--
Luca.
