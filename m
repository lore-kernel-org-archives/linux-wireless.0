Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:44220 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528AbYJGVXQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 17:23:16 -0400
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
Date: Tue, 07 Oct 2008 23:23:07 +0200
In-Reply-To: <alpine.LFD.2.00.0810072042140.3166@apollo> (Thomas Gleixner's
	message of "Tue, 7 Oct 2008 20:44:58 +0200 (CEST)")
Message-ID: <87hc7ot804.fsf@denkblock.local> (sfid-20081007_232348_622895_0599A501)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 7 Oct 2008, Thomas Gleixner wrote:
>> On Tue, 7 Oct 2008, Elias Oltmanns wrote:
>
>> > Thomas Gleixner <tglx@linutronix.de> wrote:
>> > > On Mon, 6 Oct 2008, Elias Oltmanns wrote:
>> > >> Make sure that event1 is the right device. chktimer usually reports
>> > >> several premature timer expiries in less than a minute.
>> > [...]
>> > > Your measuring method is wrong. You really want to measure the delta
>> > > of the timer events in the kernel via ktime_get(), not the delta of
>> > > something else in userspace.
>> > 
>> > Alright, here is a stripped down version of the test case. This time,
>> > you only need to load the timer-test module and start up the ath5k
>> > interface. The glitch is triggered slightly less reliably, but I can
>> 
>> -ENOATH5KHARDWARE

Well, that's why I posted this on linux-wireless in the first place. In
fact, I just *hoped* for some general advice from you in the matter
especially regarding the question whether concurrent accesses to pci
card registers might possibly cause such a behaviour or whether I'd have
to look for something else. Obviously, I'm very happy that you take such
an interest in this affair even though it seems to be very closely
related to a particular device driver.

>> 
>> > still easily verify that the problem is present when running 2.6.27-rc9
>> > on my system.
>> 
>> Hmm. Can you please add some real info to the printk :)
>> 
>> > +	if (timespec_to_ns(&diff) < TSTM_THRESH)
>> > +		printk(KERN_INFO "Timer expired prematurely.\n");
>> 
>> e.g.:
>> 
>>   		printk(KERN_INFO "b: %6ld.%09ld n: %6ld.09ld e: %lu j: %lu\n",
>> 			before.tv_sec, before.tv_nsec, now.tv_sec, now.tv_nsec,
>> 			tstm_timer.expires, jiffies);
>> 
>> Does this happen w/o the ath5k driver as well ?

At least, I don't recall seeing this when the interface was down or even
the driver unloaded.

>
> Some more questions:
>
> Does this happen with any on the combinations of highres/nohz
> enabled/disabled ?

>From my tests in the past it would appear that NO_HZ enabled is the most
important option to trigger the problem speedily. HIGHRES_TIMERS didn't
seem to make much difference and I am quite sure that I observed this
issue with NO_HZ disabled too, but very rarely. I'll keep testing and
reporting. Meanwhile, ...

>
> Can you please add:
>
>     sysrq_timer_list_show();
>
>     after the printk. You have to export it in kernel/time/timer_list.c
>     to use it with a module
>
> Please do cat /proc/timer_list right before you start the module as well.

... here are some results for

CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

--8<---------------/proc/timer_list---------------start------------->8---
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 176358191709 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 10000000 nsecs
  .get_time:   ktime_get_real
active timers:
 clock 1:
  .index:      1
  .resolution: 10000000 nsecs
  .get_time:   ktime_get
active timers:
 #0: <de135ec0>, it_real_fn, S:01, do_setitimer, syslogd/2446
 # expires at 203020070149 nsecs [in 26661878440 nsecs]
  .nohz_mode      : 1
  .idle_tick      : 176330000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294954928
  .idle_calls     : 23924
  .idle_sleeps    : 20168
  .idle_entrytime : 176347614104 nsecs
  .idle_waketime  : 176355789447 nsecs
  .idle_exittime  : 176355831632 nsecs
  .idle_sleeptime : 164535951430 nsecs
  .last_jiffies   : 4294954930
  .next_jiffies   : 4294954933
  .idle_expires   : 176370000000 nsecs
jiffies: 4294954931


Tick Device: mode:     1
Clock Event Device: pit
 max_delta_ns:   27461866
 min_delta_ns:   12571
 mult:           5124677
 shift:          32
 mode:           3
 next_event:     176370000000 nsecs
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
 next_event:     176360000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_nohz_handler

