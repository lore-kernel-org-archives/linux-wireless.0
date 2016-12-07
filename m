Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36614 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbcLGNew (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 08:34:52 -0500
Received: by mail-io0-f176.google.com with SMTP id l140so95960110iol.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 05:34:52 -0800 (PST)
Date: Wed, 7 Dec 2016 08:33:15 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Thomas Pedersen <thomas@eero.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
Message-ID: <20161207133315.GD7524@localhost> (sfid-20161207_143455_690873_7AC3658E)
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
 <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
 <20161202211351.GA5571@localhost>
 <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
 <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com>
 <1481102652.4092.33.camel@sipsolutions.net>
 <9197b711-3d48-071a-57d8-53e2a11c26de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9197b711-3d48-071a-57d8-53e2a11c26de@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2016 at 09:55:41PM +0900, Masashi Honma wrote:
> >It's called mesh_sync_offset_adjust_tbtt() which matches more closely
> >"TBTT adjustment" than "neighbor offset synchronization"?
> 
> I think so. Because there is not any code creating "TBTT Adjustment Request
> frame" even though the frame is required by "TBTT adjustment".

This mesh_sync_offset_adjust_tbtt is definitely doing offset
synchronization, so probably "tbtt" should be renamed "tsf" here.

> >The code
> >looks more like offset synchronization though. Perhaps there's some
> >confusing and it's kinda doing both?
> 
> In theory, updating the flag with 1) looks not correct because it is not
> clearly defined in spec.
> 
> In practice, I could consider extending the meaning of the flag over the
> spec to use it to avoid referring the updating TSF value by peer as Thomas
> said. I have took the statistics how many TSF drift
> (ifmsh->sync_offset_clockdrift_max) happens. The attached file shows the
> stats. The horizontal axis shows TSF drift time(usec) and vertical axis
> shows how many time the drift occurred. The graph shows almost drifts are
> under 20usec. In contrast, 2) could causes more than 1000usec drift. So 1)
> looks not so large enough to protect with the flag.

Yes, offset synchronization is (given decent clocks) supposed to be only
for small tweaks.  We will do it up to .8 ms drift though -- above .8 ms, we
just reset drift to zero and adopt the new timing offset.  You can see this
kind of large "drift" by restarting a station.

Actually, looking at the code now it doesn't make a lot of sense to set
this flag for offset sync because TOFFSET_KNOWN flag is completely cleared
whenever that is set, so we have to be forgetting the current t_offset all
the time?

-- 
Bob Copeland %% http://bobcopeland.com/
