Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49440 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbeIJMo7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 08:44:59 -0400
Message-ID: <1536565926.3224.15.camel@sipsolutions.net> (sfid-20180910_095218_083471_0D02864E)
Subject: Re: [PATCH RFC v3 0/4] Move TXQ scheduling into mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 09:52:06 +0200
In-Reply-To: <153635803319.14170.10011969968767927187.stgit@alrua-x1> (sfid-20180908_002304_387192_9DBCE4B9)
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         (sfid-20180908_002304_387192_9DBCE4B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:
> 
> A few things that were discussed in the last round that I did *not* change:

Thanks for this list btw.

> - I did not add any locking around next_txq(); the driver is still supposed
>   to maintain a lock that prevents two threads from trying to schedule the
>   same AC at the same time. This is what drivers already do, so I figured it
>   was easier to just keep it that way rather than do it in mac80211.

I'll look at this in the code, but from a maintainer perspective I'm
somewhat worried that this will lead to issues that are really the
driver's fault, but surface in mac80211. I don't know how easy it would
be to catch that.

Might be fine, but something to keep in mind.

johannes
