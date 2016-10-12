Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41007 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753126AbcJLGtv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 02:49:51 -0400
Message-ID: <1476254985.5271.1.camel@sipsolutions.net> (sfid-20161012_084955_309850_CC050A27)
Subject: Re: [PATCH] mac80211: fix sequence number allocation regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Bob Copeland <me@bobcopeland.com>
Date: Wed, 12 Oct 2016 08:49:45 +0200
In-Reply-To: <20161011092831.85565-1-nbd@nbd.name>
References: <20161011092831.85565-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-11 at 11:28 +0200, Felix Fietkau wrote:
> The recent commit that moved around TX handlers dropped the sequence
> number allocation at the end of ieee80211_tx_dequeue and calls
> ieee80211_tx_h_sequence instead (for the non-fast-xmit case).
> However, it did not change the fast-xmit sequence allocation
> condition
> in ieee80211_xmit_fast_finish, which skipped seqno alloc if
> intermediate
> tx queues are being used.
> 
> Drop the now obsolete condition.

Hm. I don't know what tree you're looking at, but it looks like I *did*
in fact resolve this correctly; the (now) erroneous condition doesn't
exist in mac80211 nor in mac80211-next (nor net, net-next, linux).

It does seem to exist in wireless-testing, but that's not something I
can control.

johannes
