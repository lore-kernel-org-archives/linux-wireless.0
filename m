Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from x346.tv-sign.ru ([89.108.83.215]:34801 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYBZB0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 20:26:55 -0500
Date: Tue, 26 Feb 2008 04:25:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10068] New: timer.c crash using WI-FI (current process: firefox)
Message-ID: <20080226012557.GA2247@tv-sign.ru> (sfid-20080226_012700_113377_4F8FEBD6)
References: <bug-10068-10286@http.bugzilla.kernel.org/> <20080225162824.0af4a57d.akpm@linux-foundation.org> <20080226010301.GA1318@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080226010301.GA1318@tv-sign.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26, Oleg Nesterov wrote:
>
> On 02/25, Andrew Morton wrote:
> >
> > On Fri, 22 Feb 2008 11:16:40 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > Kernel BUG at kernel/timer.c: 607!
> > > Invalid opcode: 0000 [#1]
> > > Modules linked in: cpufreq_stats nls_cp437 sbp2 scsi_mod loop zd1211rw
> > > ieee80211softmac parport_pc parport ohci1394 snd_intel8x0 ieee1394 sis900
> > > ehci_hcd ide_cd cdrom fan asus_acpi backlight battery ac
> > > 
> > > Pid 3239, comm: firefox-bin Not tainted (2.6.24.2 #1)
> > > EIP:0060 :[<c011e54b>] EFLAGS:00210007 CPU:0
> > > EIP is at cascade+0x3b/0x57
> > > EAX:0 EBX:0 ECX:5 EDX:d9eb3ca4
> > > ESI:5 EDI:c0485640 EBP:d9ecdf30 ESP:d9ecdf30
> > > DS:007b ES:007b FS:0000 GS:0033 SS:0068
> > > 
> > > ...
> > > 
> > > Call trace
> > > 
> > > [<c011e6ad>] run_timer_softirq+0x55/0x141
> > > [<c012b8e3>] tick_handle_periodic+0xf/0x54
> > > [<c011bdcc>] __do_softirq+0x35/0x75
> > > [<c011be2e>] do_softirq+022/0x26
> > > [<c01055b0>] do_IRQ+0x58/0x6b
> > > [<c033b1a7>] schedule+0x1f0/0x20a
> > > [<c01045e7>] common_interrupt+0x23/0x28
> > > 
> > > Kernel Panic - not syncing: Fatal exception in interrupt
> > > 
> > 
> > urgh.
> > 
> > Yes, it's probably a wireless driver bug.  But look at the BUG_ON():
> > 
> > static int cascade(tvec_base_t *base, tvec_t *tv, int index)
> > {
> > 	/* cascade all the timers from tv up one level */
> > 	struct timer_list *timer, *tmp;
> > 	struct list_head tv_list;
> > 
> > 	list_replace_init(tv->vec + index, &tv_list);
> > 
> > 	/*
> > 	 * We are removing _all_ timers from the list, so we
> > 	 * don't have to detach them individually.
> > 	 */
> > 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
> > 		BUG_ON(tbase_get_base(timer->base) != base);
> > 		internal_add_timer(base, timer);
> > 	}
> > 
> > 	return index;
> > }
> > 
> > if we're going to detect some bug, we shold provide _some_ information
> > telling the poor programmer what he did wrong!  This one is very obscure.
> > 
> > Seems we found a timer on CPU A's list, but the timer thinks it's on timer
> > B's list.  Or not on a list at all.
> >
> > Question is: what sequence of timer interace calls could have caused this
> > to occur?  And can we add a check for that bug at the time where it occurs,
> > rather later on in the timer interrupt handler?
> 
> Most probably the pending timer was corrupted. Say it was freed/reused
> without del_timer(), or re-initialized.
> 
> Marco, could you try this patch
> 	http://bugzilla.kernel.org/attachment.cgi?id=14183
> ?
> 
> see also http://bugzilla.kernel.org/attachment.cgi?id=14183

Argh. It can't be applied because of
	"time: clean hungarian notation from timers"
	commit a6fa8e5a6172a5a5bc06ed04f34e50b36c978127

Please find the re-diff below. hopefully it still works. but it doesn't
like CONFIG_HOTPLUG_CPU.

Oleg.

--- MM/include/linux/timer.h~TMR_DBG	2008-02-17 23:40:09.000000000 +0300
+++ MM/include/linux/timer.h	2008-02-26 04:07:15.000000000 +0300
@@ -8,6 +8,7 @@
 struct tvec_base;
 
 struct timer_list {
+	void (*next_func)(unsigned long);
 	struct list_head entry;
 	unsigned long expires;
 
--- MM/kernel/timer.c~TMR_DBG	2008-02-17 23:41:28.000000000 +0300
+++ MM/kernel/timer.c	2008-02-26 04:14:15.000000000 +0300
@@ -58,12 +58,19 @@ EXPORT_SYMBOL(jiffies_64);
 #define TVN_MASK (TVN_SIZE - 1)
 #define TVR_MASK (TVR_SIZE - 1)
 
+struct xxx {
+	void (*next_func)(unsigned long);
+	struct list_head list;
+};
+
+#define tox(p)	list_entry((p), struct timer_list, entry)
+
 struct tvec {
-	struct list_head vec[TVN_SIZE];
+	struct xxx vec[TVN_SIZE];
 };
 
 struct tvec_root {
-	struct list_head vec[TVR_SIZE];
+	struct xxx vec[TVR_SIZE];
 };
 
 struct tvec_base {
@@ -256,7 +263,7 @@ static void internal_add_timer(struct tv
 {
 	unsigned long expires = timer->expires;
 	unsigned long idx = expires - base->timer_jiffies;
-	struct list_head *vec;
+	struct xxx *vec;
 
 	if (idx < TVR_SIZE) {
 		int i = expires & TVR_MASK;
@@ -291,7 +298,9 @@ static void internal_add_timer(struct tv
 	/*
 	 * Timers are FIFO:
 	 */
-	list_add_tail(&timer->entry, vec);
+	list_add_tail(&timer->entry, &vec->list);
+	timer->next_func = tox(timer->entry.next)->function;
+	tox(timer->entry.prev)->next_func = timer->function;
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -351,6 +360,7 @@ static inline void detach_timer(struct t
 {
 	struct list_head *entry = &timer->entry;
 
+	tox(entry->prev)->next_func = timer->next_func;
 	__list_del(entry->prev, entry->next);
 	if (clear_pending)
 		entry->next = NULL;
@@ -594,15 +604,22 @@ static int cascade(struct tvec_base *bas
 	/* cascade all the timers from tv up one level */
 	struct timer_list *timer, *tmp;
 	struct list_head tv_list;
+	void (*func)(unsigned long) = tv->vec[index].next_func;
 
-	list_replace_init(tv->vec + index, &tv_list);
+	list_replace_init(&tv->vec[index].list, &tv_list);
 
 	/*
 	 * We are removing _all_ timers from the list, so we
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(tbase_get_base(timer->base) != base);
+		if (tbase_get_base(timer->base) != base || timer->function != func) {
+			print_symbol(KERN_CRIT "ERR!! 1 %s\n", (unsigned long)func);
+			print_symbol(KERN_CRIT "ERR!! 2 %s\n", (unsigned long)timer->function);
+			printk(KERN_CRIT "ERR!! 3 %p %p\n", base, timer->base);
+			break;
+		}
+		func = timer->next_func;
 		internal_add_timer(base, timer);
 	}
 
@@ -624,8 +641,8 @@ static inline void __run_timers(struct t
 
 	spin_lock_irq(&base->lock);
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
-		struct list_head work_list;
-		struct list_head *head = &work_list;
+		struct xxx work_list;
+		struct list_head *head = &work_list.list;
 		int index = base->timer_jiffies & TVR_MASK;
 
 		/*
@@ -637,7 +654,7 @@ static inline void __run_timers(struct t
 					!cascade(base, &base->tv4, INDEX(2)))
 			cascade(base, &base->tv5, INDEX(3));
 		++base->timer_jiffies;
-		list_replace_init(base->tv1.vec + index, &work_list);
+		list_replace_init(&base->tv1.vec[index].list, &work_list.list);
 		while (!list_empty(head)) {
 			void (*fn)(unsigned long);
 			unsigned long data;
@@ -1264,13 +1281,13 @@ static int __cpuinit init_timers_cpu(int
 	spin_lock_init(&base->lock);
 
 	for (j = 0; j < TVN_SIZE; j++) {
-		INIT_LIST_HEAD(base->tv5.vec + j);
-		INIT_LIST_HEAD(base->tv4.vec + j);
-		INIT_LIST_HEAD(base->tv3.vec + j);
-		INIT_LIST_HEAD(base->tv2.vec + j);
+		INIT_LIST_HEAD(&base->tv5.vec[j].list);
+		INIT_LIST_HEAD(&base->tv4.vec[j].list);
+		INIT_LIST_HEAD(&base->tv3.vec[j].list);
+		INIT_LIST_HEAD(&base->tv2.vec[j].list);
 	}
 	for (j = 0; j < TVR_SIZE; j++)
-		INIT_LIST_HEAD(base->tv1.vec + j);
+		INIT_LIST_HEAD(&base->tv1.vec[j].list);
 
 	base->timer_jiffies = jiffies;
 	return 0;

