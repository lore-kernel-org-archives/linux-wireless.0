Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46095 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0JDVi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 17:38:29 -0400
Message-ID: <4CAA494B.5000500@candelatech.com>
Date: Mon, 04 Oct 2010 14:38:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net> <4CAA252F.9090102@candelatech.com> <1286219405.3620.56.camel@jlt3.sipsolutions.net> <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com> <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com>
In-Reply-To: <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 02:13 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 4, 2010 at 2:12 PM, Luis R. Rodriguez<mcgrof@gmail.com>  wrote:
>> On Mon, Oct 4, 2010 at 12:10 PM, Johannes Berg
>> <johannes@sipsolutions.net>  wrote:
>>> On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
>>>> On 10/04/2010 12:01 PM, Johannes Berg wrote:
>>>>> On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>>>>>> Just in case this seems familiar to anyone...
>>>>>>
>>>>>> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>>>>>
>>>>> Do you have debug info that'd point to a code line?
>>>>>
>>>>> I have never heard of this.
>>>>
>>>> I don't actually know how to get a line of code out of those
>>>> hex offsets...
>>>>
>>>> Someone told me many years ago..but I lost that information :P
>>>
>>> Err, I never remember either, I think Luis knows the gdb thing ... I
>>> usually use "objdump -dS"
>>
>> gdb net/mac80211/mac80211.ko
>> l *(ieee80211_stop_tx_ba_session+0x14/0x84)
>
> Oops I meant:
>
> gdb net/mac80211/mac80211.ko
> l *(ieee80211_stop_tx_ba_session+0x14)

Thank!

I had to re-compile with debugging symbols, and added kgdb (hopefully
that won't mess anything up).

Reading symbols from /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
(gdb) l *(ieee80211_stop_tx_ba_session+0x14)
0x54fe is in ieee80211_stop_tx_ba_session (/home/greearb/git/linux.wireless-testing/net/mac80211/agg-tx.c:595).
590	
591	int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
592	{
593		struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
594		struct ieee80211_sub_if_data *sdata = sta->sdata;
595		struct ieee80211_local *local = sdata->local;
596		struct tid_ampdu_tx *tid_tx;
597		int ret = 0;
598	
599		trace_api_stop_tx_ba_session(pubsta, tid);


I'm not sure I quite got the hang of kgdb yet, but hoping to get that working
and reproduce with it enabled...

Thanks,
Ben

>
>     Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

