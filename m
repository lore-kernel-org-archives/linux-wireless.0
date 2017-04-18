Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47622 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbdDRJ64 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 05:58:56 -0400
Message-ID: <1492509533.2472.17.camel@sipsolutions.net> (sfid-20170418_115859_685517_59B2335D)
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Apr 2017 11:58:53 +0200
In-Reply-To: <16c10539-3ab3-f5ec-38ab-0fc7abca1a94@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490776922.7948.9.camel@sipsolutions.net>
         <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
         <1490806271.7948.22.camel@sipsolutions.net>
         <6ddd5a26-042b-0eaf-e8f2-11833ede300b@candelatech.com>
         <1490960938.6288.7.camel@sipsolutions.net>
         <16c10539-3ab3-f5ec-38ab-0fc7abca1a94@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-31 at 06:33 -0700, Ben Greear wrote:
> 
> In my experience, the big problem with netlink is that if you write
> a patch that cannot make it upstream (or takes forever), then the
> netlink IDs conflict as upstream adds more stuff.

Sure, that's a common problem we all run into :)

> Other than that, it is easy to add new members, or completely new
> commands.
> 
> User-space can drop old API and simply not fully work against older
> kernels if it wants, especially for something as specialized as a
> simulated wifi radio.

Yeah, but the kernel will have to maintain both versions, and strictly
speaking shouldn't be breaking old userspace - but that would be
impossible as one moves to chanctx, perhaps even by default.

This is the problem I have with it - chanctx code already exists and is
used, so there's no technical reason not to support both now.

> So, if my patch can go in as is or with small tweaks, then I'm happy
> to keep working on it.  If it needs a complete re-write, then it will
> have to wait for someone else or some later date.

Ok, that's fair. I think I'll leave it out then though, because I
really do think that we should aim to support chanctx from the start
with this, it's well-established by now.

johannes
