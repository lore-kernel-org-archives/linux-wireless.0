Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45362 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932732AbdCaLtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:49:01 -0400
Message-ID: <1490960938.6288.7.camel@sipsolutions.net> (sfid-20170331_134904_377127_79564074)
Subject: Re: [PATCH v3 1/4] mac80211-hwsim: notify user-space about channel
 change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 31 Mar 2017 13:48:58 +0200
In-Reply-To: <6ddd5a26-042b-0eaf-e8f2-11833ede300b@candelatech.com>
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
         <1490776922.7948.9.camel@sipsolutions.net>
         <260bf7e1-5ff2-709a-419b-df54b80c87f0@candelatech.com>
         <1490806271.7948.22.camel@sipsolutions.net>
         <6ddd5a26-042b-0eaf-e8f2-11833ede300b@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I really don't understand what change you are suggesting.  Anything
> that uses a new API needs to change, and as API is further improved,
> then the app will need to change again.  Netlink's saving grace is
> that it is easy to add new data members and so support new API in a
> forward/backward compatible manner.

That's true, but it'd still mean you have to update all the time, and
perhaps then we'll find out it'd be easier to break the API, etc.?

OTOH, supporting (on both sides) channel contexts doesn't seem so hard
- perhaps something like
 * add chanctx
 * remove chanctx
 * change chanctx config

as hwsim commands, and then we can pretend to add/remove in start/stop
if we have non-chanctx-hwsim?

johannes
