Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39576 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757470AbcIAVbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 17:31:49 -0400
Message-ID: <1472752745.9608.8.camel@sipsolutions.net> (sfid-20160901_233157_202730_EF7CEEF9)
Subject: Re: [PATCH v5] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Thu, 01 Sep 2016 19:59:05 +0200
In-Reply-To: <20160901160312.31540-1-toke@toke.dk> (sfid-20160901_180539_629379_96553E29)
References: <20160830131548.6014-1-toke@toke.dk>
         <20160901160312.31540-1-toke@toke.dk>
         (sfid-20160901_180539_629379_96553E29)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> To avoid having to deal with fragmentation on dequeue, the split is
> set to be after the fragmentation handler. This means that some
> reordering of TX handlers is necessary, and some handlers had to be
> made aware of fragmentation due to this reordering.

Come to think of it, that's actually counterproductive.

If a fragment is dropped, or even just if fragments are reordered, the
receiver will not be able to defragment the frame, and will thus drop
it. Therefore, it's all-or-nothing, and we shouldn't transmit any
fragment if we drop/reorder one (*).

So ... I think you'll just have to deal with fragmentation on the
codel/fq/whatever queues and keep fragments together, or do
fragmentation afterwards.

johannes


(*) also, couldn't this mean that we send something completely stupid
like

seq=1,frag=0
seq=2,frag=0
seq=2,frag=1
seq=2,frag=1

if reordering happened?
