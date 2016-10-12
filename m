Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:35528 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbcJLMl0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 08:41:26 -0400
Received: by mail-it0-f68.google.com with SMTP id l13so3882687itl.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 05:40:40 -0700 (PDT)
Date: Wed, 12 Oct 2016 08:37:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH] mac80211: fix sequence number allocation regression
Message-ID: <20161012123710.GE18919@localhost> (sfid-20161012_144133_987326_52474E00)
References: <20161011092831.85565-1-nbd@nbd.name>
 <1476254985.5271.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1476254985.5271.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 12, 2016 at 08:49:45AM +0200, Johannes Berg wrote:
> On Tue, 2016-10-11 at 11:28 +0200, Felix Fietkau wrote:
> > The recent commit that moved around TX handlers dropped the sequence
> > number allocation at the end of ieee80211_tx_dequeue and calls
> > ieee80211_tx_h_sequence instead (for the non-fast-xmit case).
> > However, it did not change the fast-xmit sequence allocation
> > condition
> > in ieee80211_xmit_fast_finish, which skipped seqno alloc if
> > intermediate
> > tx queues are being used.
> > 
> > Drop the now obsolete condition.
> 
> Hm. I don't know what tree you're looking at, but it looks like I *did*
> in fact resolve this correctly; the (now) erroneous condition doesn't
> exist in mac80211 nor in mac80211-next (nor net, net-next, linux).
> 
> It does seem to exist in wireless-testing, but that's not something I
> can control.

Sorry about that, I should've rechecked this after Johannes did the merge.
I applied this patch (to wireless-testing) and pushed tag wt-2016-10-12.
Let me know of any further issues.

As a check I also diffed against mac80211-next/master and found additional
merge damage in the diff which I fixed up.  Once the merge window closes
in a few days, I'll resync to the masters of all the trees.

-- 
Bob Copeland %% http://bobcopeland.com/
