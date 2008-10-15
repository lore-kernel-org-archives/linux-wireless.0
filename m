Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:58513 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYJOInY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 04:43:24 -0400
Date: Wed, 15 Oct 2008 10:43:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <87skqyj0ps.fsf@denkblock.local>
Message-ID: <alpine.LFD.2.00.0810150752380.6848@apollo> (sfid-20081015_104345_078653_3D7FAB9B)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
 <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo> <alpine.LFD.2.00.0810091313380.3237@apollo> <87k5cgg87j.fsf@denkblock.local> <alpine.LFD.2.00.0810101127560.3271@apollo>
 <87abdck6sn.fsf@denkblock.local> <alpine.LFD.2.00.0810101432540.3271@apollo> <alpine.LFD.2.00.0810111149420.3356@apollo> <87k5ceeuxy.fsf@denkblock.local> <alpine.LFD.2.00.0810142054580.6848@apollo> <87skqyj0ps.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 15 Oct 2008, Elias Oltmanns wrote:
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Sat, 11 Oct 2008, Elias Oltmanns wrote:
> >> > Compile the acpi_processor module in to the kernel
> >
> >> > (CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
> >> > command line. If I analysed the problem correctly this will make the
> >> > jiffies problem go away. I'm working on a fix.
> >> 
> >> Spot on, it does go away regardless whether NO_HZ or HIGH_RES are
> >> enabled or disabled. Looking forward to testing your fix ;-).
> >
> > Here you go.
> 
> Bad luck, I'm afraid. Your patch seems to fix the issue for NO_HZ=n +
> HIGH_RES=y. As soon as NO_HZ=y, however, the problem reappears. See the

Hmm. You should have seen the same problem w/o that patch in the
"CONFIG_ACPI_PROCESSOR=y / processor.max_cstate=1" test with NOHZ=y.

Anyway, I can see what the NOHZ problem is. Updated patch below.

> output below. (Still testing on 2.6.27, mind. Should I test something
> more up-to-date?)

.27 is fine. 

Did you make any progress finding out why the ath5k softirq runs for
>20ms ?  We need to fix this madness as well :)

Thanks,

	tglx
---
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 98921a3..b6ec818 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -96,9 +96,11 @@ extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
 extern struct tick_sched *tick_get_tick_sched(int cpu);
+extern void tick_check_idle(int cpu);
 # else
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+static inline void tick_check_idle(int cpu) { }
 # endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS */
@@ -106,26 +108,23 @@ static inline void tick_init(void) { }
 static inline void tick_cancel_sched_timer(int cpu) { }
 static inline void tick_clock_notify(void) { }
 static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
+static inline void tick_check_idle(int cpu) { }
 #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
 
 # ifdef CONFIG_NO_HZ
 extern void tick_nohz_stop_sched_tick(int inidle);
 extern void tick_nohz_restart_sched_tick(void);
-extern void tick_nohz_update_jiffies(void);
 extern ktime_t tick_nohz_get_sleep_length(void);
-extern void tick_nohz_stop_idle(int cpu);
 extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
 # else
 static inline void tick_nohz_stop_sched_tick(int inidle) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
-static inline void tick_nohz_update_jiffies(void) { }
 static inline ktime_t tick_nohz_get_sleep_length(void)
 {
 	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
 
 	return len;
 }
-static inline void tick_nohz_stop_idle(int cpu) { }
 static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index c506f26..102cb1c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -254,16 +254,12 @@ asmlinkage void do_softirq(void)
  */
 void irq_enter(void)
 {
-#ifdef CONFIG_NO_HZ
 	int cpu = smp_processor_id();
+
 	if (idle_cpu(cpu) && !in_interrupt())
-		tick_nohz_stop_idle(cpu);
-#endif
+		tick_check_idle(cpu);
+
 	__irq_enter();
-#ifdef CONFIG_NO_HZ
-	if (idle_cpu(cpu))
-		tick_nohz_update_jiffies();
-#endif
 }
 
 #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index cb01cd8..f98a1b7 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -384,6 +384,19 @@ int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 }
 
 /*
+ * Called from irq_enter() when idle was interrupted to reenable the
+ * per cpu device.
+ */
+void tick_check_oneshot_broadcast(int cpu)
+{
+	if (cpu_isset(cpu, tick_broadcast_oneshot_mask)) {
+		struct tick_device *td = &per_cpu(tick_cpu_device, cpu);
+
+		clockevents_set_mode(td->evtdev, CLOCK_EVT_MODE_ONESHOT);
+	}
+}
+
+/*
  * Handle oneshot mode broadcasting
  */
 static void tick_handle_oneshot_broadcast(struct clock_event_device *dev)
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 4692487..b1c05bf 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -36,6 +36,7 @@ extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
 extern int tick_broadcast_oneshot_active(void);
