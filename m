Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34464 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752660AbeEVV2V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:28:21 -0400
Message-ID: <1527024498.6787.67.camel@sipsolutions.net> (sfid-20180522_232825_082676_6A1633BC)
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>
Cc: Tim Kourt <tim.a.kourt@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 22 May 2018 23:28:18 +0200
In-Reply-To: <c0b00a4c-f98e-6261-976b-d9c7ae708eee@gmail.com> (sfid-20180522_232515_230553_27869AEE)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
         <1526631206.3805.1.camel@sipsolutions.net>
         <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
         <1527019967.6787.45.camel@sipsolutions.net>
         <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
         <1527021608.6787.47.camel@sipsolutions.net>
         <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
         <1527022332.6787.51.camel@sipsolutions.net>
         <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com>
         <1527023478.6787.60.camel@sipsolutions.net>
         <c0b00a4c-f98e-6261-976b-d9c7ae708eee@gmail.com>
         (sfid-20180522_232515_230553_27869AEE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-22 at 16:25 -0500, Denis Kenzior wrote:
> Hi Johannes,
> 
> > But in theory, I think you could've received the beacon with hidden SSID
> > *before* the scan, yet it might be present in the scan results if the
> > new scan caused the probe response to be associated with that scan.
> 
> Right, your explanation was helpful, thanks.  It still seems completely 
> weird and redundant that we get two separate entries though.  The second 
> entry with the probe response data still carries the beacon info (as you 
> point out).  Should the pure-beacon one be filtered?

I'm not sure. It still indicates that a hidden SSID was found, and in
general even a real SSID on the same BSSID doesn't indicate that this
was the only hidden SSID ...

> Right, so thinking out loud here.  Would it be useful to tell GET SCAN 
> to only return entries with actual probe response data?  Combined with 
> the flush flag it seems like a much better fit for the cases you point out.

I don't really see much point in doing filtering in the kernel. It
wouldn't doesn't hurt, but just trades off more kernel code for less
transferred data - and that's mostly in this particular corner case, so
not really an efficiency problem?

And if it wasn't a hidden SSID, then you probably do want to know about
the non-hidden SSIDs that you picked up along the way. In fact, this
will become crucial with OCE, since that results in cases where you
don't even send a probe request if you've picked up certain things
during the scan passively.

johannes
