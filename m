Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:5027 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbcHLIlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 04:41:46 -0400
Subject: Re: [PATCH 1/2] ath9k: use ieee80211_tx_status_noskb where possible
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <20160804214940.78476-1-nbd@nbd.name>
 <8aeb7913-d955-d894-d82c-4614e17d3ee4@neratec.com>
 <9e324227-f105-bc16-f0c0-c2a3a79032e8@nbd.name>
Cc: kvalo@codeaurora.org
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Message-ID: <236fc08a-9474-0917-47f0-756e9136e3b5@neratec.com> (sfid-20160812_104155_949635_B3CCD410)
Date: Fri, 12 Aug 2016 10:31:32 +0200
MIME-Version: 1.0
In-Reply-To: <9e324227-f105-bc16-f0c0-c2a3a79032e8@nbd.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2016 09:27 PM, Felix Fietkau wrote:
> On 2016-08-11 18:05, Zefir Kurtisi wrote:
>> On 08/04/2016 11:49 PM, Felix Fietkau wrote:
>>> It removes the need for undoing the padding changes to skb->data and it
>>> improves performance by eliminating one tx status lookup per MPDU in the
>>> status path. It is also useful for preparing a follow-up fix to better
>>> handle powersave filtering.
>>>
>>
>> For me, this one introduces a regression to the statistics, e.g.
>> 'dot11TransmittedFragmentCount' is now accounted differently since it is not
>> updated from within ieee80211_tx_status_noskb().
> Is this important? I guess it would be possible to make this more
> accurate by extending the API, but I wonder if that's worth doing just
> for these debugfs counters.
> 
If you want to support the IEEE802dot11.MIB (dot11mac.dot11CountersTable), they
are important. Not sure though if it is used by others besides us.

I think the real issue here is that those counters are regarded as internal debug
values (as the comments or e.g. commit c206ca6709 state) instead of general
purpose statistics that is exposed to SNMP. As such, they should be configurable
as a feature independent of debug settings in mac80211.


Aside from that consideration, this patch (with the follow up ones) increased peak
performance noticeably (we measure some 5%+ higher peak throughput), which for
sure is worth dropping the counters for most.

I am fine handling this internally. A note in the commit message would be helpful
that states that counters dot11TransmittedFragmentCount, dot11FrameDuplicateCount,
dot11ReceivedFragmentCount, and dot11MulticastReceivedFrameCount become invalid.


Cheers,
Zefir



