Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760AbYBZA3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 19:29:36 -0500
Date: Mon, 25 Feb 2008 16:28:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10068] New: timer.c crash using WI-FI (current
 process: firefox)
Message-Id: <20080225162824.0af4a57d.akpm@linux-foundation.org> (sfid-20080226_002940_723466_C0417CD5)
In-Reply-To: <bug-10068-10286@http.bugzilla.kernel.org/>
References: <bug-10068-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Feb 2008 11:16:40 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=10068
> 
>            Summary: timer.c crash using WI-FI (current process: firefox)
>            Product: Timers
>            Version: 2.5
>      KernelVersion: 2.6.24.2
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: Other
>         AssignedTo: johnstul@us.ibm.com
>         ReportedBy: zacmarco@yahoo.it
> 
> 
> Latest working kernel version: 2.6.19.2
> Earliest failing kernel version: 2.6.24.2
> Distribution: Debian Lenny/Sid
> Hardware Environment: athlon XP 2400+ using a zd1211 device (driver zd1211rw)
> Software Environment: X11 with Gnome; crashed while using firefox (iceweasel)
> 
> Problem Description:
> System crashes completely. It seems related to wireless network usage, I've
> used my system several times without connecting the wifi device (and without
> any other network interface enabled).
> I haven't found the problem on 2.6.19.2 kernel I think because zd1211rw driver
> didn't work for my card
> Here's the log (not flushed to disk!!!)
> 
> ------------------------------
> 
> Kernel BUG at kernel/timer.c: 607!
> Invalid opcode: 0000 [#1]
> Modules linked in: cpufreq_stats nls_cp437 sbp2 scsi_mod loop zd1211rw
> ieee80211softmac parport_pc parport ohci1394 snd_intel8x0 ieee1394 sis900
> ehci_hcd ide_cd cdrom fan asus_acpi backlight battery ac
> 
> Pid 3239, comm: firefox-bin Not tainted (2.6.24.2 #1)
> EIP:0060 :[<c011e54b>] EFLAGS:00210007 CPU:0
> EIP is at cascade+0x3b/0x57
> EAX:0 EBX:0 ECX:5 EDX:d9eb3ca4
> ESI:5 EDI:c0485640 EBP:d9ecdf30 ESP:d9ecdf30
> DS:007b ES:007b FS:0000 GS:0033 SS:0068
> 
> ...
> 
> Call trace
> 
> [<c011e6ad>] run_timer_softirq+0x55/0x141
> [<c012b8e3>] tick_handle_periodic+0xf/0x54
> [<c011bdcc>] __do_softirq+0x35/0x75
> [<c011be2e>] do_softirq+022/0x26
> [<c01055b0>] do_IRQ+0x58/0x6b
> [<c033b1a7>] schedule+0x1f0/0x20a
> [<c01045e7>] common_interrupt+0x23/0x28
> 
> Kernel Panic - not syncing: Fatal exception in interrupt
> 

urgh.

Yes, it's probably a wireless driver bug.  But look at the BUG_ON():

static int cascade(tvec_base_t *base, tvec_t *tv, int index)
{
	/* cascade all the timers from tv up one level */
	struct timer_list *timer, *tmp;
	struct list_head tv_list;

	list_replace_init(tv->vec + index, &tv_list);

	/*
	 * We are removing _all_ timers from the list, so we
	 * don't have to detach them individually.
	 */
	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
		BUG_ON(tbase_get_base(timer->base) != base);
		internal_add_timer(base, timer);
	}

	return index;
}

if we're going to detect some bug, we shold provide _some_ information
telling the poor programmer what he did wrong!  This one is very obscure.

Seems we found a timer on CPU A's list, but the timer thinks it's on timer
B's list.  Or not on a list at all.

Question is: what sequence of timer interace calls could have caused this
to occur?  And can we add a check for that bug at the time where it occurs,
rather later on in the timer interrupt handler?


