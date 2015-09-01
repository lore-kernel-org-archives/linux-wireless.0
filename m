Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:36696 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbbIACxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 22:53:32 -0400
Date: Tue, 1 Sep 2015 12:53:08 +1000
From: James Cameron <quozl@laptop.org>
To: Shengrong Yin <syin@uh.edu>
Cc: linux-wireless@vger.kernel.org
Subject: Re: How to set a scan on a given frequency
Message-ID: <20150901025307.GE1329@us.netrek.org> (sfid-20150901_045335_328253_D2BC49EB)
References: <CAAGWusB5n7=62VFdq-=h7BsP3fkwnG6dvjFdixL_SPBhw06S3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAGWusB5n7=62VFdq-=h7BsP3fkwnG6dvjFdixL_SPBhw06S3A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2015 at 03:53:18PM -0500, Shengrong Yin wrote:
> Hello,
> 
> I was using iw to scan a given frequency.
> For example,
> iw wlan0 scan freq 2412 | grep freq:
> However, the result was scanned ssids with different frequencies
> across 2.4 GHz band, which is
> freq: 2462
> freq: 2462
> freq: 2437
> freq: 2412
> ...
> Why this happened? Shouldn't it return only the ssid with 2412?

No.  A radio receiver in a wireless device can receive beacons on
adjacent frequencies to the frequency it is tuned for.  The signal
strength will be lower, but not low enough to prevent receive.

If you want to restrict results to the frequency you are interested
in, then filter the data after you have received it from the kernel.

But the data returned to you isn't the frequency of the received radio
burst, but is the frequency value in the beacon packet.  Usually this
is the same, but faulty devices, deceptive devices, or high speed
movement could make it different.

You should specify a frequency in your scan request if you can,
because it shortens the time taken by the scan.  If you do not specify
a frequency, then the scan must be repeated for every channel.  There
is a time cost for switching, and a time spent listening on each
channel.

-- 
James Cameron
http://quozl.linux.org.au/