--8<---------------/proc/timer_list---------------end--------------->8---

--8<---------------dmesg---------------start------------->8---
Oct  7 22:16:06 denkblock kernel: [  182.852847] timer-test: module successfully loaded.
Oct  7 22:16:13 denkblock kernel: [  190.406715] NET: Registered protocol family 17
[ ath0 start up and associate with AP ]
Oct  7 22:16:43 denkblock kernel: [  220.061949] b:    220.061926318 n:    220.061943080 e: 4294959302 j: 4294959302
Oct  7 22:16:43 denkblock kernel: [  220.061957] Timer List Version: v0.3
Oct  7 22:16:43 denkblock kernel: [  220.061960] HRTIMER_MAX_CLOCK_BASES: 2
Oct  7 22:16:43 denkblock kernel: [  220.061963] now at 220061956490 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.061965] 
Oct  7 22:16:43 denkblock kernel: [  220.061967] cpu: 0
Oct  7 22:16:43 denkblock kernel: [  220.061970]  clock 0:
Oct  7 22:16:43 denkblock kernel: [  220.061972]   .index:      0
Oct  7 22:16:43 denkblock kernel: [  220.061974]   .resolution: 10000000 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.061977]   .get_time:   ktime_get_real
Oct  7 22:16:43 denkblock kernel: [  220.061987] active timers:
Oct  7 22:16:43 denkblock kernel: [  220.061990]  clock 1:
Oct  7 22:16:43 denkblock kernel: [  220.061992]   .index:      1
Oct  7 22:16:43 denkblock kernel: [  220.061995]   .resolution: 10000000 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.061997]   .get_time:   ktime_get
Oct  7 22:16:43 denkblock kernel: [  220.062002] active timers:
Oct  7 22:16:43 denkblock kernel: [  220.062005]  #0: softirq_stack, hrtimer_wakeup, S:01, do_nanosleep, tail/2677
Oct  7 22:16:43 denkblock kernel: [  220.062024]  # expires at 221010411656 nsecs [in 948455166 nsecs]
Oct  7 22:16:43 denkblock kernel: [  220.062028]  #1: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2446
Oct  7 22:16:43 denkblock kernel: [  220.062041]  # expires at 233030065277 nsecs [in 12968108787 nsecs]
Oct  7 22:16:43 denkblock kernel: [  220.062046]   .nohz_mode      : 1
Oct  7 22:16:43 denkblock kernel: [  220.062049]   .idle_tick      : 219990000000 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062052]   .tick_stopped   : 0
Oct  7 22:16:43 denkblock kernel: [  220.062055]   .idle_jiffies   : 4294959296
Oct  7 22:16:43 denkblock kernel: [  220.062058]   .idle_calls     : 30373
Oct  7 22:16:43 denkblock kernel: [  220.062060]   .idle_sleeps    : 24439
Oct  7 22:16:43 denkblock kernel: [  220.062063]   .idle_entrytime : 220030129810 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062066]   .idle_waketime  : 220010010209 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062070]   .idle_exittime  : 220010028367 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062073]   .idle_sleeptime : 204917963234 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062076]   .last_jiffies   : 4294959299
Oct  7 22:16:43 denkblock kernel: [  220.062079]   .next_jiffies   : 4294959300
Oct  7 22:16:43 denkblock kernel: [  220.062082]   .idle_expires   : 220010000000 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062085] jiffies: 4294959302
Oct  7 22:16:43 denkblock kernel: [  220.062087] 
Oct  7 22:16:43 denkblock kernel: [  220.062089] 
Oct  7 22:16:43 denkblock kernel: [  220.062091] Tick Device: mode:     1
Oct  7 22:16:43 denkblock kernel: [  220.062093] Clock Event Device: pit
Oct  7 22:16:43 denkblock kernel: [  220.062097]  max_delta_ns:   27461866
Oct  7 22:16:43 denkblock kernel: [  220.062100]  min_delta_ns:   12571
Oct  7 22:16:43 denkblock kernel: [  220.062103]  mult:           5124677
Oct  7 22:16:43 denkblock kernel: [  220.062105]  shift:          32
Oct  7 22:16:43 denkblock kernel: [  220.062108]  mode:           3
Oct  7 22:16:43 denkblock kernel: [  220.062111]  next_event:     9223372036854775807 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062114]  set_next_event: pit_next_event
Oct  7 22:16:43 denkblock kernel: [  220.062121]  set_mode:       init_pit_timer
Oct  7 22:16:43 denkblock kernel: [  220.062126]  event_handler:  tick_handle_oneshot_broadcast
Oct  7 22:16:43 denkblock kernel: [  220.062134] tick_broadcast_mask: 00000001
Oct  7 22:16:43 denkblock kernel: [  220.062137] tick_broadcast_oneshot_mask: 00000000
Oct  7 22:16:43 denkblock kernel: [  220.062139] 
Oct  7 22:16:43 denkblock kernel: [  220.062141] 
Oct  7 22:16:43 denkblock kernel: [  220.062143] Tick Device: mode:     1
Oct  7 22:16:43 denkblock kernel: [  220.062145] Clock Event Device: lapic
Oct  7 22:16:43 denkblock kernel: [  220.062149]  max_delta_ns:   1346509690
Oct  7 22:16:43 denkblock kernel: [  220.062152]  min_delta_ns:   2407
Oct  7 22:16:43 denkblock kernel: [  220.062154]  mult:           26757173
Oct  7 22:16:43 denkblock kernel: [  220.062157]  shift:          32
Oct  7 22:16:43 denkblock kernel: [  220.062159]  mode:           3
Oct  7 22:16:43 denkblock kernel: [  220.062162]  next_event:     220070000000 nsecs
Oct  7 22:16:43 denkblock kernel: [  220.062165]  set_next_event: lapic_next_event
Oct  7 22:16:43 denkblock kernel: [  220.062171]  set_mode:       lapic_timer_setup
Oct  7 22:16:43 denkblock kernel: [  220.062175]  event_handler:  tick_nohz_handler
Oct  7 22:16:43 denkblock kernel: [  220.062181] 
Oct  7 22:16:53 denkblock kernel: [  230.062974] b:    230.062949074 n:    230.062967513 e: 4294960302 j: 4294960302
Oct  7 22:16:53 denkblock kernel: [  230.062981] Timer List Version: v0.3
Oct  7 22:16:53 denkblock kernel: [  230.062984] HRTIMER_MAX_CLOCK_BASES: 2
Oct  7 22:16:53 denkblock kernel: [  230.062987] now at 230062981201 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.062990] 
Oct  7 22:16:53 denkblock kernel: [  230.062992] cpu: 0
Oct  7 22:16:53 denkblock kernel: [  230.062994]  clock 0:
Oct  7 22:16:53 denkblock kernel: [  230.062997]   .index:      0
Oct  7 22:16:53 denkblock kernel: [  230.062999]   .resolution: 10000000 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063002]   .get_time:   ktime_get_real
Oct  7 22:16:53 denkblock kernel: [  230.063012] active timers:
Oct  7 22:16:53 denkblock kernel: [  230.063015]  clock 1:
Oct  7 22:16:53 denkblock kernel: [  230.063017]   .index:      1
Oct  7 22:16:53 denkblock kernel: [  230.063019]   .resolution: 10000000 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063022]   .get_time:   ktime_get
Oct  7 22:16:53 denkblock kernel: [  230.063027] active timers:
Oct  7 22:16:53 denkblock kernel: [  230.063030]  #0: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2446
Oct  7 22:16:53 denkblock kernel: [  230.063047]  # expires at 233030065277 nsecs [in 2967084076 nsecs]
Oct  7 22:16:53 denkblock kernel: [  230.063051]   .nohz_mode      : 1
Oct  7 22:16:53 denkblock kernel: [  230.063054]   .idle_tick      : 229990000000 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063057]   .tick_stopped   : 0
Oct  7 22:16:53 denkblock kernel: [  230.063060]   .idle_jiffies   : 4294960294
Oct  7 22:16:53 denkblock kernel: [  230.063063]   .idle_calls     : 31886
Oct  7 22:16:53 denkblock kernel: [  230.063065]   .idle_sleeps    : 25474
Oct  7 22:16:53 denkblock kernel: [  230.063068]   .idle_entrytime : 230038292861 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063072]   .idle_waketime  : 229995775993 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063075]   .idle_exittime  : 229995796387 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063078]   .idle_sleeptime : 214780228661 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063081]   .last_jiffies   : 4294960299
Oct  7 22:16:53 denkblock kernel: [  230.063084]   .next_jiffies   : 4294960300
Oct  7 22:16:53 denkblock kernel: [  230.063087]   .idle_expires   : 230000000000 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063090] jiffies: 4294960302
Oct  7 22:16:53 denkblock kernel: [  230.063092] 
Oct  7 22:16:53 denkblock kernel: [  230.063094] 
Oct  7 22:16:53 denkblock kernel: [  230.063096] Tick Device: mode:     1
Oct  7 22:16:53 denkblock kernel: [  230.063099] Clock Event Device: pit
Oct  7 22:16:53 denkblock kernel: [  230.063102]  max_delta_ns:   27461866
Oct  7 22:16:53 denkblock kernel: [  230.063105]  min_delta_ns:   12571
Oct  7 22:16:53 denkblock kernel: [  230.063108]  mult:           5124677
Oct  7 22:16:53 denkblock kernel: [  230.063111]  shift:          32
Oct  7 22:16:53 denkblock kernel: [  230.063113]  mode:           3
Oct  7 22:16:53 denkblock kernel: [  230.063116]  next_event:     9223372036854775807 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063119]  set_next_event: pit_next_event
Oct  7 22:16:53 denkblock kernel: [  230.063126]  set_mode:       init_pit_timer
Oct  7 22:16:53 denkblock kernel: [  230.063132]  event_handler:  tick_handle_oneshot_broadcast
Oct  7 22:16:53 denkblock kernel: [  230.063139] tick_broadcast_mask: 00000001
Oct  7 22:16:53 denkblock kernel: [  230.063142] tick_broadcast_oneshot_mask: 00000000
Oct  7 22:16:53 denkblock kernel: [  230.063145] 
Oct  7 22:16:53 denkblock kernel: [  230.063146] 
Oct  7 22:16:53 denkblock kernel: [  230.063148] Tick Device: mode:     1
Oct  7 22:16:53 denkblock kernel: [  230.063151] Clock Event Device: lapic
Oct  7 22:16:53 denkblock kernel: [  230.063154]  max_delta_ns:   1346509690
Oct  7 22:16:53 denkblock kernel: [  230.063157]  min_delta_ns:   2407
Oct  7 22:16:53 denkblock kernel: [  230.063160]  mult:           26757173
Oct  7 22:16:53 denkblock kernel: [  230.063162]  shift:          32
Oct  7 22:16:53 denkblock kernel: [  230.063165]  mode:           3
Oct  7 22:16:53 denkblock kernel: [  230.063168]  next_event:     230070000000 nsecs
Oct  7 22:16:53 denkblock kernel: [  230.063170]  set_next_event: lapic_next_event
Oct  7 22:16:53 denkblock kernel: [  230.063176]  set_mode:       lapic_timer_setup
Oct  7 22:16:53 denkblock kernel: [  230.063181]  event_handler:  tick_nohz_handler
Oct  7 22:16:53 denkblock kernel: [  230.063186] 
Oct  7 22:17:03 denkblock kernel: [  240.061943] b:    240.061920172 n:    240.061936655 e: 4294961302 j: 4294961302
Oct  7 22:17:03 denkblock kernel: [  240.061950] Timer List Version: v0.3
Oct  7 22:17:03 denkblock kernel: [  240.061953] HRTIMER_MAX_CLOCK_BASES: 2
Oct  7 22:17:03 denkblock kernel: [  240.061956] now at 240061949785 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.061959] 
Oct  7 22:17:03 denkblock kernel: [  240.061961] cpu: 0
Oct  7 22:17:03 denkblock kernel: [  240.061963]  clock 0:
Oct  7 22:17:03 denkblock kernel: [  240.061965]   .index:      0
Oct  7 22:17:03 denkblock kernel: [  240.061968]   .resolution: 10000000 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.061971]   .get_time:   ktime_get_real
Oct  7 22:17:03 denkblock kernel: [  240.061981] active timers:
Oct  7 22:17:03 denkblock kernel: [  240.061984]  clock 1:
Oct  7 22:17:03 denkblock kernel: [  240.061986]   .index:      1
Oct  7 22:17:03 denkblock kernel: [  240.061988]   .resolution: 10000000 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.061991]   .get_time:   ktime_get
Oct  7 22:17:03 denkblock kernel: [  240.061996] active timers:
Oct  7 22:17:03 denkblock kernel: [  240.061999]  #0: softirq_stack, it_real_fn, S:01, do_setitimer, syslogd/2446
Oct  7 22:17:03 denkblock kernel: [  240.062016]  # expires at 263040078005 nsecs [in 22978128220 nsecs]
Oct  7 22:17:03 denkblock kernel: [  240.062020]   .nohz_mode      : 1
Oct  7 22:17:03 denkblock kernel: [  240.062023]   .idle_tick      : 239990000000 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062026]   .tick_stopped   : 0
Oct  7 22:17:03 denkblock kernel: [  240.062029]   .idle_jiffies   : 4294961296
Oct  7 22:17:03 denkblock kernel: [  240.062032]   .idle_calls     : 33434
Oct  7 22:17:03 denkblock kernel: [  240.062035]   .idle_sleeps    : 26515
Oct  7 22:17:03 denkblock kernel: [  240.062037]   .idle_entrytime : 240034626193 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062041]   .idle_waketime  : 240010010209 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062044]   .idle_exittime  : 240010025853 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062047]   .idle_sleeptime : 224654904871 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062050]   .last_jiffies   : 4294961299
Oct  7 22:17:03 denkblock kernel: [  240.062053]   .next_jiffies   : 4294961300
Oct  7 22:17:03 denkblock kernel: [  240.062056]   .idle_expires   : 240010000000 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062059] jiffies: 4294961302
Oct  7 22:17:03 denkblock kernel: [  240.062061] 
Oct  7 22:17:03 denkblock kernel: [  240.062063] 
Oct  7 22:17:03 denkblock kernel: [  240.062065] Tick Device: mode:     1
Oct  7 22:17:03 denkblock kernel: [  240.062068] Clock Event Device: pit
Oct  7 22:17:03 denkblock kernel: [  240.062072]  max_delta_ns:   27461866
Oct  7 22:17:03 denkblock kernel: [  240.062074]  min_delta_ns:   12571
Oct  7 22:17:03 denkblock kernel: [  240.062077]  mult:           5124677
Oct  7 22:17:03 denkblock kernel: [  240.062080]  shift:          32
Oct  7 22:17:03 denkblock kernel: [  240.062082]  mode:           3
Oct  7 22:17:03 denkblock kernel: [  240.062085]  next_event:     9223372036854775807 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062088]  set_next_event: pit_next_event
Oct  7 22:17:03 denkblock kernel: [  240.062096]  set_mode:       init_pit_timer
Oct  7 22:17:03 denkblock kernel: [  240.062101]  event_handler:  tick_handle_oneshot_broadcast
Oct  7 22:17:03 denkblock kernel: [  240.062108] tick_broadcast_mask: 00000001
Oct  7 22:17:03 denkblock kernel: [  240.062111] tick_broadcast_oneshot_mask: 00000000
Oct  7 22:17:03 denkblock kernel: [  240.062114] 
Oct  7 22:17:03 denkblock kernel: [  240.062115] 
Oct  7 22:17:03 denkblock kernel: [  240.062117] Tick Device: mode:     1
Oct  7 22:17:03 denkblock kernel: [  240.062120] Clock Event Device: lapic
Oct  7 22:17:03 denkblock kernel: [  240.062123]  max_delta_ns:   1346509690
Oct  7 22:17:03 denkblock kernel: [  240.062126]  min_delta_ns:   2407
Oct  7 22:17:03 denkblock kernel: [  240.062129]  mult:           26757173
Oct  7 22:17:03 denkblock kernel: [  240.062131]  shift:          32
Oct  7 22:17:03 denkblock kernel: [  240.062134]  mode:           3
Oct  7 22:17:03 denkblock kernel: [  240.062137]  next_event:     240070000000 nsecs
Oct  7 22:17:03 denkblock kernel: [  240.062139]  set_next_event: lapic_next_event
Oct  7 22:17:03 denkblock kernel: [  240.062145]  set_mode:       lapic_timer_setup
Oct  7 22:17:03 denkblock kernel: [  240.062150]  event_handler:  tick_nohz_handler
Oct  7 22:17:03 denkblock kernel: [  240.062155] 
--8<---------------dmesg---------------end--------------->8---

Please recall that ten seconds is the interval at which ath5k_calbrate()
is executed. It is not always that the problem is triggered so
regularly, but the elapsed time is always a multiple of ten seconds.

Regards,

Elias
