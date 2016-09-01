Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39355 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755817AbcIAVBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 17:01:50 -0400
Message-ID: <1472754954.9608.13.camel@sipsolutions.net> (sfid-20160901_230155_997778_288B9778)
Subject: Re: [PATCH v5] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Sep 2016 20:35:54 +0200
In-Reply-To: <871t1379r0.fsf@toke.dk>
References: <20160830131548.6014-1-toke@toke.dk>
         <20160901160312.31540-1-toke@toke.dk>
         <1472752745.9608.8.camel@sipsolutions.net> <871t1379r0.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-01 at 20:30 +0200, Toke Høiland-Jørgensen wrote:

> > seq=1,frag=0
> > seq=2,frag=0
> > seq=2,frag=1
> > seq=2,frag=1
> > 
> > if reordering happened?
> 
> (assuming the last line was supposed to read 'seq=1,frag=1')

I did actually mean seq=2,frag=1, since the seqno assignment happened
after fragmentation in your patch, and after codel reordering, and
would not change the seqno until it encountered a frag=0 packet.

Or maybe that was only with the previous version of the patch.

> When does fragmentation happen anyway? Is it safe to assume there's
> no aggregation when it does?
> 

Yes, fragmented packets are not allowed to be aggregated.

johannes
