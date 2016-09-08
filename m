Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51419 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752248AbcIHLlp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 07:41:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k: use ieee80211_tx_status_noskb where possible
References: <20160804214940.78476-1-nbd@nbd.name>
        <8aeb7913-d955-d894-d82c-4614e17d3ee4@neratec.com>
        <9e324227-f105-bc16-f0c0-c2a3a79032e8@nbd.name>
        <236fc08a-9474-0917-47f0-756e9136e3b5@neratec.com>
Date: Thu, 08 Sep 2016 14:41:16 +0300
In-Reply-To: <236fc08a-9474-0917-47f0-756e9136e3b5@neratec.com> (Zefir
        Kurtisi's message of "Fri, 12 Aug 2016 10:31:32 +0200")
Message-ID: <87y432sjoj.fsf@kamboji.qca.qualcomm.com> (sfid-20160908_134149_040344_52FEFD95)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zefir Kurtisi <zefir.kurtisi@neratec.com> writes:

> On 08/11/2016 09:27 PM, Felix Fietkau wrote:
>> On 2016-08-11 18:05, Zefir Kurtisi wrote:
>>> On 08/04/2016 11:49 PM, Felix Fietkau wrote:
>>>> It removes the need for undoing the padding changes to skb->data and it
>>>> improves performance by eliminating one tx status lookup per MPDU in the
>>>> status path. It is also useful for preparing a follow-up fix to better
>>>> handle powersave filtering.
>>>>
>>>
>>> For me, this one introduces a regression to the statistics, e.g.
>>> 'dot11TransmittedFragmentCount' is now accounted differently since it is not
>>> updated from within ieee80211_tx_status_noskb().
>> Is this important? I guess it would be possible to make this more
>> accurate by extending the API, but I wonder if that's worth doing just
>> for these debugfs counters.
>> 
> If you want to support the IEEE802dot11.MIB (dot11mac.dot11CountersTable), they
> are important. Not sure though if it is used by others besides us.
>
> I think the real issue here is that those counters are regarded as internal debug
> values (as the comments or e.g. commit c206ca6709 state) instead of general
> purpose statistics that is exposed to SNMP. As such, they should be configurable
> as a feature independent of debug settings in mac80211.
>
>
> Aside from that consideration, this patch (with the follow up ones) increased peak
> performance noticeably (we measure some 5%+ higher peak throughput), which for
> sure is worth dropping the counters for most.
>
> I am fine handling this internally. A note in the commit message would be helpful
> that states that counters dot11TransmittedFragmentCount, dot11FrameDuplicateCount,
> dot11ReceivedFragmentCount, and dot11MulticastReceivedFrameCount become invalid.

A good idea, I updated the commit log to mention that. Does that look
ok?

Author: Felix Fietkau <nbd@nbd.name>
Date:   Fri Sep 2 19:46:12 2016 +0300

    ath9k: use ieee80211_tx_status_noskb where possible
    
    It removes the need for undoing the padding changes to skb->data and it
    improves performance by eliminating one tx status lookup per MPDU in the
    status path. It is also useful for preparing a follow-up fix to better
    handle powersave filtering.
    
    A side effect is that these counters, available via debugfs, become now invalid:
    
    * dot11TransmittedFragmentCount
    * dot11FrameDuplicateCount,
    * dot11ReceivedFragmentCount
    * dot11MulticastReceivedFrameCount
    
    Signed-off-by: Felix Fietkau <nbd@nbd.name>
    Patchwork-Id: 9264385
    [kvalo@qca.qualcomm.com: add a note about counters, thanks to Zefir Kurtisi]
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
