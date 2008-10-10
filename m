Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:39834 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJJIrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 04:47:17 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register  access?
Date: Fri, 10 Oct 2008 10:33:52 +0200
Message-ID: <87k5cgg87j.fsf@denkblock.local> (sfid-20081010_104731_070187_F26E5A2D)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 8 Oct 2008, Thomas Gleixner wrote:
>> There is no significant deviation between jiffies and ktime in the
>> debug output, but I noticed that you run with HZ=100, right ? So the
>> timeout you run is 100/50 = 2. I would have a reasonable explanation
>> if it would be 1, but I need to think about it more when I'm awake.
>
> I think I know what happens. Can you please apply the following debug
> patch and provide the output?

Just because I didn't quite get your meaning in your earlier email, I'd
like to avoid any misunderstanding and emphasise that NO_HZZ=off +
HIGH_RES=off doesn't triger the problem, whereas NO_HZ=off + HIGH_RES=on
does, as does NO_HZ=on + HIGH_RES=*. As for the HZ=100 vs HZ=250 issue,
it doesn't seem to make much difference. As you suggested, I've tested
HZ=250 now and as you can see below, the problem remains for NO_HZ=off +
HIGH_RES=on, and there still is no problem for both off (as expected).

Regards,

Elias

# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

--8<---------------dmesg---------------start------------->8---
Oct 10 09:31:51 denkblock kernel: [  109.748395] timer-test: module successfully loaded.
Oct 10 09:31:58 denkblock kernel: [  116.994178] NET: Registered protocol family 17
Oct 10 09:32:03 denkblock kernel: [  121.611352] ath0: associated
Oct 10 09:32:18 denkblock kernel: [  136.838264] b:    136.838234395 n:    136.838258980 e: 4294926505 j: 4294926505
Oct 10 09:32:18 denkblock kernel: [  136.838279] Timer List Version: v0.3
Oct 10 09:32:18 denkblock kernel: [  136.838281] HRTIMER_MAX_CLOCK_BASES: 2
Oct 10 09:32:18 denkblock kernel: [  136.838284] now at 136838278535 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838287] 
Oct 10 09:32:18 denkblock kernel: [  136.838288] cpu: 0
Oct 10 09:32:18 denkblock kernel: [  136.838290]  clock 0:
Oct 10 09:32:18 denkblock kernel: [  136.838292]   .index:      0
Oct 10 09:32:18 denkblock kernel: [  136.838294]   .resolution: 1 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838296]   .get_time:   ktime_get_real
Oct 10 09:32:18 denkblock kernel: [  136.838306]   .offset:     1223623801823575591 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838308] active timers:
Oct 10 09:32:18 denkblock kernel: [  136.838311]  clock 1:
Oct 10 09:32:18 denkblock kernel: [  136.838313]   .index:      1
Oct 10 09:32:18 denkblock kernel: [  136.838315]   .resolution: 1 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838317]   .get_time:   ktime_get
Oct 10 09:32:18 denkblock kernel: [  136.838321]   .offset:     0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838323] active timers:
Oct 10 09:32:18 denkblock kernel: [  136.838325]  #0: <c02e4f18>, tick_sched_timer, S:01, tick_setup_sched_timer, init/355
Oct 10 09:32:18 denkblock kernel: [  136.838346]  # expires at 136840000000 nsecs [in 1721465 nsecs]
Oct 10 09:32:18 denkblock kernel: [  136.838349]  #1: <c02e4f18>, hrtick, S:01, hrtick_start_fair, swapper/0
Oct 10 09:32:18 denkblock kernel: [  136.838360]  # expires at 136846115010 nsecs [in 7836475 nsecs]
Oct 10 09:32:18 denkblock kernel: [  136.838364]  #2: <c02e4f18>, hrtimer_wakeup, S:01, do_nanosleep, tail/2452
Oct 10 09:32:18 denkblock kernel: [  136.838375]  # expires at 137670518234 nsecs [in 832239699 nsecs]
Oct 10 09:32:18 denkblock kernel: [  136.838378]  #3: <c02e4f18>, it_real_fn, S:01, do_setitimer, syslogd/2356
Oct 10 09:32:18 denkblock kernel: [  136.838391]  # expires at 149813093733 nsecs [in 12974815198 nsecs]
Oct 10 09:32:18 denkblock kernel: [  136.838395]   .expires_next   : 136840000000 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838398]   .hres_active    : 1
Oct 10 09:32:18 denkblock kernel: [  136.838400]   .nr_events      : 34337
Oct 10 09:32:18 denkblock kernel: [  136.838403]   .nohz_mode      : 0
Oct 10 09:32:18 denkblock kernel: [  136.838405]   .idle_tick      : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838408]   .tick_stopped   : 0
Oct 10 09:32:18 denkblock kernel: [  136.838410]   .idle_jiffies   : 0
Oct 10 09:32:18 denkblock kernel: [  136.838412]   .idle_calls     : 0
Oct 10 09:32:18 denkblock kernel: [  136.838415]   .idle_sleeps    : 0
Oct 10 09:32:18 denkblock kernel: [  136.838417]   .idle_entrytime : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838419]   .idle_waketime  : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838422]   .idle_exittime  : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838424]   .idle_sleeptime : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838427]   .last_jiffies   : 0
Oct 10 09:32:18 denkblock kernel: [  136.838429]   .next_jiffies   : 0
Oct 10 09:32:18 denkblock kernel: [  136.838431]   .idle_expires   : 0 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838434]   .last_events0   : 136812009783 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838437]   .last_events1   : 136816009783 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838440]   .last_events2   : 136838253113 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838443] jiffies: 4294926505
Oct 10 09:32:18 denkblock kernel: [  136.838445] 
Oct 10 09:32:18 denkblock kernel: [  136.838446] 
Oct 10 09:32:18 denkblock kernel: [  136.838448] Tick Device: mode:     1
Oct 10 09:32:18 denkblock kernel: [  136.838450] Clock Event Device: pit
Oct 10 09:32:18 denkblock kernel: [  136.838454]  max_delta_ns:   27461866
Oct 10 09:32:18 denkblock kernel: [  136.838456]  min_delta_ns:   12571
Oct 10 09:32:18 denkblock kernel: [  136.838459]  mult:           5124677
Oct 10 09:32:18 denkblock kernel: [  136.838461]  shift:          32
Oct 10 09:32:18 denkblock kernel: [  136.838463]  mode:           3
Oct 10 09:32:18 denkblock kernel: [  136.838466]  next_event:     136840000000 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838468]  set_next_event: pit_next_event
Oct 10 09:32:18 denkblock kernel: [  136.838475]  set_mode:       init_pit_timer
Oct 10 09:32:18 denkblock kernel: [  136.838479]  event_handler:  tick_handle_oneshot_broadcast
Oct 10 09:32:18 denkblock kernel: [  136.838484] tick_broadcast_mask: 00000001
Oct 10 09:32:18 denkblock kernel: [  136.838487] tick_broadcast_oneshot_mask: 00000001
Oct 10 09:32:18 denkblock kernel: [  136.838489] 
Oct 10 09:32:18 denkblock kernel: [  136.838491] 
Oct 10 09:32:18 denkblock kernel: [  136.838492] Tick Device: mode:     1
Oct 10 09:32:18 denkblock kernel: [  136.838495] Clock Event Device: lapic
Oct 10 09:32:18 denkblock kernel: [  136.838498]  max_delta_ns:   1346535456
Oct 10 09:32:18 denkblock kernel: [  136.838500]  min_delta_ns:   2407
Oct 10 09:32:18 denkblock kernel: [  136.838503]  mult:           26756661
Oct 10 09:32:18 denkblock kernel: [  136.838505]  shift:          32
Oct 10 09:32:18 denkblock kernel: [  136.838507]  mode:           1
Oct 10 09:32:18 denkblock kernel: [  136.838510]  next_event:     136840000000 nsecs
Oct 10 09:32:18 denkblock kernel: [  136.838512]  set_next_event: lapic_next_event
Oct 10 09:32:18 denkblock kernel: [  136.838517]  set_mode:       lapic_timer_setup
Oct 10 09:32:18 denkblock kernel: [  136.838520]  event_handler:  hrtimer_interrupt
Oct 10 09:32:18 denkblock kernel: [  136.838524] 
Oct 10 09:32:28 denkblock kernel: [  146.839547] b:    146.839519211 n:    146.839541561 e: 4294929005 j: 4294929005
Oct 10 09:32:28 denkblock kernel: [  146.839555] Timer List Version: v0.3
Oct 10 09:32:28 denkblock kernel: [  146.839557] HRTIMER_MAX_CLOCK_BASES: 2
Oct 10 09:32:28 denkblock kernel: [  146.839560] now at 146839554691 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839563] 
Oct 10 09:32:28 denkblock kernel: [  146.839564] cpu: 0
Oct 10 09:32:28 denkblock kernel: [  146.839566]  clock 0:
Oct 10 09:32:28 denkblock kernel: [  146.839568]   .index:      0
Oct 10 09:32:28 denkblock kernel: [  146.839570]   .resolution: 1 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839572]   .get_time:   ktime_get_real
Oct 10 09:32:28 denkblock kernel: [  146.839583]   .offset:     1223623801823575591 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839585] active timers:
Oct 10 09:32:28 denkblock kernel: [  146.839588]  clock 1:
Oct 10 09:32:28 denkblock kernel: [  146.839590]   .index:      1
Oct 10 09:32:28 denkblock kernel: [  146.839592]   .resolution: 1 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839594]   .get_time:   ktime_get
Oct 10 09:32:28 denkblock kernel: [  146.839598]   .offset:     0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839600] active timers:
Oct 10 09:32:28 denkblock kernel: [  146.839602]  #0: <c02e4f18>, tick_sched_timer, S:01, tick_setup_sched_timer, init/355
Oct 10 09:32:28 denkblock kernel: [  146.839622]  # expires at 146840000000 nsecs [in 445309 nsecs]
Oct 10 09:32:28 denkblock kernel: [  146.839626]  #1: <c02e4f18>, hrtick, S:01, hrtick_start_fair, swapper/0
Oct 10 09:32:28 denkblock kernel: [  146.839637]  # expires at 146852790351 nsecs [in 13235660 nsecs]
Oct 10 09:32:28 denkblock kernel: [  146.839640]  #2: <c02e4f18>, hrtimer_wakeup, S:01, do_nanosleep, tail/2452
Oct 10 09:32:28 denkblock kernel: [  146.839652]  # expires at 147679722871 nsecs [in 840168180 nsecs]
Oct 10 09:32:28 denkblock kernel: [  146.839655]  #3: <c02e4f18>, it_real_fn, S:01, do_setitimer, syslogd/2356
Oct 10 09:32:28 denkblock kernel: [  146.839667]  # expires at 149813093733 nsecs [in 2973539042 nsecs]
Oct 10 09:32:28 denkblock kernel: [  146.839671]   .expires_next   : 146840000000 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839674]   .hres_active    : 1
Oct 10 09:32:28 denkblock kernel: [  146.839677]   .nr_events      : 36843
Oct 10 09:32:28 denkblock kernel: [  146.839679]   .nohz_mode      : 0
Oct 10 09:32:28 denkblock kernel: [  146.839681]   .idle_tick      : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839684]   .tick_stopped   : 0
Oct 10 09:32:28 denkblock kernel: [  146.839686]   .idle_jiffies   : 0
Oct 10 09:32:28 denkblock kernel: [  146.839688]   .idle_calls     : 0
Oct 10 09:32:28 denkblock kernel: [  146.839691]   .idle_sleeps    : 0
Oct 10 09:32:28 denkblock kernel: [  146.839693]   .idle_entrytime : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839695]   .idle_waketime  : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839698]   .idle_exittime  : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839700]   .idle_sleeptime : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839703]   .last_jiffies   : 0
Oct 10 09:32:28 denkblock kernel: [  146.839705]   .next_jiffies   : 0
Oct 10 09:32:28 denkblock kernel: [  146.839707]   .idle_expires   : 0 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839710]   .last_events0   : 146812009783 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839713]   .last_events1   : 146816009783 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839716]   .last_events2   : 146839535135 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839719] jiffies: 4294929005
Oct 10 09:32:28 denkblock kernel: [  146.839721] 
Oct 10 09:32:28 denkblock kernel: [  146.839722] 
Oct 10 09:32:28 denkblock kernel: [  146.839724] Tick Device: mode:     1
Oct 10 09:32:28 denkblock kernel: [  146.839726] Clock Event Device: pit
Oct 10 09:32:28 denkblock kernel: [  146.839730]  max_delta_ns:   27461866
Oct 10 09:32:28 denkblock kernel: [  146.839732]  min_delta_ns:   12571
Oct 10 09:32:28 denkblock kernel: [  146.839735]  mult:           5124677
Oct 10 09:32:28 denkblock kernel: [  146.839737]  shift:          32
Oct 10 09:32:28 denkblock kernel: [  146.839739]  mode:           3
Oct 10 09:32:28 denkblock kernel: [  146.839742]  next_event:     9223372036854775807 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839745]  set_next_event: pit_next_event
Oct 10 09:32:28 denkblock kernel: [  146.839752]  set_mode:       init_pit_timer
Oct 10 09:32:28 denkblock kernel: [  146.839757]  event_handler:  tick_handle_oneshot_broadcast
Oct 10 09:32:28 denkblock kernel: [  146.839762] tick_broadcast_mask: 00000001
Oct 10 09:32:28 denkblock kernel: [  146.839764] tick_broadcast_oneshot_mask: 00000000
Oct 10 09:32:28 denkblock kernel: [  146.839767] 
Oct 10 09:32:28 denkblock kernel: [  146.839768] 
Oct 10 09:32:28 denkblock kernel: [  146.839770] Tick Device: mode:     1
Oct 10 09:32:28 denkblock kernel: [  146.839772] Clock Event Device: lapic
Oct 10 09:32:28 denkblock kernel: [  146.839775]  max_delta_ns:   1346535456
Oct 10 09:32:28 denkblock kernel: [  146.839778]  min_delta_ns:   2407
Oct 10 09:32:28 denkblock kernel: [  146.839780]  mult:           26756661
Oct 10 09:32:28 denkblock kernel: [  146.839783]  shift:          32
Oct 10 09:32:28 denkblock kernel: [  146.839785]  mode:           3
Oct 10 09:32:28 denkblock kernel: [  146.839787]  next_event:     146840000000 nsecs
Oct 10 09:32:28 denkblock kernel: [  146.839790]  set_next_event: lapic_next_event
Oct 10 09:32:28 denkblock kernel: [  146.839794]  set_mode:       lapic_timer_setup
Oct 10 09:32:28 denkblock kernel: [  146.839798]  event_handler:  hrtimer_interrupt
Oct 10 09:32:28 denkblock kernel: [  146.839802] 
Oct 10 09:32:38 denkblock kernel: [  156.838299] b:    156.838280491 n:    156.838293621 e: 4294931505 j: 4294931505
Oct 10 09:32:38 denkblock kernel: [  156.838305] Timer List Version: v0.3
Oct 10 09:32:38 denkblock kernel: [  156.838308] HRTIMER_MAX_CLOCK_BASES: 2
Oct 10 09:32:38 denkblock kernel: [  156.838311] now at 156838305355 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838313] 
Oct 10 09:32:38 denkblock kernel: [  156.838315] cpu: 0
Oct 10 09:32:38 denkblock kernel: [  156.838317]  clock 0:
Oct 10 09:32:38 denkblock kernel: [  156.838319]   .index:      0
Oct 10 09:32:38 denkblock kernel: [  156.838321]   .resolution: 1 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838323]   .get_time:   ktime_get_real
Oct 10 09:32:38 denkblock kernel: [  156.838333]   .offset:     1223623801823575591 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838336] active timers:
Oct 10 09:32:38 denkblock kernel: [  156.838338]  clock 1:
Oct 10 09:32:38 denkblock kernel: [  156.838340]   .index:      1
Oct 10 09:32:38 denkblock kernel: [  156.838342]   .resolution: 1 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838344]   .get_time:   ktime_get
Oct 10 09:32:38 denkblock kernel: [  156.838348]   .offset:     0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838350] active timers:
Oct 10 09:32:38 denkblock kernel: [  156.838352]  #0: <c02e4f18>, tick_sched_timer, S:01, tick_setup_sched_timer, init/355
Oct 10 09:32:38 denkblock kernel: [  156.838373]  # expires at 156840000000 nsecs [in 1694645 nsecs]
Oct 10 09:32:38 denkblock kernel: [  156.838376]  #1: <c02e4f18>, it_real_fn, S:01, do_setitimer, syslogd/2356
Oct 10 09:32:38 denkblock kernel: [  156.838390]  # expires at 179813134800 nsecs [in 22974829445 nsecs]
Oct 10 09:32:38 denkblock kernel: [  156.838394]   .expires_next   : 156840000000 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838397]   .hres_active    : 1
Oct 10 09:32:38 denkblock kernel: [  156.838399]   .nr_events      : 39345
Oct 10 09:32:38 denkblock kernel: [  156.838402]   .nohz_mode      : 0
Oct 10 09:32:38 denkblock kernel: [  156.838404]   .idle_tick      : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838407]   .tick_stopped   : 0
Oct 10 09:32:38 denkblock kernel: [  156.838409]   .idle_jiffies   : 0
Oct 10 09:32:38 denkblock kernel: [  156.838411]   .idle_calls     : 0
Oct 10 09:32:38 denkblock kernel: [  156.838413]   .idle_sleeps    : 0
Oct 10 09:32:38 denkblock kernel: [  156.838416]   .idle_entrytime : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838418]   .idle_waketime  : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838420]   .idle_exittime  : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838423]   .idle_sleeptime : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838425]   .last_jiffies   : 0
Oct 10 09:32:38 denkblock kernel: [  156.838428]   .next_jiffies   : 0
Oct 10 09:32:38 denkblock kernel: [  156.838430]   .idle_expires   : 0 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838433]   .last_events0   : 156812009224 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838436]   .last_events1   : 156816010062 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838439]   .last_events2   : 156838287755 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838441] jiffies: 4294931505
Oct 10 09:32:38 denkblock kernel: [  156.838443] 
Oct 10 09:32:38 denkblock kernel: [  156.838445] 
Oct 10 09:32:38 denkblock kernel: [  156.838447] Tick Device: mode:     1
Oct 10 09:32:38 denkblock kernel: [  156.838449] Clock Event Device: pit
Oct 10 09:32:38 denkblock kernel: [  156.838452]  max_delta_ns:   27461866
Oct 10 09:32:38 denkblock kernel: [  156.838455]  min_delta_ns:   12571
Oct 10 09:32:38 denkblock kernel: [  156.838457]  mult:           5124677
Oct 10 09:32:38 denkblock kernel: [  156.838460]  shift:          32
Oct 10 09:32:38 denkblock kernel: [  156.838462]  mode:           3
Oct 10 09:32:38 denkblock kernel: [  156.838465]  next_event:     9223372036854775807 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838467]  set_next_event: pit_next_event
Oct 10 09:32:38 denkblock kernel: [  156.838474]  set_mode:       init_pit_timer
Oct 10 09:32:38 denkblock kernel: [  156.838479]  event_handler:  tick_handle_oneshot_broadcast
Oct 10 09:32:38 denkblock kernel: [  156.838484] tick_broadcast_mask: 00000001
Oct 10 09:32:38 denkblock kernel: [  156.838486] tick_broadcast_oneshot_mask: 00000000
Oct 10 09:32:38 denkblock kernel: [  156.838489] 
Oct 10 09:32:38 denkblock kernel: [  156.838490] 
Oct 10 09:32:38 denkblock kernel: [  156.838492] Tick Device: mode:     1
Oct 10 09:32:38 denkblock kernel: [  156.838494] Clock Event Device: lapic
Oct 10 09:32:38 denkblock kernel: [  156.838497]  max_delta_ns:   1346535456
Oct 10 09:32:38 denkblock kernel: [  156.838500]  min_delta_ns:   2407
Oct 10 09:32:38 denkblock kernel: [  156.838502]  mult:           26756661
Oct 10 09:32:38 denkblock kernel: [  156.838505]  shift:          32
Oct 10 09:32:38 denkblock kernel: [  156.838507]  mode:           3
Oct 10 09:32:38 denkblock kernel: [  156.838509]  next_event:     156840000000 nsecs
Oct 10 09:32:38 denkblock kernel: [  156.838512]  set_next_event: lapic_next_event
Oct 10 09:32:38 denkblock kernel: [  156.838516]  set_mode:       lapic_timer_setup
Oct 10 09:32:38 denkblock kernel: [  156.838520]  event_handler:  hrtimer_interrupt
Oct 10 09:32:38 denkblock kernel: [  156.838524] 
Oct 10 09:32:40 denkblock kernel: [  158.720450] ath0: deauthenticating by local choice (reason=3)
Oct 10 09:32:49 denkblock kernel: [  167.195292] tstm: module unloaded.
--8<---------------dmesg---------------end--------------->8---


