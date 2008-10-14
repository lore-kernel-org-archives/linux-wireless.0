Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:55936 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYJNWHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 18:07:07 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register  access?
References: <87k5cm3ee2.fsf@denkblock.local>
	<alpine.LFD.2.00.0810052354000.3398@apollo>
	<87d4id3jmr.fsf@denkblock.local>
	<alpine.LFD.2.00.0810061614490.3166@apollo>
	<87skr8h1de.fsf@denkblock.local>
	<alpine.LFD.2.00.0810071946460.3166@apollo>
	<alpine.LFD.2.00.0810072042140.3166@apollo>
	<87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local>
	<alpine.LFD.2.00.0810082203360.3237@apollo>
	<alpine.LFD.2.00.0810091313380.3237@apollo>
	<87k5cgg87j.fsf@denkblock.local>
	<alpine.LFD.2.00.0810101127560.3271@apollo>
	<87abdck6sn.fsf@denkblock.local>
	<alpine.LFD.2.00.0810101432540.3271@apollo>
	<alpine.LFD.2.00.0810111149420.3356@apollo>
	<87k5ceeuxy.fsf@denkblock.local>
	<alpine.LFD.2.00.0810142054580.6848@apollo>
Date: Wed, 15 Oct 2008 00:01:03 +0200
Message-ID: <87skqyj0ps.fsf@denkblock.local> (sfid-20081015_000715_215830_38F88DA0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 11 Oct 2008, Elias Oltmanns wrote:
>> > Compile the acpi_processor module in to the kernel
>
>> > (CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
>> > command line. If I analysed the problem correctly this will make the
>> > jiffies problem go away. I'm working on a fix.
>> 
>> Spot on, it does go away regardless whether NO_HZ or HIGH_RES are
>> enabled or disabled. Looking forward to testing your fix ;-).
>
> Here you go.

Bad luck, I'm afraid. Your patch seems to fix the issue for NO_HZ=n +
HIGH_RES=y. As soon as NO_HZ=y, however, the problem reappears. See the
output below. (Still testing on 2.6.27, mind. Should I test something
more up-to-date?)

Regards,

Elias

--8<---------------dmesg---------------start------------->8---
Oct 14 22:44:25 denkblock kernel: [  150.063028] b:    150.062655731 n:    150.063022258 e: 4294952302 j: 4294952302
Oct 14 22:44:25 denkblock kernel: [  150.063035] Timer List Version: v0.3
Oct 14 22:44:25 denkblock kernel: [  150.063038] HRTIMER_MAX_CLOCK_BASES: 2
Oct 14 22:44:25 denkblock kernel: [  150.063041] now at 150063035109 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063043] 
Oct 14 22:44:25 denkblock kernel: [  150.063045] cpu: 0
Oct 14 22:44:25 denkblock kernel: [  150.063047]  clock 0:
Oct 14 22:44:25 denkblock kernel: [  150.063048]   .index:      0
Oct 14 22:44:25 denkblock kernel: [  150.063051]   .resolution: 10000000 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063053]   .get_time:   ktime_get_real
Oct 14 22:44:25 denkblock kernel: [  150.063062] active timers:
Oct 14 22:44:25 denkblock kernel: [  150.063064]  clock 1:
Oct 14 22:44:25 denkblock kernel: [  150.063066]   .index:      1
Oct 14 22:44:25 denkblock kernel: [  150.063068]   .resolution: 10000000 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063070]   .get_time:   ktime_get
Oct 14 22:44:25 denkblock kernel: [  150.063074] active timers:
Oct 14 22:44:25 denkblock kernel: [  150.063076]  #0: <c02e2f14>, hrtimer_wakeup, S:01, do_nanosleep, tail/2440
Oct 14 22:44:25 denkblock kernel: [  150.063098]  # expires at 150440037040 nsecs [in 377001931 nsecs]
Oct 14 22:44:25 denkblock kernel: [  150.063102]  #1: <c02e2f14>, it_real_fn, S:01, do_setitimer, syslogd/2343
Oct 14 22:44:25 denkblock kernel: [  150.063115]  # expires at 173530381509 nsecs [in 23467346400 nsecs]
Oct 14 22:44:25 denkblock kernel: [  150.063119]   .nohz_mode      : 1
Oct 14 22:44:25 denkblock kernel: [  150.063121]   .idle_tick      : 150030000000 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063124]   .tick_stopped   : 0
Oct 14 22:44:25 denkblock kernel: [  150.063126]   .idle_jiffies   : 4294952299
Oct 14 22:44:25 denkblock kernel: [  150.063129]   .idle_calls     : 21431
Oct 14 22:44:25 denkblock kernel: [  150.063132]   .idle_sleeps    : 16504
Oct 14 22:44:25 denkblock kernel: [  150.063134]   .idle_entrytime : 150063016112 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063137]   .idle_waketime  : 150040009551 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063140]   .idle_exittime  : 150062664671 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063143]   .idle_sleeptime : 138813566362 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063146]   .last_jiffies   : 4294952302
Oct 14 22:44:25 denkblock kernel: [  150.063148]   .next_jiffies   : 4294952302
Oct 14 22:44:25 denkblock kernel: [  150.063151]   .idle_expires   : 150040000000 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063154]   .last_events0   : 150010011037 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063157]   .last_events1   : 150020010914 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063159]   .last_events2   : 150040012344 nsecs
Oct 14 22:44:25 denkblock kernel: [  150.063162] jiffies: 4294952302
Oct 14 22:44:25 denkblock kernel: [  150.063164] 
Oct 14 22:44:25 denkblock kernel: [  150.063165] 
Oct 14 22:44:25 denkblock kernel: [  150.063167] Tick Device: mode:     1
Oct 14 22:44:25 denkblock kernel: [  150.063169] Clock Event Device: pit
Oct 14 22:44:26 denkblock kernel: [  150.063172]  max_delta_ns:   27461866
Oct 14 22:44:26 denkblock kernel: [  150.063175]  min_delta_ns:   12571
Oct 14 22:44:26 denkblock kernel: [  150.063177]  mult:           5124677
Oct 14 22:44:26 denkblock kernel: [  150.063179]  shift:          32
Oct 14 22:44:26 denkblock kernel: [  150.063181]  mode:           3
Oct 14 22:44:26 denkblock kernel: [  150.063184]  next_event:     9223372036854775807 nsecs
Oct 14 22:44:26 denkblock kernel: [  150.063187]  set_next_event: pit_next_event
Oct 14 22:44:26 denkblock kernel: [  150.063193]  set_mode:       init_pit_timer
Oct 14 22:44:26 denkblock kernel: [  150.063197]  event_handler:  tick_handle_oneshot_broadcast
Oct 14 22:44:26 denkblock kernel: [  150.063203] tick_broadcast_mask: 00000001
Oct 14 22:44:26 denkblock kernel: [  150.063205] tick_broadcast_oneshot_mask: 00000000
Oct 14 22:44:26 denkblock kernel: [  150.063208] 
Oct 14 22:44:26 denkblock kernel: [  150.063209] 
Oct 14 22:44:26 denkblock kernel: [  150.063211] Tick Device: mode:     1
Oct 14 22:44:26 denkblock kernel: [  150.063213] Clock Event Device: lapic
Oct 14 22:44:26 denkblock kernel: [  150.063216]  max_delta_ns:   1346509690
Oct 14 22:44:26 denkblock kernel: [  150.063218]  min_delta_ns:   2407
Oct 14 22:44:26 denkblock kernel: [  150.063221]  mult:           26757173
Oct 14 22:44:26 denkblock kernel: [  150.063223]  shift:          32
Oct 14 22:44:26 denkblock kernel: [  150.063225]  mode:           3
Oct 14 22:44:26 denkblock kernel: [  150.063227]  next_event:     150070000000 nsecs
Oct 14 22:44:26 denkblock kernel: [  150.063230]  set_next_event: lapic_next_event
Oct 14 22:44:26 denkblock kernel: [  150.063234]  set_mode:       lapic_timer_setup
Oct 14 22:44:26 denkblock kernel: [  150.063237]  event_handler:  tick_nohz_handler
Oct 14 22:44:26 denkblock kernel: [  150.063241] 
--8<---------------dmesg---------------end--------------->8---
