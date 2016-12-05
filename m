Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34289 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbcLEQ4y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 11:56:54 -0500
Received: by mail-oi0-f42.google.com with SMTP id y198so347319900oia.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 08:56:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480949847.31788.33.camel@sipsolutions.net>
References: <1479887968-17473-1-git-send-email-chiu@endlessm.com>
 <1480424369.10012.6.camel@sipsolutions.net> <CAB4CAwfJeE15nhXuLi_V-FYeCj4wj=1ojij+pwZ8V7=gdER76Q@mail.gmail.com>
 <1480949847.31788.33.camel@sipsolutions.net>
From: Chris Chiu <chiu@endlessm.com>
Date: Tue, 6 Dec 2016 00:56:52 +0800
Message-ID: <CAB4CAwdoF1D_8huKaNYrOPwnsD1fzVLjpPcuyo4sNdqgWgEpxA@mail.gmail.com> (sfid-20161205_175656_932718_4DB5AF9A)
Subject: Re: [PATCH] mac80211: fix Tx BA session stuck issue during sw scanning
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux@endlessm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 5, 2016 at 10:57 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> > The premise seems fairly reasonable, although I'm a little worried
>> > that if so much new traffic is coming in we never finish the scan
>> > suspend? Actually, the queues are still stopped, so it's only
>> > management frames that can come in, so that should be ok?
>> >
>>
>> Actually it will finish scan eventually and back to SCAN_DECISION
>> state but almost 20~30 seconds elapsed. The local->scanning should be
>> cleared after all channels been scanned. However, from the debug
>> messages I added in ieee80211_iface_work(), it still returns when
>> check local->scanning and the DELBA still has no chance to be
>> transferred then stuck again at the next scan state machine. Supposed
>> to be another scan request issued but I don't know who's the killer.
>> Except to find who issue the next scan request, BA session have no
>> chance to reset in this long scan period (>20s) still need to be
>> taken
>> care.
>
> No no, you misunderstood. My question is more like:
>
> Where is this traffic coming from, since netdev queues should be
> stopped?
>
> And then, if there's so much traffic coming in that we can take 20-30
> seconds to send it out, could we - with the change - get stuck forever?
>
My test scenario is just simply ping (not greedy ping). When it
stalls, you just see 1 ping packet has been retried on the air for 3
times w/o ack from AP. Then no more tx QoS data packet observed on the
air. From the log, it shows the tx ba session been expired and a DELBA
is queued but never sent out. So the STA wants to terminate current BA
session but can't make it. The air capture pcap file shows It can't
deal with the coming "Action" frame for "ADDBA" also. The Block Ack
state machine just stops until the whole sw scan done. In my case,
it's >300 seconds.

So this patch just tries to seek a chance to send out the DELBA and
process the BA related packets in ieee80211_iface_work(). It tries to
avoid the stuck forever thing. I tried 30000+ pings and verified no
stuck observed.

>> You're right. I just want to clear_bit and set_bit in this case,
>> sorry for that confusing. Or any better suggestion?
>
> We seem to be using set_bit/clear_bit so that seems reasonable, unless
> you can prove that all of those are under the lock and we can remove
> the atomics entirely ... Not that it matters hugely, we don't scan all
> the time after all!
>
I agree. Will modify this patch and then send again for approval.
> johannes
