Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:51341 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYJILP1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 07:15:27 -0400
Date: Thu, 9 Oct 2008 13:15:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Elias Oltmanns <eo@nebensachen.de>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
 access?
In-Reply-To: <alpine.LFD.2.00.0810082203360.3237@apollo>
Message-ID: <alpine.LFD.2.00.0810091313380.3237@apollo> (sfid-20081009_131531_631145_13369201)
References: <87k5cm3ee2.fsf@denkblock.local> <alpine.LFD.2.00.0810052354000.3398@apollo> <87d4id3jmr.fsf@denkblock.local> <alpine.LFD.2.00.0810061614490.3166@apollo> <87skr8h1de.fsf@denkblock.local> <alpine.LFD.2.00.0810071946460.3166@apollo>
 <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 8 Oct 2008, Thomas Gleixner wrote:
> There is no significant deviation between jiffies and ktime in the
> debug output, but I noticed that you run with HZ=100, right ? So the
> timeout you run is 100/50 = 2. I would have a reasonable explanation
> if it would be 1, but I need to think about it more when I'm awake.

I think I know what happens. Can you please apply the following debug
patch and provide the output?

Thanks,

	tglx

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 8cf8cfe..422b5f4 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -64,6 +64,9 @@ struct tick_sched {
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
+	ktime_t				last_events0;
+	ktime_t				last_events1;
+	ktime_t				last_events2;
 };
 
 extern void __init tick_init(void);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index cb02324..ca7f38a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -464,6 +464,10 @@ static void tick_nohz_handler(struct clock_event_device *dev)
 
 	dev->next_event.tv64 = KTIME_MAX;
 
+	ts->last_events0 = ts->last_events1;
+	ts->last_events1 = ts->last_events2;
+	ts->last_events2 = now;
+
 	/*
 	 * Check if the do_timer duty was dropped. We don't care about
 	 * concurrency: This happens only when the cpu in charge went
@@ -565,6 +569,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	ktime_t now = ktime_get();
 	int cpu = smp_processor_id();
 
+	ts->last_events0 = ts->last_events1;
+	ts->last_events1 = ts->last_events2;
+	ts->last_events2 = now;
+
 #ifdef CONFIG_NO_HZ
 	/*
 	 * Check if the do_timer duty was dropped. We don't care about
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index a40e20f..a086926 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -172,6 +172,9 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
+		P_ns(last_events0);
+		P_ns(last_events1);
+		P_ns(last_events2);
 		SEQ_printf(m, "jiffies: %Lu\n",
 			   (unsigned long long)jiffies);
 	}
