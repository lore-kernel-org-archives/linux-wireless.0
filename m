Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:39400 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753230AbcIAU5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 16:57:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160830131548.6014-1-toke@toke.dk>
        <20160901160312.31540-1-toke@toke.dk>
        <1472752745.9608.8.camel@sipsolutions.net>
Date: Thu, 01 Sep 2016 20:30:59 +0200
In-Reply-To: <1472752745.9608.8.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 01 Sep 2016 19:59:05 +0200")
Message-ID: <871t1379r0.fsf@toke.dk> (sfid-20160901_225726_279577_16E51ADF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> To avoid having to deal with fragmentation on dequeue, the split is
>> set to be after the fragmentation handler. This means that some
>> reordering of TX handlers is necessary, and some handlers had to be
>> made aware of fragmentation due to this reordering.
>
> Come to think of it, that's actually counterproductive.
>
> If a fragment is dropped, or even just if fragments are reordered, the
> receiver will not be able to defragment the frame, and will thus drop
> it. Therefore, it's all-or-nothing, and we shouldn't transmit any
> fragment if we drop/reorder one (*).
>
> So ... I think you'll just have to deal with fragmentation on the
> codel/fq/whatever queues and keep fragments together, or do
> fragmentation afterwards.

Hmm, guess that makes sense. Bugger. Will think about how to do that.

>
> johannes
>
> (*) also, couldn't this mean that we send something completely stupid
> like
>
> seq=1,frag=0
> seq=2,frag=0
> seq=2,frag=1
> seq=2,frag=1
>
> if reordering happened?

(assuming the last line was supposed to read 'seq=1,frag=1')

Yes, that could happen, in principle (it depends on the fragments' size
in relation to the FQ quantum).


When does fragmentation happen anyway? Is it safe to assume there's no
aggregation when it does?

-Toke
