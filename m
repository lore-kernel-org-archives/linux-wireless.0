Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43454 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751726AbcLEPA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 10:00:58 -0500
Message-ID: <1480950054.31788.36.camel@sipsolutions.net> (sfid-20161205_160104_005466_DB882532)
Subject: Re: [PATCH 1/2] mac80211: do not iterate active interfaces when in
 re-configure
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Mon, 05 Dec 2016 16:00:54 +0100
In-Reply-To: <58458058.5020008@candelatech.com>
References: <1480645800-2148-1-git-send-email-greearb@candelatech.com>
         <CA+BoTQkEaC-ZSbeK=JB=q+ucF1PWcEQXkJEp6JYv4pfOf35cHg@mail.gmail.com>
         (sfid-20161205_092619_855272_0854B225) <1480945950.31788.4.camel@sipsolutions.net>
         <58458058.5020008@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-12-05 at 06:57 -0800, Ben Greear wrote:

> I think clearing sdata-in-driver would fix the ath10k problem, at
> least, but I was afraid it would break something else in mac80211 or
> maybe in other thick firmware drivers.

It's pretty much an internal thing - not sure what it'd break. OTOH,
some drivers might actually assume that iterating finds them all, if
they never clear the data even across a restart?

> One way or another, we cannot be iterating over interfaces while
> the interfaces are at the same time being (re)added.

Well, we obviously *can* be, and we do in fact do that - it's just that
ath10k specifically has issues with the data it's putting there, no?

> Maybe mac80211 should explicitly remove all interfaces from the
> driver during crash recovery?  

I don't think that'll work. Removing them would interact with the
firmware, which is dead, etc. That'd just cause trouble.

> And the behaviour needs to be clearly documented somewhere
> easy to find so that we can think about and program to the correct
> API behaviour.

We assume that the driver resets all its internal state - this whole
interface iteration is a corner case we hadn't considered, I suppose.

johannes
