Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:41372 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYJHLjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 07:39:45 -0400
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
	<87hc7ot804.fsf@denkblock.local>
Date: Wed, 08 Oct 2008 13:39:33 +0200
Message-ID: <87myhfnwne.fsf@denkblock.local> (sfid-20081008_133955_362820_15AB89BE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Elias Oltmanns <eo@nebensachen.de> wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
[...]
>> Some more questions:
>>
>> Does this happen with any on the combinations of highres/nohz
>> enabled/disabled ?
>
> From my tests in the past it would appear that NO_HZ enabled is the most
> important option to trigger the problem speedily. HIGHRES_TIMERS didn't
> seem to make much difference and I am quite sure that I observed this
> issue with NO_HZ disabled too, but very rarely. I'll keep testing and
> reporting. Meanwhile, ...

As it turns out, it is all a bit different: Yesterday, I tried for quite
some time to reproduce the problem on a system with both, NO_HZ and
HIGH_RES_TIMERS disabled, but in vain. All other combinations trigger
the described problem, so I have appended the requested data. There is
one more odd thing: with NO_HZ disabled and HIGH_RES_TIMERS enabled, I
cannot reliably associate with the AP (WPA encrypted). Still, the timer
issue remains as you can see below and I rather suspect that this is a
separate issue.

Regards,

Elias

--------

# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

--8<---------------/proc/timer_list---------------start------------->8---
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 67046247583 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1223456139058701991 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <df07aec0>, tick_sched_timer, S:01, tick_setup_sched_timer, modprobe/393
 # expires at 67050000000 nsecs [in 3752417 nsecs]
 #1: <df07aec0>, it_real_fn, S:01, do_setitimer, syslogd/2441
 # expires at 77308219646 nsecs [in 10261972063 nsecs]
  .expires_next   : 67050000000 nsecs
  .hres_active    : 1
  .nr_events      : 7039
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294944000


Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     67050000000 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   1346509690
 min_delta_ns:   2407
 mult:           26757173
 shift:          32
 mode:           3
 next_event:     67050000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
--8<---------------/proc/timer_list---------------end--------------->8---

--8<---------------dmesg---------------start------------->8---
Oct  8 10:56:52 denkblock kernel: [   73.677706] timer-test: module successfully loaded.
Oct  8 10:56:57 denkblock kernel: [   78.625713] NET: Registered protocol family 17
Oct  8 10:57:17 denkblock kernel: [   98.062731] b:     98.062701278 n:     98.062725024 e: 4294947102 j: 4294947102
Oct  8 10:57:17 denkblock kernel: [   98.062740] Timer List Version: v0.3
Oct  8 10:57:17 denkblock kernel: [   98.062743] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 10:57:17 denkblock kernel: [   98.062746] now at 98062739551 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062748] 
Oct  8 10:57:17 denkblock kernel: [   98.062751] cpu: 0
Oct  8 10:57:17 denkblock kernel: [   98.062753]  clock 0:
Oct  8 10:57:17 denkblock kernel: [   98.062755]   .index:      0
Oct  8 10:57:17 denkblock kernel: [   98.062757]   .resolution: 1 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062760]   .get_time:   ktime_get_real
Oct  8 10:57:17 denkblock kernel: [   98.062771]   .offset:     1223456139058701991 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062774] active timers:
Oct  8 10:57:17 denkblock kernel: [   98.062777]  clock 1:
Oct  8 10:57:17 denkblock kernel: [   98.062780]   .index:      1
Oct  8 10:57:17 denkblock kernel: [   98.062782]   .resolution: 1 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062784]   .get_time:   ktime_get
Oct  8 10:57:17 denkblock kernel: [   98.062790]   .offset:     0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062792] active timers:
Oct  8 10:57:17 denkblock kernel: [   98.062795]  #0: softirq_stack, hrtick, S:01, hrtick_start_fair, swapper/0
Oct  8 10:57:17 denkblock kernel: [   98.062813]  # expires at 98066760424 nsecs [in 4020873 nsecs]
Oct  8 10:57:17 denkblock kernel: [   98.062817]  #1: softirq_stack, tick_sched_timer, S:01, tick_setup_sched_timer, modprobe/393
Oct  8 10:57:17 denkblock kernel: [   98.062833]  # expires at 98070000000 nsecs [in 7260449 nsecs]
Oct  8 10:57:17 denkblock kernel: [   98.062836]  #2: softirq_stack, hrtimer_wakeup, S:01, do_nanosleep, tail/2542
Oct  8 10:57:17 denkblock kernel: [   98.062852]  # expires at 98998620540 nsecs [in 935880989 nsecs]
Oct  8 10:57:17 denkblock kernel: [   98.062856]  #3: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2441
Oct  8 10:57:17 denkblock kernel: [   98.062870]  # expires at 107308289209 nsecs [in 9245549658 nsecs]
Oct  8 10:57:17 denkblock kernel: [   98.062874]   .expires_next   : 98066760424 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062877]   .hres_active    : 1
Oct  8 10:57:17 denkblock kernel: [   98.062880]   .nr_events      : 10206
Oct  8 10:57:17 denkblock kernel: [   98.062883]   .nohz_mode      : 0
Oct  8 10:57:17 denkblock kernel: [   98.062886]   .idle_tick      : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062888]   .tick_stopped   : 0
Oct  8 10:57:17 denkblock kernel: [   98.062891]   .idle_jiffies   : 0
Oct  8 10:57:17 denkblock kernel: [   98.062893]   .idle_calls     : 0
Oct  8 10:57:17 denkblock kernel: [   98.062896]   .idle_sleeps    : 0
Oct  8 10:57:17 denkblock kernel: [   98.062898]   .idle_entrytime : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062901]   .idle_waketime  : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062904]   .idle_exittime  : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062907]   .idle_sleeptime : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062910]   .last_jiffies   : 0
Oct  8 10:57:17 denkblock kernel: [   98.062912]   .next_jiffies   : 0
Oct  8 10:57:17 denkblock kernel: [   98.062915]   .idle_expires   : 0 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062917] jiffies: 4294947102
Oct  8 10:57:17 denkblock kernel: [   98.062920] 
Oct  8 10:57:17 denkblock kernel: [   98.062921] 
Oct  8 10:57:17 denkblock kernel: [   98.062924] Tick Device: mode:     1
Oct  8 10:57:17 denkblock kernel: [   98.062926] Clock Event Device: pit
Oct  8 10:57:17 denkblock kernel: [   98.062930]  max_delta_ns:   27461866
Oct  8 10:57:17 denkblock kernel: [   98.062933]  min_delta_ns:   12571
Oct  8 10:57:17 denkblock kernel: [   98.062936]  mult:           5124677
Oct  8 10:57:17 denkblock kernel: [   98.062938]  shift:          32
Oct  8 10:57:17 denkblock kernel: [   98.062941]  mode:           3
Oct  8 10:57:17 denkblock kernel: [   98.062944]  next_event:     9223372036854775807 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062947]  set_next_event: pit_next_event
Oct  8 10:57:17 denkblock kernel: [   98.062954]  set_mode:       init_pit_timer
Oct  8 10:57:17 denkblock kernel: [   98.062960]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 10:57:17 denkblock kernel: [   98.062966] tick_broadcast_mask: 00000001
Oct  8 10:57:17 denkblock kernel: [   98.062969] tick_broadcast_oneshot_mask: 00000000
Oct  8 10:57:17 denkblock kernel: [   98.062971] 
Oct  8 10:57:17 denkblock kernel: [   98.062973] 
Oct  8 10:57:17 denkblock kernel: [   98.062975] Tick Device: mode:     1
Oct  8 10:57:17 denkblock kernel: [   98.062978] Clock Event Device: lapic
Oct  8 10:57:17 denkblock kernel: [   98.062981]  max_delta_ns:   1346509690
Oct  8 10:57:17 denkblock kernel: [   98.062984]  min_delta_ns:   2407
Oct  8 10:57:17 denkblock kernel: [   98.062987]  mult:           26757173
Oct  8 10:57:17 denkblock kernel: [   98.062990]  shift:          32
Oct  8 10:57:17 denkblock kernel: [   98.062992]  mode:           3
Oct  8 10:57:17 denkblock kernel: [   98.062995]  next_event:     98066760424 nsecs
Oct  8 10:57:17 denkblock kernel: [   98.062998]  set_next_event: lapic_next_event
Oct  8 10:57:17 denkblock kernel: [   98.063003]  set_mode:       lapic_timer_setup
Oct  8 10:57:17 denkblock kernel: [   98.063008]  event_handler:  hrtimer_interrupt
Oct  8 10:57:17 denkblock kernel: [   98.063013] 
Oct  8 10:57:37 denkblock kernel: [  118.064044] b:    118.064013752 n:    118.064037777 e: 4294949102 j: 4294949102
Oct  8 10:57:37 denkblock kernel: [  118.064053] Timer List Version: v0.3
Oct  8 10:57:37 denkblock kernel: [  118.064056] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 10:57:37 denkblock kernel: [  118.064059] now at 118064052584 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064062] 
Oct  8 10:57:37 denkblock kernel: [  118.064064] cpu: 0
Oct  8 10:57:37 denkblock kernel: [  118.064066]  clock 0:
Oct  8 10:57:37 denkblock kernel: [  118.064068]   .index:      0
Oct  8 10:57:37 denkblock kernel: [  118.064071]   .resolution: 1 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064073]   .get_time:   ktime_get_real
Oct  8 10:57:37 denkblock kernel: [  118.064085]   .offset:     1223456139058701991 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064088] active timers:
Oct  8 10:57:37 denkblock kernel: [  118.064091]  clock 1:
Oct  8 10:57:37 denkblock kernel: [  118.064093]   .index:      1
Oct  8 10:57:37 denkblock kernel: [  118.064096]   .resolution: 1 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064098]   .get_time:   ktime_get
Oct  8 10:57:37 denkblock kernel: [  118.064103]   .offset:     0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064106] active timers:
Oct  8 10:57:37 denkblock kernel: [  118.064109]  #0: softirq_stack, tick_sched_timer, S:01, tick_setup_sched_timer, modprobe/393
Oct  8 10:57:37 denkblock kernel: [  118.064128]  # expires at 118070000000 nsecs [in 5947416 nsecs]
Oct  8 10:57:37 denkblock kernel: [  118.064132]  #1: softirq_stack, hrtick, S:01, hrtick_start_fair, swapper/0
Oct  8 10:57:37 denkblock kernel: [  118.064147]  # expires at 118077280701 nsecs [in 13228117 nsecs]
Oct  8 10:57:37 denkblock kernel: [  118.064150]  #2: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2441
Oct  8 10:57:37 denkblock kernel: [  118.064164]  # expires at 137327440208 nsecs [in 19263387624 nsecs]
Oct  8 10:57:37 denkblock kernel: [  118.064169]   .expires_next   : 118070000000 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064172]   .hres_active    : 1
Oct  8 10:57:37 denkblock kernel: [  118.064174]   .nr_events      : 12269
Oct  8 10:57:37 denkblock kernel: [  118.064177]   .nohz_mode      : 0
Oct  8 10:57:37 denkblock kernel: [  118.064180]   .idle_tick      : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064183]   .tick_stopped   : 0
Oct  8 10:57:37 denkblock kernel: [  118.064185]   .idle_jiffies   : 0
Oct  8 10:57:37 denkblock kernel: [  118.064188]   .idle_calls     : 0
Oct  8 10:57:37 denkblock kernel: [  118.064190]   .idle_sleeps    : 0
Oct  8 10:57:37 denkblock kernel: [  118.064193]   .idle_entrytime : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064196]   .idle_waketime  : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064199]   .idle_exittime  : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064201]   .idle_sleeptime : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064204]   .last_jiffies   : 0
Oct  8 10:57:37 denkblock kernel: [  118.064207]   .next_jiffies   : 0
Oct  8 10:57:37 denkblock kernel: [  118.064209]   .idle_expires   : 0 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064212] jiffies: 4294949102
Oct  8 10:57:37 denkblock kernel: [  118.064214] 
Oct  8 10:57:37 denkblock kernel: [  118.064216] 
Oct  8 10:57:37 denkblock kernel: [  118.064218] Tick Device: mode:     1
Oct  8 10:57:37 denkblock kernel: [  118.064221] Clock Event Device: pit
Oct  8 10:57:37 denkblock kernel: [  118.064225]  max_delta_ns:   27461866
Oct  8 10:57:37 denkblock kernel: [  118.064228]  min_delta_ns:   12571
Oct  8 10:57:37 denkblock kernel: [  118.064230]  mult:           5124677
Oct  8 10:57:37 denkblock kernel: [  118.064233]  shift:          32
Oct  8 10:57:37 denkblock kernel: [  118.064235]  mode:           3
Oct  8 10:57:37 denkblock kernel: [  118.064239]  next_event:     9223372036854775807 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064241]  set_next_event: pit_next_event
Oct  8 10:57:37 denkblock kernel: [  118.064249]  set_mode:       init_pit_timer
Oct  8 10:57:37 denkblock kernel: [  118.064254]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 10:57:37 denkblock kernel: [  118.064260] tick_broadcast_mask: 00000001
Oct  8 10:57:37 denkblock kernel: [  118.064263] tick_broadcast_oneshot_mask: 00000000
Oct  8 10:57:37 denkblock kernel: [  118.064266] 
Oct  8 10:57:37 denkblock kernel: [  118.064268] 
Oct  8 10:57:37 denkblock kernel: [  118.064270] Tick Device: mode:     1
Oct  8 10:57:37 denkblock kernel: [  118.064272] Clock Event Device: lapic
Oct  8 10:57:37 denkblock kernel: [  118.064276]  max_delta_ns:   1346509690
Oct  8 10:57:37 denkblock kernel: [  118.064279]  min_delta_ns:   2407
Oct  8 10:57:37 denkblock kernel: [  118.064281]  mult:           26757173
Oct  8 10:57:37 denkblock kernel: [  118.064284]  shift:          32
Oct  8 10:57:37 denkblock kernel: [  118.064287]  mode:           3
Oct  8 10:57:37 denkblock kernel: [  118.064289]  next_event:     118070000000 nsecs
Oct  8 10:57:37 denkblock kernel: [  118.064292]  set_next_event: lapic_next_event
Oct  8 10:57:37 denkblock kernel: [  118.064298]  set_mode:       lapic_timer_setup
Oct  8 10:57:37 denkblock kernel: [  118.064303]  event_handler:  hrtimer_interrupt
Oct  8 10:57:37 denkblock kernel: [  118.064308] 
Oct  8 10:57:57 denkblock kernel: [  138.064041] b:    138.064013472 n:    138.064034984 e: 4294951102 j: 4294951102
Oct  8 10:57:57 denkblock kernel: [  138.064049] Timer List Version: v0.3
Oct  8 10:57:57 denkblock kernel: [  138.064052] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 10:57:57 denkblock kernel: [  138.064055] now at 138064048673 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064058] 
Oct  8 10:57:57 denkblock kernel: [  138.064060] cpu: 0
Oct  8 10:57:57 denkblock kernel: [  138.064062]  clock 0:
Oct  8 10:57:57 denkblock kernel: [  138.064064]   .index:      0
Oct  8 10:57:57 denkblock kernel: [  138.064067]   .resolution: 1 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064070]   .get_time:   ktime_get_real
Oct  8 10:57:57 denkblock kernel: [  138.064081]   .offset:     1223456139058701991 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064084] active timers:
Oct  8 10:57:57 denkblock kernel: [  138.064087]  clock 1:
Oct  8 10:57:57 denkblock kernel: [  138.064090]   .index:      1
Oct  8 10:57:57 denkblock kernel: [  138.064092]   .resolution: 1 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064094]   .get_time:   ktime_get
Oct  8 10:57:57 denkblock kernel: [  138.064100]   .offset:     0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064102] active timers:
Oct  8 10:57:57 denkblock kernel: [  138.064105]  #0: softirq_stack, hrtick, S:01, hrtick_start_fair, swapper/0
Oct  8 10:57:57 denkblock kernel: [  138.064123]  # expires at 138068961552 nsecs [in 4912879 nsecs]
Oct  8 10:57:57 denkblock kernel: [  138.064127]  #1: softirq_stack, tick_sched_timer, S:01, tick_setup_sched_timer, modprobe/393
Oct  8 10:57:57 denkblock kernel: [  138.064143]  # expires at 138070000000 nsecs [in 5951327 nsecs]
Oct  8 10:57:57 denkblock kernel: [  138.064147]  #2: softirq_stack, hrtimer_wakeup, S:01, do_nanosleep, tail/2542
Oct  8 10:57:57 denkblock kernel: [  138.064163]  # expires at 138157525136 nsecs [in 93476463 nsecs]
Oct  8 10:57:57 denkblock kernel: [  138.064166]  #3: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2441
Oct  8 10:57:57 denkblock kernel: [  138.064180]  # expires at 167327501110 nsecs [in 29263452437 nsecs]
Oct  8 10:57:57 denkblock kernel: [  138.064185]   .expires_next   : 138068961552 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064188]   .hres_active    : 1
Oct  8 10:57:57 denkblock kernel: [  138.064190]   .nr_events      : 14329
Oct  8 10:57:57 denkblock kernel: [  138.064193]   .nohz_mode      : 0
Oct  8 10:57:57 denkblock kernel: [  138.064196]   .idle_tick      : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064199]   .tick_stopped   : 0
Oct  8 10:57:57 denkblock kernel: [  138.064201]   .idle_jiffies   : 0
Oct  8 10:57:57 denkblock kernel: [  138.064204]   .idle_calls     : 0
Oct  8 10:57:57 denkblock kernel: [  138.064206]   .idle_sleeps    : 0
Oct  8 10:57:57 denkblock kernel: [  138.064209]   .idle_entrytime : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064212]   .idle_waketime  : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064215]   .idle_exittime  : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064218]   .idle_sleeptime : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064220]   .last_jiffies   : 0
Oct  8 10:57:57 denkblock kernel: [  138.064223]   .next_jiffies   : 0
Oct  8 10:57:57 denkblock kernel: [  138.064225]   .idle_expires   : 0 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064228] jiffies: 4294951102
Oct  8 10:57:57 denkblock kernel: [  138.064230] 
Oct  8 10:57:57 denkblock kernel: [  138.064232] 
Oct  8 10:57:57 denkblock kernel: [  138.064234] Tick Device: mode:     1
Oct  8 10:57:57 denkblock kernel: [  138.064237] Clock Event Device: pit
Oct  8 10:57:57 denkblock kernel: [  138.064241]  max_delta_ns:   27461866
Oct  8 10:57:57 denkblock kernel: [  138.064244]  min_delta_ns:   12571
Oct  8 10:57:57 denkblock kernel: [  138.064247]  mult:           5124677
Oct  8 10:57:57 denkblock kernel: [  138.064249]  shift:          32
Oct  8 10:57:57 denkblock kernel: [  138.064252]  mode:           3
Oct  8 10:57:57 denkblock kernel: [  138.064255]  next_event:     9223372036854775807 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064258]  set_next_event: pit_next_event
Oct  8 10:57:57 denkblock kernel: [  138.064265]  set_mode:       init_pit_timer
Oct  8 10:57:57 denkblock kernel: [  138.064271]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 10:57:57 denkblock kernel: [  138.064277] tick_broadcast_mask: 00000001
Oct  8 10:57:57 denkblock kernel: [  138.064280] tick_broadcast_oneshot_mask: 00000000
Oct  8 10:57:57 denkblock kernel: [  138.064282] 
Oct  8 10:57:57 denkblock kernel: [  138.064284] 
Oct  8 10:57:57 denkblock kernel: [  138.064286] Tick Device: mode:     1
Oct  8 10:57:57 denkblock kernel: [  138.064289] Clock Event Device: lapic
Oct  8 10:57:57 denkblock kernel: [  138.064292]  max_delta_ns:   1346509690
Oct  8 10:57:57 denkblock kernel: [  138.064295]  min_delta_ns:   2407
Oct  8 10:57:57 denkblock kernel: [  138.064298]  mult:           26757173
Oct  8 10:57:57 denkblock kernel: [  138.064301]  shift:          32
Oct  8 10:57:57 denkblock kernel: [  138.064303]  mode:           3
Oct  8 10:57:57 denkblock kernel: [  138.064306]  next_event:     138068961552 nsecs
Oct  8 10:57:57 denkblock kernel: [  138.064309]  set_next_event: lapic_next_event
Oct  8 10:57:57 denkblock kernel: [  138.064314]  set_mode:       lapic_timer_setup
Oct  8 10:57:57 denkblock kernel: [  138.064319]  event_handler:  hrtimer_interrupt
Oct  8 10:57:57 denkblock kernel: [  138.064324] 
Oct  8 10:58:07 denkblock kernel: [  148.064037] b:    148.064007606 n:    148.064029676 e: 4294952102 j: 4294952102
Oct  8 10:58:07 denkblock kernel: [  148.064045] Timer List Version: v0.3
Oct  8 10:58:07 denkblock kernel: [  148.064048] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 10:58:07 denkblock kernel: [  148.064051] now at 148064045041 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064054] 
Oct  8 10:58:07 denkblock kernel: [  148.064057] cpu: 0
Oct  8 10:58:07 denkblock kernel: [  148.064059]  clock 0:
Oct  8 10:58:07 denkblock kernel: [  148.064061]   .index:      0
Oct  8 10:58:07 denkblock kernel: [  148.064064]   .resolution: 1 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064066]   .get_time:   ktime_get_real
Oct  8 10:58:07 denkblock kernel: [  148.064078]   .offset:     1223456139058701991 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064081] active timers:
Oct  8 10:58:07 denkblock kernel: [  148.064084]  clock 1:
Oct  8 10:58:07 denkblock kernel: [  148.064086]   .index:      1
Oct  8 10:58:07 denkblock kernel: [  148.064089]   .resolution: 1 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064091]   .get_time:   ktime_get
Oct  8 10:58:07 denkblock kernel: [  148.064097]   .offset:     0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064099] active timers:
Oct  8 10:58:07 denkblock kernel: [  148.064102]  #0: softirq_stack, tick_sched_timer, S:01, tick_setup_sched_timer, modprobe/393
Oct  8 10:58:07 denkblock kernel: [  148.064121]  # expires at 148070000000 nsecs [in 5954959 nsecs]
Oct  8 10:58:07 denkblock kernel: [  148.064125]  #1: softirq_stack, hrtick, S:01, hrtick_start_fair, swapper/0
Oct  8 10:58:07 denkblock kernel: [  148.064141]  # expires at 148074015223 nsecs [in 9970182 nsecs]
Oct  8 10:58:07 denkblock kernel: [  148.064145]  #2: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2441
Oct  8 10:58:07 denkblock kernel: [  148.064158]  # expires at 167327501110 nsecs [in 19263456069 nsecs]
Oct  8 10:58:07 denkblock kernel: [  148.064163]   .expires_next   : 148070000000 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064166]   .hres_active    : 1
Oct  8 10:58:07 denkblock kernel: [  148.064169]   .nr_events      : 15358
Oct  8 10:58:07 denkblock kernel: [  148.064172]   .nohz_mode      : 0
Oct  8 10:58:07 denkblock kernel: [  148.064174]   .idle_tick      : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064177]   .tick_stopped   : 0
Oct  8 10:58:07 denkblock kernel: [  148.064180]   .idle_jiffies   : 0
Oct  8 10:58:07 denkblock kernel: [  148.064182]   .idle_calls     : 0
Oct  8 10:58:07 denkblock kernel: [  148.064185]   .idle_sleeps    : 0
Oct  8 10:58:07 denkblock kernel: [  148.064187]   .idle_entrytime : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064190]   .idle_waketime  : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064193]   .idle_exittime  : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064196]   .idle_sleeptime : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064198]   .last_jiffies   : 0
Oct  8 10:58:07 denkblock kernel: [  148.064201]   .next_jiffies   : 0
Oct  8 10:58:07 denkblock kernel: [  148.064204]   .idle_expires   : 0 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064206] jiffies: 4294952102
Oct  8 10:58:07 denkblock kernel: [  148.064209] 
Oct  8 10:58:07 denkblock kernel: [  148.064210] 
Oct  8 10:58:07 denkblock kernel: [  148.064213] Tick Device: mode:     1
Oct  8 10:58:07 denkblock kernel: [  148.064215] Clock Event Device: pit
Oct  8 10:58:07 denkblock kernel: [  148.064219]  max_delta_ns:   27461866
Oct  8 10:58:07 denkblock kernel: [  148.064222]  min_delta_ns:   12571
Oct  8 10:58:07 denkblock kernel: [  148.064224]  mult:           5124677
Oct  8 10:58:07 denkblock kernel: [  148.064227]  shift:          32
Oct  8 10:58:07 denkblock kernel: [  148.064230]  mode:           3
Oct  8 10:58:07 denkblock kernel: [  148.064233]  next_event:     9223372036854775807 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064236]  set_next_event: pit_next_event
Oct  8 10:58:07 denkblock kernel: [  148.064243]  set_mode:       init_pit_timer
Oct  8 10:58:07 denkblock kernel: [  148.064248]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 10:58:07 denkblock kernel: [  148.064255] tick_broadcast_mask: 00000001
Oct  8 10:58:07 denkblock kernel: [  148.064258] tick_broadcast_oneshot_mask: 00000000
Oct  8 10:58:07 denkblock kernel: [  148.064261] 
Oct  8 10:58:07 denkblock kernel: [  148.064262] 
Oct  8 10:58:07 denkblock kernel: [  148.064265] Tick Device: mode:     1
Oct  8 10:58:07 denkblock kernel: [  148.064267] Clock Event Device: lapic
Oct  8 10:58:07 denkblock kernel: [  148.064271]  max_delta_ns:   1346509690
Oct  8 10:58:07 denkblock kernel: [  148.064273]  min_delta_ns:   2407
Oct  8 10:58:07 denkblock kernel: [  148.064276]  mult:           26757173
Oct  8 10:58:07 denkblock kernel: [  148.064279]  shift:          32
Oct  8 10:58:07 denkblock kernel: [  148.064281]  mode:           3
Oct  8 10:58:07 denkblock kernel: [  148.064284]  next_event:     148070000000 nsecs
Oct  8 10:58:07 denkblock kernel: [  148.064287]  set_next_event: lapic_next_event
Oct  8 10:58:07 denkblock kernel: [  148.064293]  set_mode:       lapic_timer_setup
Oct  8 10:58:07 denkblock kernel: [  148.064298]  event_handler:  hrtimer_interrupt
Oct  8 10:58:07 denkblock kernel: [  148.064303] 
Oct  8 10:58:49 denkblock kernel: [  190.237540] tstm: module unloaded.
--8<---------------dmesg---------------end--------------->8---

CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

--8<---------------/proc/timer_list---------------start------------->8---
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 92466531281 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1223464145158820160 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <df19bec0>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 92470000000 nsecs [in 3468719 nsecs]
 #1: <df19bec0>, it_real_fn, S:01, do_setitimer, syslogd/2439
 # expires at 120911077291 nsecs [in 28444546010 nsecs]
  .expires_next   : 92470000000 nsecs
  .hres_active    : 1
  .nr_events      : 3400
  .nohz_mode      : 2
  .idle_tick      : 92440000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294946539
  .idle_calls     : 14205
  .idle_sleeps    : 10925
  .idle_entrytime : 92457842744 nsecs
  .idle_waketime  : 92464993097 nsecs
  .idle_exittime  : 92465047014 nsecs
  .idle_sleeptime : 81875451152 nsecs
  .last_jiffies   : 4294946541
  .next_jiffies   : 4294946543
  .idle_expires   : 92470000000 nsecs
jiffies: 4294946542


Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     92470000000 nsecs
 set_next_event: pit_next_event
 set_mode:       init_pit_timer
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000001
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   1346509690
 min_delta_ns:   2407
 mult:           26757173
 shift:          32
 mode:           3
 next_event:     92470000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

--8<---------------/proc/timer_list---------------end--------------->8---

