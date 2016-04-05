Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36759 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbcDEOcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 10:32:13 -0400
Received: by mail-oi0-f45.google.com with SMTP id y204so19522483oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 07:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459864656.18188.60.camel@sipsolutions.net>
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	<1459864656.18188.60.camel@sipsolutions.net>
Date: Tue, 5 Apr 2016 07:32:12 -0700
Message-ID: <CAA93jw4Swv9aOr=ZKoKeQyp9f1HnYJtiY7a1Lw2Ri89XjGiORQ@mail.gmail.com> (sfid-20160405_163217_255600_02B855B6)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"codel@lists.bufferbloat.net" <codel@lists.bufferbloat.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thx for the review!

On Tue, Apr 5, 2016 at 6:57 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-03-31 at 12:28 +0200, Michal Kazior wrote:
>
>> +++ b/net/mac80211/codel.h
>> +++ b/net/mac80211/codel_i.h
>
> Do we really need all this code in .h files? It seems very odd to me to
> have all the algorithm implementation there rather than a C file, you
> should (can?) only include codel.h into a single C file anyway.

The hope had been the original codel.h would have been reusable, which
is not the case at present.

>
>>  struct txq_info {
>> -     struct sk_buff_head queue;
>> +     struct txq_flow flow;
>> +     struct list_head new_flows;
>> +     struct list_head old_flows;
>
> This is confusing, can you please document that? Why are there two
> lists of flows, *and* an embedded flow? Is the embedded flow on any of
> the lists?

To explain the new and old flow concepts, there's
https://tools.ietf.org/html/draft-ietf-aqm-fq-codel-06 which is in the
ietf editors queue for final publication and doesn't have a final name
yet.

The embedded flow concept is michal's and I'm not convinced it's the
right idea as yet.

>
>> +     u32 backlog_bytes;
>> +     u32 backlog_packets;
>> +     u32 drop_codel;
>
> Would it make some sense to at least conceptually layer this a bit?
> I.e. rather than calling this "drop_codel" call it "drop_congestion" or
> something like that?

Is there a more generic place overall in ieee80211 to record per-sta
backlogs, drops and marks?

>> +     skb = codel_dequeue(flow,
>> +                         &flow->backlog,
>> +                         0,
>> +                         &flow->cvars,
>> +                         &fq->cparams,
>> +                         codel_get_time(),
>> +                         false);
>
> What happened here? :)

Magic.

>
>> +     if (!skb) {
>> +             if ((head == &txqi->new_flows) &&
>> +                 !list_empty(&txqi->old_flows)) {
>> +                     list_move_tail(&flow->flowchain, &txqi->old_flows);
>> +             } else {
>> +                     list_del_init(&flow->flowchain);
>> +                     flow->txqi = NULL;
>> +             }
>> +             goto begin;
>> +     }
>
> Ouch. Any way you can make that easier to follow?

It made my brain hurt in the original code, too, but it is eric
optimizing out cycles at his finest.

if the the new_flows list is expired or done, switch to the old_flows
list, if the old_flows list is done, go try selecting another queue to
pull from (which may or may not exist). see the pending rfc for a more
elongated version.

>
> johannes
