Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34898 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbcLGJYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:24:16 -0500
Message-ID: <1481102652.4092.33.camel@sipsolutions.net> (sfid-20161207_102423_683464_D1A0F883)
Subject: Re: [PATCH] mac80211: Remove invalid flag operations in mesh TSF
 synchronization
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@eero.com>,
        Masashi Honma <masashi.honma@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Date: Wed, 07 Dec 2016 10:24:12 +0100
In-Reply-To: <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com> (sfid-20161205_185947_682233_EC8A03E3)
References: <1480545889-3690-1-git-send-email-masashi.honma@gmail.com>
         <CADjYELx0ts7B8A2cAtpCjuH7b-AFFm_fqC=hnyhQBmVtu7ewzA@mail.gmail.com>
         <20161202211351.GA5571@localhost>
         <59d30c75-4eb5-cdc8-c762-b62b22664b51@gmail.com>
         <CADjYELw=-LEqDra0pM+3FjtJDve+NiNYEMz5=F0i5Ge-5k3LaA@mail.gmail.com>
         (sfid-20161205_185947_682233_EC8A03E3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure what to do with this now :)

> > There are two functionalities.
> > 
> > 1) 13.13.2.2 Neighbor offset synchronization method
> > 2) 13.13.4.4 TBTT adjustment

Yes, this much is obvious.

> > The flag is updated by 2).

Yes, the definition of the flag says:

"The TBTT Adjusting subfield is set to 1 while the TBTT adjustment
procedure is ongoing, and is set to 0 otherwise. (See 13.13.4.4.3.)"

(802.11-2012 8.4.2.100.8 Mesh Capability)

> > 13.13.4.4.3 TBTT scanning and adjustment procedures:
> > The mesh STA shall set the TBTT Adjusting field in the Mesh
> > Configuration element to 1 in order to announce that the TBTT
> > adjustment procedure is ongoing.

That's saying the same thing again, I guess :)

> > And the flag is refered by 1) as you said.
> > 
> > 
> > The purpose of the flag is to prevent 1) while 2) is ongoing.
> > 
> > In other words, 1) has only read access authority to the flag.
> > However,
> > previous code updated the flag in 1). In addition, there is no code
> > for
> > 2). So I just remove the invalid accessing codes.
> 
> I don't think 1) has read only access to that flag. A TSF adjust will
> by definition move the TBTT as well.

It seems that the wording in the spec disagrees with that - it says
(twice) to set the bit only while the TBTT adjustment procedure is
ongoing, which isn't the case here?

Then again, what exactly *is* this code doing?

It's called mesh_sync_offset_adjust_tbtt() which matches more closely
"TBTT adjustment" than "neighbor offset synchronization"? The code
looks more like offset synchronization though. Perhaps there's some
confusing and it's kinda doing both?

johannes