--8<---------------dmesg---------------start------------->8---
Oct  8 13:10:48 denkblock kernel: [  103.490553] timer-test: module successfully loaded.
Oct  8 13:10:55 denkblock kernel: [  110.084616] NET: Registered protocol family 17
[Associate with AP]
Oct  8 13:12:35 denkblock kernel: [  210.062290] b:    210.062258000 n:    210.062284260 e: 4294958302 j: 4294958302
Oct  8 13:12:35 denkblock kernel: [  210.062297] Timer List Version: v0.3
Oct  8 13:12:35 denkblock kernel: [  210.062300] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 13:12:35 denkblock kernel: [  210.062303] now at 210062297111 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062306] 
Oct  8 13:12:35 denkblock kernel: [  210.062308] cpu: 0
Oct  8 13:12:35 denkblock kernel: [  210.062310]  clock 0:
Oct  8 13:12:35 denkblock kernel: [  210.062312]   .index:      0
Oct  8 13:12:35 denkblock kernel: [  210.062315]   .resolution: 1 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062317]   .get_time:   ktime_get_real
Oct  8 13:12:35 denkblock kernel: [  210.062330]   .offset:     1223464145147675602 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062332] active timers:
Oct  8 13:12:35 denkblock kernel: [  210.062335]  clock 1:
Oct  8 13:12:35 denkblock kernel: [  210.062338]   .index:      1
Oct  8 13:12:35 denkblock kernel: [  210.062340]   .resolution: 1 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062342]   .get_time:   ktime_get
Oct  8 13:12:35 denkblock kernel: [  210.062348]   .offset:     0 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062350] active timers:
Oct  8 13:12:35 denkblock kernel: [  210.062353]  #0: softirq_stack, hrtick, S:01, hrtick_start_fair, events/0/4
Oct  8 13:12:35 denkblock kernel: [  210.062371]  # expires at 210064209333 nsecs [in 1912222 nsecs]
Oct  8 13:12:35 denkblock kernel: [  210.062375]  #1: softirq_stack, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
Oct  8 13:12:35 denkblock kernel: [  210.062391]  # expires at 210070000000 nsecs [in 7702889 nsecs]
Oct  8 13:12:35 denkblock kernel: [  210.062394]  #2: softirq_stack, hrtimer_wakeup, S:01, do_nanosleep, tail/2537
Oct  8 13:12:35 denkblock kernel: [  210.062410]  # expires at 210767716572 nsecs [in 705419461 nsecs]
Oct  8 13:12:35 denkblock kernel: [  210.062414]  #3: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2439
Oct  8 13:12:35 denkblock kernel: [  210.062427]  # expires at 210911270052 nsecs [in 848972941 nsecs]
Oct  8 13:12:35 denkblock kernel: [  210.062432]   .expires_next   : 210064209333 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062435]   .hres_active    : 1
Oct  8 13:12:35 denkblock kernel: [  210.062438]   .nr_events      : 10923
Oct  8 13:12:35 denkblock kernel: [  210.062440]   .nohz_mode      : 2
Oct  8 13:12:35 denkblock kernel: [  210.062443]   .idle_tick      : 210030000000 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062446]   .tick_stopped   : 0
Oct  8 13:12:35 denkblock kernel: [  210.062449]   .idle_jiffies   : 4294958298
Oct  8 13:12:35 denkblock kernel: [  210.062452]   .idle_calls     : 32020
Oct  8 13:12:35 denkblock kernel: [  210.062454]   .idle_sleeps    : 23265
Oct  8 13:12:35 denkblock kernel: [  210.062457]   .idle_entrytime : 210032869899 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062461]   .idle_waketime  : 210032831905 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062464]   .idle_exittime  : 210032853416 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062467]   .idle_sleeptime : 195265042635 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062470]   .last_jiffies   : 4294958299
Oct  8 13:12:35 denkblock kernel: [  210.062473]   .next_jiffies   : 4294958300
Oct  8 13:12:35 denkblock kernel: [  210.062476]   .idle_expires   : 210040000000 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062479] jiffies: 4294958302
Oct  8 13:12:35 denkblock kernel: [  210.062481] 
Oct  8 13:12:35 denkblock kernel: [  210.062483] 
Oct  8 13:12:35 denkblock kernel: [  210.062485] Tick Device: mode:     1
Oct  8 13:12:35 denkblock kernel: [  210.062487] Clock Event Device: pit
Oct  8 13:12:35 denkblock kernel: [  210.062491]  max_delta_ns:   27461866
Oct  8 13:12:35 denkblock kernel: [  210.062494]  min_delta_ns:   12571
Oct  8 13:12:35 denkblock kernel: [  210.062497]  mult:           5124677
Oct  8 13:12:35 denkblock kernel: [  210.062499]  shift:          32
Oct  8 13:12:35 denkblock kernel: [  210.062502]  mode:           3
Oct  8 13:12:35 denkblock kernel: [  210.062505]  next_event:     9223372036854775807 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062507]  set_next_event: pit_next_event
Oct  8 13:12:35 denkblock kernel: [  210.062515]  set_mode:       init_pit_timer
Oct  8 13:12:35 denkblock kernel: [  210.062520]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 13:12:35 denkblock kernel: [  210.062526] tick_broadcast_mask: 00000001
Oct  8 13:12:35 denkblock kernel: [  210.062529] tick_broadcast_oneshot_mask: 00000000
Oct  8 13:12:35 denkblock kernel: [  210.062531] 
Oct  8 13:12:35 denkblock kernel: [  210.062533] 
Oct  8 13:12:35 denkblock kernel: [  210.062535] Tick Device: mode:     1
Oct  8 13:12:35 denkblock kernel: [  210.062537] Clock Event Device: lapic
Oct  8 13:12:35 denkblock kernel: [  210.062541]  max_delta_ns:   1346509690
Oct  8 13:12:35 denkblock kernel: [  210.062544]  min_delta_ns:   2407
Oct  8 13:12:35 denkblock kernel: [  210.062546]  mult:           26757173
Oct  8 13:12:35 denkblock kernel: [  210.062549]  shift:          32
Oct  8 13:12:35 denkblock kernel: [  210.062551]  mode:           3
Oct  8 13:12:35 denkblock kernel: [  210.062554]  next_event:     210064209333 nsecs
Oct  8 13:12:35 denkblock kernel: [  210.062557]  set_next_event: lapic_next_event
Oct  8 13:12:35 denkblock kernel: [  210.062562]  set_mode:       lapic_timer_setup
Oct  8 13:12:35 denkblock kernel: [  210.062567]  event_handler:  hrtimer_interrupt
Oct  8 13:12:35 denkblock kernel: [  210.062572] 
Oct  8 13:13:05 denkblock kernel: [  240.062779] b:    240.062741022 n:    240.062773428 e: 4294961302 j: 4294961302
Oct  8 13:13:05 denkblock kernel: [  240.062786] Timer List Version: v0.3
Oct  8 13:13:05 denkblock kernel: [  240.062789] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 13:13:05 denkblock kernel: [  240.062792] now at 240062786000 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062795] 
Oct  8 13:13:05 denkblock kernel: [  240.062797] cpu: 0
Oct  8 13:13:05 denkblock kernel: [  240.062799]  clock 0:
Oct  8 13:13:05 denkblock kernel: [  240.062801]   .index:      0
Oct  8 13:13:05 denkblock kernel: [  240.062804]   .resolution: 1 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062806]   .get_time:   ktime_get_real
Oct  8 13:13:05 denkblock kernel: [  240.062818]   .offset:     1223464145147675602 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062820] active timers:
Oct  8 13:13:05 denkblock kernel: [  240.062823]  clock 1:
Oct  8 13:13:05 denkblock kernel: [  240.062826]   .index:      1
Oct  8 13:13:05 denkblock kernel: [  240.062828]   .resolution: 1 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062830]   .get_time:   ktime_get
Oct  8 13:13:05 denkblock kernel: [  240.062836]   .offset:     0 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062838] active timers:
Oct  8 13:13:05 denkblock kernel: [  240.062841]  #0: softirq_stack, hrtick, S:01, hrtick_start_fair, events/0/4
Oct  8 13:13:05 denkblock kernel: [  240.062859]  # expires at 240064208834 nsecs [in 1422834 nsecs]
Oct  8 13:13:05 denkblock kernel: [  240.062863]  #1: softirq_stack, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
Oct  8 13:13:05 denkblock kernel: [  240.062879]  # expires at 240070000000 nsecs [in 7214000 nsecs]
Oct  8 13:13:05 denkblock kernel: [  240.062882]  #2: softirq_stack, hrtimer_wakeup, S:01, do_nanosleep, tail/2537
Oct  8 13:13:05 denkblock kernel: [  240.062898]  # expires at 240779253796 nsecs [in 716467796 nsecs]
Oct  8 13:13:05 denkblock kernel: [  240.062902]  #3: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2439
Oct  8 13:13:05 denkblock kernel: [  240.062915]  # expires at 240911335424 nsecs [in 848549424 nsecs]
Oct  8 13:13:05 denkblock kernel: [  240.062919]   .expires_next   : 240064208834 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062922]   .hres_active    : 1
Oct  8 13:13:05 denkblock kernel: [  240.062925]   .nr_events      : 12900
Oct  8 13:13:05 denkblock kernel: [  240.062928]   .nohz_mode      : 2
Oct  8 13:13:05 denkblock kernel: [  240.062931]   .idle_tick      : 240030000000 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062934]   .tick_stopped   : 0
Oct  8 13:13:05 denkblock kernel: [  240.062937]   .idle_jiffies   : 4294961298
Oct  8 13:13:05 denkblock kernel: [  240.062939]   .idle_calls     : 36766
Oct  8 13:13:05 denkblock kernel: [  240.062942]   .idle_sleeps    : 26548
Oct  8 13:13:05 denkblock kernel: [  240.062945]   .idle_entrytime : 240036511983 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062948]   .idle_waketime  : 240036475107 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062951]   .idle_exittime  : 240036495500 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062955]   .idle_sleeptime : 224964920586 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062958]   .last_jiffies   : 4294961299
Oct  8 13:13:05 denkblock kernel: [  240.062960]   .next_jiffies   : 4294961300
Oct  8 13:13:05 denkblock kernel: [  240.062963]   .idle_expires   : 240040000000 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062967] jiffies: 4294961302
Oct  8 13:13:05 denkblock kernel: [  240.062969] 
Oct  8 13:13:05 denkblock kernel: [  240.062970] 
Oct  8 13:13:05 denkblock kernel: [  240.062973] Tick Device: mode:     1
Oct  8 13:13:05 denkblock kernel: [  240.062975] Clock Event Device: pit
Oct  8 13:13:05 denkblock kernel: [  240.062979]  max_delta_ns:   27461866
Oct  8 13:13:05 denkblock kernel: [  240.062982]  min_delta_ns:   12571
Oct  8 13:13:05 denkblock kernel: [  240.062984]  mult:           5124677
Oct  8 13:13:05 denkblock kernel: [  240.062987]  shift:          32
Oct  8 13:13:05 denkblock kernel: [  240.062989]  mode:           3
Oct  8 13:13:05 denkblock kernel: [  240.062992]  next_event:     9223372036854775807 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.062995]  set_next_event: pit_next_event
Oct  8 13:13:05 denkblock kernel: [  240.063002]  set_mode:       init_pit_timer
Oct  8 13:13:05 denkblock kernel: [  240.063008]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 13:13:05 denkblock kernel: [  240.063014] tick_broadcast_mask: 00000001
Oct  8 13:13:05 denkblock kernel: [  240.063016] tick_broadcast_oneshot_mask: 00000000
Oct  8 13:13:05 denkblock kernel: [  240.063019] 
Oct  8 13:13:05 denkblock kernel: [  240.063021] 
Oct  8 13:13:05 denkblock kernel: [  240.063023] Tick Device: mode:     1
Oct  8 13:13:05 denkblock kernel: [  240.063025] Clock Event Device: lapic
Oct  8 13:13:05 denkblock kernel: [  240.063029]  max_delta_ns:   1346509690
Oct  8 13:13:05 denkblock kernel: [  240.063031]  min_delta_ns:   2407
Oct  8 13:13:05 denkblock kernel: [  240.063034]  mult:           26757173
Oct  8 13:13:05 denkblock kernel: [  240.063037]  shift:          32
Oct  8 13:13:05 denkblock kernel: [  240.063039]  mode:           3
Oct  8 13:13:05 denkblock kernel: [  240.063042]  next_event:     240064208834 nsecs
Oct  8 13:13:05 denkblock kernel: [  240.063044]  set_next_event: lapic_next_event
Oct  8 13:13:05 denkblock kernel: [  240.063050]  set_mode:       lapic_timer_setup
Oct  8 13:13:05 denkblock kernel: [  240.063055]  event_handler:  hrtimer_interrupt
Oct  8 13:13:05 denkblock kernel: [  240.063060] 
Oct  8 13:13:15 denkblock kernel: [  250.062990] b:    250.062950825 n:    250.062983790 e: 4294962302 j: 4294962302
Oct  8 13:13:15 denkblock kernel: [  250.062997] Timer List Version: v0.3
Oct  8 13:13:15 denkblock kernel: [  250.063000] HRTIMER_MAX_CLOCK_BASES: 2
Oct  8 13:13:15 denkblock kernel: [  250.063003] now at 250062996641 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063005] 
Oct  8 13:13:15 denkblock kernel: [  250.063008] cpu: 0
Oct  8 13:13:15 denkblock kernel: [  250.063010]  clock 0:
Oct  8 13:13:15 denkblock kernel: [  250.063012]   .index:      0
Oct  8 13:13:15 denkblock kernel: [  250.063014]   .resolution: 1 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063017]   .get_time:   ktime_get_real
Oct  8 13:13:15 denkblock kernel: [  250.063028]   .offset:     1223464145147675602 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063031] active timers:
Oct  8 13:13:15 denkblock kernel: [  250.063034]  clock 1:
Oct  8 13:13:15 denkblock kernel: [  250.063036]   .index:      1
Oct  8 13:13:15 denkblock kernel: [  250.063038]   .resolution: 1 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063041]   .get_time:   ktime_get
Oct  8 13:13:15 denkblock kernel: [  250.063046]   .offset:     0 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063048] active timers:
Oct  8 13:13:15 denkblock kernel: [  250.063051]  #0: softirq_stack, hrtick, S:01, hrtick_start_fair, events/0/4
Oct  8 13:13:15 denkblock kernel: [  250.063069]  # expires at 250064208152 nsecs [in 1211511 nsecs]
Oct  8 13:13:15 denkblock kernel: [  250.063073]  #1: softirq_stack, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
Oct  8 13:13:15 denkblock kernel: [  250.063089]  # expires at 250070000000 nsecs [in 7003359 nsecs]
Oct  8 13:13:15 denkblock kernel: [  250.063093]  #2: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2439
Oct  8 13:13:15 denkblock kernel: [  250.063106]  # expires at 270911403868 nsecs [in 20848407227 nsecs]
Oct  8 13:13:15 denkblock kernel: [  250.063111]   .expires_next   : 250064208152 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063114]   .hres_active    : 1
Oct  8 13:13:15 denkblock kernel: [  250.063117]   .nr_events      : 13549
Oct  8 13:13:15 denkblock kernel: [  250.063119]   .nohz_mode      : 2
Oct  8 13:13:15 denkblock kernel: [  250.063122]   .idle_tick      : 250030000000 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063125]   .tick_stopped   : 0
Oct  8 13:13:15 denkblock kernel: [  250.063128]   .idle_jiffies   : 4294962298
Oct  8 13:13:15 denkblock kernel: [  250.063131]   .idle_calls     : 38321
Oct  8 13:13:15 denkblock kernel: [  250.063133]   .idle_sleeps    : 27609
Oct  8 13:13:15 denkblock kernel: [  250.063136]   .idle_entrytime : 250031169962 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063139]   .idle_waketime  : 250030532730 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063143]   .idle_exittime  : 250030556196 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063146]   .idle_sleeptime : 234773018770 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063149]   .last_jiffies   : 4294962299
Oct  8 13:13:15 denkblock kernel: [  250.063156]   .next_jiffies   : 4294962300
Oct  8 13:13:15 denkblock kernel: [  250.063159]   .idle_expires   : 250040000000 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063162] jiffies: 4294962302
Oct  8 13:13:15 denkblock kernel: [  250.063164] 
Oct  8 13:13:15 denkblock kernel: [  250.063166] 
Oct  8 13:13:15 denkblock kernel: [  250.063168] Tick Device: mode:     1
Oct  8 13:13:15 denkblock kernel: [  250.063171] Clock Event Device: pit
Oct  8 13:13:15 denkblock kernel: [  250.063175]  max_delta_ns:   27461866
Oct  8 13:13:15 denkblock kernel: [  250.063177]  min_delta_ns:   12571
Oct  8 13:13:15 denkblock kernel: [  250.063180]  mult:           5124677
Oct  8 13:13:15 denkblock kernel: [  250.063183]  shift:          32
Oct  8 13:13:15 denkblock kernel: [  250.063185]  mode:           3
Oct  8 13:13:15 denkblock kernel: [  250.063188]  next_event:     9223372036854775807 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063191]  set_next_event: pit_next_event
Oct  8 13:13:15 denkblock kernel: [  250.063198]  set_mode:       init_pit_timer
Oct  8 13:13:15 denkblock kernel: [  250.063203]  event_handler:  tick_handle_oneshot_broadcast
Oct  8 13:13:15 denkblock kernel: [  250.063209] tick_broadcast_mask: 00000001
Oct  8 13:13:15 denkblock kernel: [  250.063212] tick_broadcast_oneshot_mask: 00000000
Oct  8 13:13:15 denkblock kernel: [  250.063215] 
Oct  8 13:13:15 denkblock kernel: [  250.063216] 
Oct  8 13:13:15 denkblock kernel: [  250.063218] Tick Device: mode:     1
Oct  8 13:13:15 denkblock kernel: [  250.063221] Clock Event Device: lapic
Oct  8 13:13:15 denkblock kernel: [  250.063224]  max_delta_ns:   1346509690
Oct  8 13:13:15 denkblock kernel: [  250.063227]  min_delta_ns:   2407
Oct  8 13:13:15 denkblock kernel: [  250.063230]  mult:           26757173
Oct  8 13:13:15 denkblock kernel: [  250.063232]  shift:          32
Oct  8 13:13:15 denkblock kernel: [  250.063235]  mode:           3
Oct  8 13:13:15 denkblock kernel: [  250.063238]  next_event:     250064208152 nsecs
Oct  8 13:13:15 denkblock kernel: [  250.063240]  set_next_event: lapic_next_event
Oct  8 13:13:15 denkblock kernel: [  250.063246]  set_mode:       lapic_timer_setup
Oct  8 13:13:15 denkblock kernel: [  250.063250]  event_handler:  hrtimer_interrupt
Oct  8 13:13:15 denkblock kernel: [  250.063256] 
Oct  8 13:13:20 denkblock kernel: [  255.421884] ath0: deauthenticating by local choice (reason=3)
Oct  8 13:13:27 denkblock kernel: [  262.555222] tstm: module unloaded.
--8<---------------dmesg---------------end--------------->8---
