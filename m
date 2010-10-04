Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38921 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0JDWmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 18:42:46 -0400
Message-ID: <4CAA5861.4020503@candelatech.com>
Date: Mon, 04 Oct 2010 15:42:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Crash in agg-tx.c, with ath9k and lots of STA VIFs.
References: <4CAA2247.50402@candelatech.com> <1286218879.3620.55.camel@jlt3.sipsolutions.net> <4CAA252F.9090102@candelatech.com> <1286219405.3620.56.camel@jlt3.sipsolutions.net> <AANLkTi=Ya6RuCdVYLYi3Mk5EKSP6czOfTh7TRKqB0GPU@mail.gmail.com> <AANLkTinGaCAEqGRt_X6hsO8sQx4kKEdNqU8pfi00_1-r@mail.gmail.com> <4CAA494B.5000500@candelatech.com>
In-Reply-To: <4CAA494B.5000500@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2010 02:38 PM, Ben Greear wrote:
> On 10/04/2010 02:13 PM, Luis R. Rodriguez wrote:
>> On Mon, Oct 4, 2010 at 2:12 PM, Luis R. Rodriguez<mcgrof@gmail.com>
>> wrote:
>>> On Mon, Oct 4, 2010 at 12:10 PM, Johannes Berg
>>> <johannes@sipsolutions.net> wrote:
>>>> On Mon, 2010-10-04 at 12:04 -0700, Ben Greear wrote:
>>>>> On 10/04/2010 12:01 PM, Johannes Berg wrote:
>>>>>> On Mon, 2010-10-04 at 11:51 -0700, Ben Greear wrote:
>>>>>>> Just in case this seems familiar to anyone...
>>>>>>>
>>>>>>> IP: [<f8ba74da>] ieee80211_stop_tx_ba_session+0x14/0x84 [mac80211]
>>>>>>
>>>>>> Do you have debug info that'd point to a code line?
>>>>>>
>>>>>> I have never heard of this.
>>>>>
>>>>> I don't actually know how to get a line of code out of those
>>>>> hex offsets...
>>>>>
>>>>> Someone told me many years ago..but I lost that information :P
>>>>
>>>> Err, I never remember either, I think Luis knows the gdb thing ... I
>>>> usually use "objdump -dS"
>>>
>>> gdb net/mac80211/mac80211.ko
>>> l *(ieee80211_stop_tx_ba_session+0x14/0x84)
>>
>> Oops I meant:
>>
>> gdb net/mac80211/mac80211.ko
>> l *(ieee80211_stop_tx_ba_session+0x14)
>
> Thank!
>
> I had to re-compile with debugging symbols, and added kgdb (hopefully
> that won't mess anything up).
>
> Reading symbols from
> /home/greearb/kernel/2.6/wireless-testing-dbg.p4s/net/mac80211/mac80211.ko...done.
>
> (gdb) l *(ieee80211_stop_tx_ba_session+0x14)
> 0x54fe is in ieee80211_stop_tx_ba_session
> (/home/greearb/git/linux.wireless-testing/net/mac80211/agg-tx.c:595).
> 590
> 591 int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
> 592 {
> 593 struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
> 594 struct ieee80211_sub_if_data *sdata = sta->sdata;
> 595 struct ieee80211_local *local = sdata->local;
> 596 struct tid_ampdu_tx *tid_tx;
> 597 int ret = 0;
> 598
> 599 trace_api_stop_tx_ba_session(pubsta, tid);
>
>
> I'm not sure I quite got the hang of kgdb yet, but hoping to get that
> working
> and reproduce with it enabled...

I gave up on getting kgdb to work..seemed to cause more problems than
it fixed.

I did find a similar crash while debugging a kernel with just symbols
compiled in (not kgdb) though:

The interesting thing to me is that the 00100104 address is the same in
both crashes, though this one is in a different method.

Also, this is with power-save NOT disabled (I was hoping to
hit some debugging code I put in for the other crash..hit this instead.)

Oct  4 15:26:15 localhost kernel: BUG: unable to handle kernel paging request at 00100104
Oct  4 15:26:15 localhost kernel: IP: [<fc77e038>] cfg80211_unlink_bss+0x4d/0x8d [cfg80211]
Oct  4 15:26:15 localhost kernel: *pde = 00000000
Oct  4 15:26:15 localhost kernel: Oops: 0002 [#1] SMP
Oct  4 15:26:15 localhost kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:08:01.0/net/sta26/flags
Oct  4 15:26:15 localhost kernel: Modules linked in: michael_mic ath5k arc4 ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 aes_i586 aes_generic 8021q garp 
stp llc macvlan pktgen fuse nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 uinput ecb e1000e iTCO_wdt iTCO_vendor_support pcspkr i2c_i801 microcode i915 
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: ipt_addrtype]
Oct  4 15:26:15 localhost kernel:
Oct  4 15:26:15 localhost kernel: Pid: 41, comm: kworker/u:2 Not tainted 2.6.36-rc6-wl+ #4 PDSBM/PDSBM
Oct  4 15:26:15 localhost kernel: EIP: 0060:[<fc77e038>] EFLAGS: 00010282 CPU: 1
Oct  4 15:26:15 localhost kernel: EIP is at cfg80211_unlink_bss+0x4d/0x8d [cfg80211]
Oct  4 15:26:15 localhost kernel: EAX: 00200200 EBX: f2779424 ECX: 00100100 EDX: f2779400
Oct  4 15:26:15 localhost kernel: ESI: f53a0180 EDI: f53a0000 EBP: f73d3ec4 ESP: f73d3eb0
Oct  4 15:26:15 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Oct  4 15:26:15 localhost kernel: Process kworker/u:2 (pid: 41, ti=f73d2000 task=f71272d0 task.ti=f73d2000)


(gdb) l *(cfg80211_unlink_bss+0x4d)
0x405c is in cfg80211_unlink_bss (/home/greearb/git/linux.wireless-testing/include/linux/list.h:89).
84	 * This is only for internal list manipulation where we know
85	 * the prev/next entries already!
86	 */
87	static inline void __list_del(struct list_head * prev, struct list_head * next)
88	{
89		next->prev = prev;
90		prev->next = next;
91	}
92	
93	/**


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

