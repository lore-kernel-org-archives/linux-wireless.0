Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:47570 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbYJNTAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:00:36 -0400
Date: Tue, 14 Oct 2008 21:00:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <87k5ceeuxy.fsf@denkblock.local>
Message-ID: <alpine.LFD.2.00.0810142054580.6848@apollo> (sfid-20081014_210041_733840_7C3F6FCD)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
 <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo> <alpine.LFD.2.00.0810091313380.3237@apollo> <87k5cgg87j.fsf@denkblock.local> <alpine.LFD.2.00.0810101127560.3271@apollo>
 <87abdck6sn.fsf@denkblock.local> <alpine.LFD.2.00.0810101432540.3271@apollo> <alpine.LFD.2.00.0810111149420.3356@apollo> <87k5ceeuxy.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 11 Oct 2008, Elias Oltmanns wrote:
> > Compile the acpi_processor module in to the kernel
> > (CONFIG_ACPI_PROCESSOR=y) and add processor.max_cstate=1 to the kernel
> > command line. If I analysed the problem correctly this will make the
> > jiffies problem go away. I'm working on a fix.
> 
> Spot on, it does go away regardless whether NO_HZ or HIGH_RES are
> enabled or disabled. Looking forward to testing your fix ;-).

Here you go.

     tglx

---
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 98921a3..cb271ce 100644
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
@@ -111,21 +113,17 @@ static inline int tick_check_oneshot_change(int allow_nohz) { return 0; }
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
index c506f26..6ad6aec 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -254,16 +254,12 @@ asmlinkage void do_softirq(void)
  */
 void irq_enter(void)
 {
-#ifdef CONFIG_NO_HZ
 	int cpu = smp_processor_id();
-	if (idle_cpu(cpu) && !in_interrupt())
-		tick_nohz_stop_idle(cpu);
-#endif
-	__irq_enter();
-#ifdef CONFIG_NO_HZ
+
 	if (idle_cpu(cpu))
-		tick_nohz_update_jiffies();
-#endif
+		tick_check_idle(cpu);
+
+	__irq_enter();
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
index a4d2193..d1b39e6 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -155,7 +155,7 @@ void tick_nohz_update_jiffies(void)
 	touch_softlockup_watchdog();
 }
 
-void tick_nohz_stop_idle(int cpu)
+static void tick_nohz_stop_idle(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
@@ -559,6 +559,20 @@ static inline void tick_nohz_switch_to_nohz(void) { }
 #endif /* NO_HZ */
 
 /*
+ * Called from irq_enter to notify about the possible interruption of idle()
+ */
+void tick_check_idle(int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	if (!in_interrupt()) {
+		tick_nohz_stop_idle(cpu);
+		tick_nohz_update_jiffies();
+	}
+#endif
+	tick_check_oneshot_broadcast(cpu);
+}
+
+/*
  * High resolution timer specific code
  */
 #ifdef CONFIG_HIGH_RES_TIMERS
