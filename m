Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33798 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752663AbeEVUkL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 16:40:11 -0400
Message-ID: <1527021608.6787.47.camel@sipsolutions.net> (sfid-20180522_224014_575834_7568CE58)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Tim Kourt <tim.a.kourt@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 22:40:08 +0200
In-Reply-To: <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com> (sfid-20180522_223752_743447_70AB98E8)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         <1527019967.6787.45.camel@sipsolutions.net>
         <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
         (sfid-20180522_223752_743447_70AB98E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> So I need to absorb all of this some more, but I'm still wondering why 
> we are seeing two separate scan entries (with hidden & plain ssid) when 
> we requested a flush?  Is there a way to force the kernel to only show 
> us the probe responses.

Oh. I didn't even think about this part, but that's just a consequence
of having a hidden SSID. We need one entry to track the beacon, and then
we add another entry for each hidden SSID it may have. Some APs
implement multiple SSIDs that way (old Cisco equipment, IIRC, though
then with zero-length SSID instead of zero-bytes), so you can't lump
them together into a single BSS entry.

> It would seem that even with the flush flag set, there could still be 
> spurious beacons getting in causing these results to appear in the scan 
> result set, right?

In general anything can, there's no filtering. So you might do a flush
scan for a specific SSID and still get 20 (different) results, if 20
beacons happened to be received while you were scanning.

johannes