+extern void tick_check_oneshot_broadcast(int cpu);
 # else /* BROADCAST */
 static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
@@ -45,6 +46,7 @@ static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
+static inline void tick_check_oneshot_broadcast(int cpu) { }
 # endif /* !BROADCAST */
 
 #else /* !ONESHOT */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a4d2193..9877bdd 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -155,7 +155,7 @@ void tick_nohz_update_jiffies(void)
 	touch_softlockup_watchdog();
 }
 
-void tick_nohz_stop_idle(int cpu)
+static void tick_nohz_stop_idle(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
@@ -377,6 +377,32 @@ ktime_t tick_nohz_get_sleep_length(void)
 	return ts->sleep_length;
 }
 
+static void tick_nohz_restart(struct tick_sched *ts, ktime_t now)
+{
+	hrtimer_cancel(&ts->sched_timer);
+	ts->sched_timer.expires = ts->idle_tick;
+
+	while (1) {
+		/* Forward the time to expire in the future */
+		hrtimer_forward(&ts->sched_timer, now, tick_period);
+
+		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
+			hrtimer_start(&ts->sched_timer,
+				      ts->sched_timer.expires,
+				      HRTIMER_MODE_ABS);
+			/* Check, if the timer was already in the past */
+			if (hrtimer_active(&ts->sched_timer))
+				break;
+		} else {
+			if (!tick_program_event(ts->sched_timer.expires, 0))
+				break;
+		}
+		/* Update jiffies and reread time */
+		tick_do_update_jiffies64(now);
+		now = ktime_get();
+	}
+}
+
 /**
  * tick_nohz_restart_sched_tick - restart the idle tick from the idle task
  *
@@ -430,28 +456,7 @@ void tick_nohz_restart_sched_tick(void)
 	 */
 	ts->tick_stopped  = 0;
 	ts->idle_exittime = now;
-	hrtimer_cancel(&ts->sched_timer);
-	ts->sched_timer.expires = ts->idle_tick;
-
-	while (1) {
-		/* Forward the time to expire in the future */
-		hrtimer_forward(&ts->sched_timer, now, tick_period);
-
-		if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-			hrtimer_start(&ts->sched_timer,
-				      ts->sched_timer.expires,
-				      HRTIMER_MODE_ABS);
-			/* Check, if the timer was already in the past */
-			if (hrtimer_active(&ts->sched_timer))
-				break;
-		} else {
-			if (!tick_program_event(ts->sched_timer.expires, 0))
-				break;
-		}
-		/* Update jiffies and reread time */
-		tick_do_update_jiffies64(now);
-		now = ktime_get();
-	}
+	tick_nohz_restart(ts, now);
 	local_irq_enable();
 }
 
@@ -503,10 +508,6 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 	update_process_times(user_mode(regs));
 	profile_tick(CPU_PROFILING);
 
-	/* Do not restart, when we are in the idle loop */
-	if (ts->tick_stopped)
-		return;
-
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
 		tick_do_update_jiffies64(now);
@@ -552,6 +553,27 @@ static void tick_nohz_switch_to_nohz(void)
 	       smp_processor_id());
 }
 
+/*
+ * When NOHZ is enabled and the tick is stopped, we need to kick the
+ * tick timer from irq_enter() so that the jiffies update is kept
+ * alive during long running softirqs. That's ugly as hell, but
+ * correctness is key even if we need to fix the offending softirq in
+ * the first place.
+ *
+ * Note, this is different to tick_nohz_restart. We just kick the
+ * timer and do not touch the other magic bits which need to be done
+ * when idle is left.
+ */
+static void tick_nohz_kick_tick(int cpu)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	if (!ts->tick_stopped)
+		return;
+
+	tick_nohz_restart(ts, ktime_get());
+}
+
 #else
 
 static inline void tick_nohz_switch_to_nohz(void) { }
@@ -559,6 +581,19 @@ static inline void tick_nohz_switch_to_nohz(void) { }
 #endif /* NO_HZ */
 
 /*
+ * Called from irq_enter to notify about the possible interruption of idle()
+ */
+void tick_check_idle(int cpu)
+{
+	tick_check_oneshot_broadcast(cpu);
+#ifdef CONFIG_NO_HZ
+	tick_nohz_stop_idle(cpu);
+	tick_nohz_update_jiffies();
+	tick_nohz_kick_tick(cpu);
+#endif
+}
+
+/*
  * High resolution timer specific code
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -611,10 +646,6 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 		profile_tick(CPU_PROFILING);
 	}
 
-	/* Do not restart, when we are in the idle loop */
-	if (ts->tick_stopped)
-		return HRTIMER_NORESTART;
-
 	hrtimer_forward(timer, now, tick_period);
 
 	return HRTIMER_RESTART;
