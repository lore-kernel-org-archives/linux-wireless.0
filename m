Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40842 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753754AbdEQNcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 09:32:36 -0400
Message-ID: <1495027954.2442.15.camel@sipsolutions.net> (sfid-20170517_153242_168600_16B8A5BF)
Subject: Re: iw reg get since iw-4.x
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Naumov <sknaumov@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 17 May 2017 15:32:34 +0200
In-Reply-To: <CAH3pVZMe4p_0eq+19mnPgjaXxPTUYeA6cUOe0K1kK4TohH6tgw@mail.gmail.com> (sfid-20170512_161148_697381_B02E8B2E)
References: <CAH3pVZMe4p_0eq+19mnPgjaXxPTUYeA6cUOe0K1kK4TohH6tgw@mail.gmail.com>
         (sfid-20170512_161148_697381_B02E8B2E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-05-12 at 17:11 +0300, Sergey Naumov wrote:
> Hi All.
> 
> I see that since iw-4.x "iw reg get" reports multiple region
> information - per-phy and global. Moreover, per-phy information could
> be marked as "self-managed".

That's also dependent on the kernel.

> Could somebody clarify when a driver uses phy-specific region and
> when
> - the global one?

It's just a driver decision, and how the firmware works.

> Looking at a list of channels from "iw phy phyX info" I can conclude
> that if "self-managed" is true, then phy-specific region is used,
> otherwise - the global one. Is it a correct assumption? If yes, then
> why phy-specific regions are reported at all for non-self-managed
> devices, and why the global region is reported for self-managed ones?

Good question, I'm not sure right now. You probably need to look at the
kernel's code (net/wireless/reg.c) to figure out the answer.

> I think it would be natural to use new "iw phy phyX reg get" command
> to report region information that is actually used, but unfortunately
> this command returns exactly the same as "iw reg get":

It's a pure alias right now, but that could be fixed by filtering in iw
I guess.

johannes
