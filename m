Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0JEGJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 02:09:45 -0400
Received: by iwn5 with SMTP id 5so7886843iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 23:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CAA9DFB.4090009@candelatech.com>
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net>
 <4CAA252F.9090102@candelatech.com> <1286219405.3620.56.camel@jlt3.sipsolutions.net>
 <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com>
 <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com>
 <4CAA494B.5000500@candelatech.com> <AANLkTi=3EXnANmEP28Z2ASmqxopbe-EDypska72bL=to@mail.gmail.com>
 <4CAA9DFB.4090009@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 23:09:24 -0700
Message-ID: <AANLkTimV=T66CYSJhv=_8zXxx2UYGSzq+QgWhCH46u3L@mail.gmail.com>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 8:39 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 10/04/2010 04:48 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Oct 4, 2010 at 2:38 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 10/04/2010 02:13 PM, Luis R. Rodriguez wrote:
>>>>
>>>> On Mon, Oct 4, 2010 at 2:12 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>>>>  wrote:
>>>>>
>>>>> On Mon, Oct 4, 2010 at 12:10 PM, Johannes Berg
>>>>> <johannes@sipsolutions.net>    wrote:
>>>>>>
>>>>>> On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
>>>>>>>
>>>>>>> On 10/04/2010 12:01 PM, Johannes Berg wrote:
>>>>>>>>
>>>>>>>> On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>>>>>>>>>
>>>>>>>>> Just in case this seems familiar to anyone...
>>>>>>>>>
>>>>>>>>> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>>>>>>>>
>>>>>>>> Do you have debug info that'd point to a code line?
>>>>>>>>
>>>>>>>> I have never heard of this.
>>>>>>>
>>>>>>> I don't actually know how to get a line of code out of those
>>>>>>> hex offsets...
>>>>>>>
>>>>>>> Someone told me many years ago..but I lost that information :P
>>>>>>
>>>>>> Err, I never remember either, I think Luis knows the gdb thing ... I
>>>>>> usually use "objdump -dS"
>>>>>
>>>>> gdb net/mac80211/mac80211.ko
>>>>> l *(ieee80211_stop_tx_ba_session+0x14/0x84)
>>>>
>>>> Oops I meant:
>>>>
>>>> gdb net/mac80211/mac80211.ko
>>>> l *(ieee80211_stop_tx_ba_session+0x14)
>>>
>>> Thank!
>>>
>>> I had to re-compile with debugging symbols, and added kgdb (hopefully
>>> that won't mess anything up).
>>
>> You may want to look at using netconsole instead if you're goal is
>> just to get some oops off the box.
>>
>> CONFIG_NETCONSOLE=m
>>
>> mcgrof@tux ~/bin $ cat netconsole
>> #!/bin/bash
>> sudo dmesg -n 8
>> sudo ip addr add 192.168.4.2/24 dev eth4
>> sudo modprobe netconsole
>> netconsole="@192.168.4.2/eth4,@192.168.4.3/00:1e:37:82:48:5a"
>>
>> I'd run that script on the dev box, and on 192.168.4.3 just do `nc -l
>> -p 6666 | tee log`. To test just modprobe and rmmod ath9k.
>>
>>> Reading symbols from
>>>
>>> /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
>>> (gdb) l *(ieee80211_stop_tx_ba_session+0x14)
>>> 0x54fe is in ieee80211_stop_tx_ba_session
>>> (/home/greearb/git/linux.wireless-testing/net/mac80211/agg-tx.c:595).
>>> 590
>>> 591     int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta,
>>> u16
>>> tid)
>>> 592     {
>>> 593             struct sta_info *sta = container_of(pubsta, struct
>>> sta_info,
>>> sta);
>>> 594             struct ieee80211_sub_if_data *sdata = sta->sdata;
>>> 595             struct ieee80211_local *local = sdata->local;
>>
>> What was the oops complaint? NULL pointer dereference? If sdata got
>> screwed up that would be pretty serious, the only way that could
>> happen is if somehow it managed to get removed prior to the
>> ieee80211_stop_tx_ba_session() or if there is some sort of memory
>> corruption., What steps do you follow to reproduce?
>
> It's dying trying to de-reference something, probably sdata, but for some
> reason I didn't
> think it was NULL.  (I was having trouble getting clean stack dumps
> on the serial console on top of my other issues today.)  In A
> probably-similar
> crash it was trying to dereference 0x00100104 (See my 3:42 email)
> in this series.
>
> I added printks to the stop_tx_ba_session method to try to figure out what
> was happening, but
> of course then I could no longer reproduce it, or at least it crashed in the
> cfg80211_unlink_bss
> first.
>
> To reproduce, I have a user-space app that creates 130 or so STA devices,
> starts wpa_supplicant
> for each one, and then watches events with 'iw event', and reads
> /proc/net/wireless quite often
> (and grabs some other stats out of debugfs, etc).  It runs 'iwconfig' and
> parses output for
> other stats.  In short, it does a bunch of things that would be hard to
> reproduce with any
> simple script.  The user-space app is proprietary, though I would of course
> give you a free
> binary and help you set it up should you wish to use it.
>
> When I disabled power-save, it ran a lot longer, but it would still
> hard-hang or occasionally
> crash with stack-trace pointing to the 0x00100104 dereference.
>
> Perhaps related, with power-save disabled, after a while (maybe 10-20
> minutes), the system
> would often get to a state where the ath9k no longer showed any additional
> transmitted packets
> in it's debugfs traffic.  The netdevices (sta1, etc), would show tx pkt
> counters increasing,
> and the qdiscs showed no backlog.  It was getting rx interrupts, but no tx,
> according to
> debugfs output.  I didn't get any chance to debug that any further.
>
> We have much better luck with ath5k in general, so I think most of these
> issues are
> related to ath9k and/or /n in general.  But, even so, we do see deadlocks
> (on rtnl_lock, it seems)
> with ath5k, and I still have some lockdep warnings to deal with in the
> mac80211 code,
> so it's possible the problem is more general and ath9k just triggers it much
> easier.

Can you try with mac80211_hwsim ?

  Luis