>
> Thanks,
>
> 	tglx
>
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index 8cf8cfe..422b5f4 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -64,6 +64,9 @@ struct tick_sched {
>  	unsigned long			last_jiffies;
>  	unsigned long			next_jiffies;
>  	ktime_t				idle_expires;
> +	ktime_t				last_events0;
> +	ktime_t				last_events1;
> +	ktime_t				last_events2;
>  };
>  
>  extern void __init tick_init(void);
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index cb02324..ca7f38a 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -464,6 +464,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
>  
>  	dev->next_event.tv64 = KTIME_MAX;
>  
> +	ts->last_events0 = ts->last_events1;
> +	ts->last_events1 = ts->last_events2;
> +	ts->last_events2 = now;
> +
>  	/*
>  	 * Check if the do_timer duty was dropped. We don't care about
>  	 * concurrency: This happens only when the cpu in charge went
> @@ -565,6 +569,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
>  	ktime_t now = ktime_get();
>  	int cpu = smp_processor_id();
>  
> +	ts->last_events0 = ts->last_events1;
> +	ts->last_events1 = ts->last_events2;
> +	ts->last_events2 = now;
> +
>  #ifdef CONFIG_NO_HZ
>  	/*
>  	 * Check if the do_timer duty was dropped. We don't care about
> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index a40e20f..a086926 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -172,6 +172,9 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
>  		P(last_jiffies);
>  		P(next_jiffies);
>  		P_ns(idle_expires);
> +		P_ns(last_events0);
> +		P_ns(last_events1);
> +		P_ns(last_events2);
>  		SEQ_printf(m, "jiffies: %Lu\n",
>  			   (unsigned long long)jiffies);
>  	}
