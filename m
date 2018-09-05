Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59927 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbeIEPVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 11:21:53 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: Re: [PATCH] mac80211: fix pending queue hang due to TX_DROP
In-Reply-To: <20180905102259.16089-1-me@bobcopeland.com>
References: <20180905102259.16089-1-me@bobcopeland.com>
Date: Wed, 05 Sep 2018 12:52:11 +0200
Message-ID: <874lf46wtg.fsf@toke.dk> (sfid-20180905_125214_865468_F09121F4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> In our environment running lots of mesh nodes, we are seeing the
> pending queue hang periodically, with the debugfs queues file showing
> lines such as:
>
>     00: 0x00000000/348
>
> i.e. there are a large number of frames but no stop reason set.
>
> One way this could happen is if queue processing from the pending
> tasklet exited early without processing all frames, and without having
> some future event (incoming frame, stop reason flag, ...) to reschedule
> it.
>
> Exactly this can occur today if ieee80211_tx() returns false due to
> packet drops or power-save buffering in the tx handlers.  In the
> past, this function would return true in such cases, and the change
> to false doesn't seem to be intentional.

Can confirm that this was not intentional; nice catch! :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

-Toke
