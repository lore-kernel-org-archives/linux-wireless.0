Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:35287 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbYFQVVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 17:21:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: mac80211 local_bh_enable called with IRQs disabled (was: b43legacy kernel warning)
Date: Tue, 17 Jun 2008 23:20:18 +0200
Cc: "David Ellingsworth" <david@identd.dyndns.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <30353c3d0806171359k6d7be389g23dfc809f288d2f1@mail.gmail.com>
In-Reply-To: <30353c3d0806171359k6d7be389g23dfc809f288d2f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806172320.18778.mb@bu3sch.de> (sfid-20080617_232127_701720_F4D50BB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 June 2008 22:59:52 David Ellingsworth wrote:
> I ran into this error today from a kernel I built last night based on
> the latest wireless-testing branch. Correct me if I'm wrong, but it
> looks to be b43legacy related. I'm a bit new to kernel debugging but
> can try to provide additional information if instructions on how to do
> so are provided.

No, this is a mac80211 bug

> --------------------------------------------------------------------------------------
> dmesg output:
> --------------------------------------------------------------------------------------
> WARNING: at kernel/softirq.c:141 local_bh_enable+0x1f/0x59()
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
> nf_conntrack ip_tables x_tables radeon drm binfmt_misc ppdev lp
> dm_snapshot dm_mirror dm_log dm_mod b43legacy mac80211 cfg80211
> led_class snd_ali5451 snd_ac97_codec ac97_bus snd_pcm_oss
> snd_mixer_oss ati_agp ibmcam usbvideo ssb pcmcia snd_pcm snd_timer
> evdev videodev v4l1_compat container battery ac button firmware_class
> agpgart i2c_ali1535 snd video output parport_pc parport yenta_socket
> rsrc_nonstatic pcmcia_core psmouse serio_raw i2c_ali15x3 i2c_core
> soundcore snd_page_alloc pcspkr reiserfs ide_cd_mod cdrom ide_disk
> alim15x3 natsemi ide_pci_generic ide_core ohci_hcd usbcore thermal
> processor fan
> Pid: 1371, comm: b43legacy Not tainted 2.6.26-rc6-wl #1
>  [<c0113be7>] warn_on_slowpath+0x40/0x66
>  [<c0111c60>] check_preempt_wakeup+0xa2/0xc0
>  [<c0120d0d>] autoremove_wake_function+0xc/0x2b
>  [<c010fc44>] __wake_up_common+0x2d/0x52
>  [<c011126e>] __wake_up+0xf/0x15
>  [<c0113f89>] wake_up_klogd+0x2b/0x2d
>  [<c01981ed>] scnprintf+0x1f/0x2b
>  [<c0117477>] local_bh_enable+0x1f/0x59
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This function does not like being run with IRQs disabled.
WARN_ON_ONCE(irqs_disabled());

>  [<dcf44045>] __sta_info_unlink+0xa9/0x134 [mac80211]
>  [<dcf4453f>] sta_info_unlink+0x9/0xd [mac80211]
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This function disables interrupts

>  [<dcf48968>] ieee80211_associated+0x9f/0x148 [mac80211]
>  [<dcf4b463>] ieee80211_sta_work+0x4cb/0x64f [mac80211]
>  [<c0110392>] update_curr+0x3d/0x52
>  [<c01104ee>] dequeue_entity+0xf/0x8d
>  [<c0111979>] dequeue_task_fair+0x13/0x27
>  [<c010fab2>] dequeue_task+0xa/0x14
>  [<c0249b01>] schedule+0x22e/0x24a
>  [<dcf4af98>] ieee80211_sta_work+0x0/0x64f [mac80211]
>  [<c011e7a7>] run_workqueue+0x63/0xca
>  [<c011ec96>] worker_thread+0x0/0xb7
>  [<c011ed42>] worker_thread+0xac/0xb7
>  [<c0120d01>] autoremove_wake_function+0x0/0x2b
>  [<c011ec96>] worker_thread+0x0/0xb7
>  [<c0120ba6>] kthread+0x36/0x5c
>  [<c0120b70>] kthread+0x0/0x5c
>  [<c010390b>] kernel_thread_helper+0x7/0x10


I'm not sure _why_ local_bh_enable() doesn't like getting called
with interrupts disabled.
The code is a bit weird:

134 void local_bh_enable(void)
135 {
136 #ifdef CONFIG_TRACE_IRQFLAGS
137         unsigned long flags;
138 
139         WARN_ON_ONCE(in_irq());
140 #endif
141         WARN_ON_ONCE(irqs_disabled());
142 
143 #ifdef CONFIG_TRACE_IRQFLAGS
144         local_irq_save(flags);
145 #endif
146         /*
147          * Are softirqs going to be turned on now:
148          */
149         if (softirq_count() == SOFTIRQ_OFFSET)
150                 trace_softirqs_on((unsigned long)__builtin_return_address(0));
151         /*
152          * Keep preemption disabled until we are done with
153          * softirq processing:
154          */
155         sub_preempt_count(SOFTIRQ_OFFSET - 1);
156 
157         if (unlikely(!in_interrupt() && local_softirq_pending()))
158                 do_softirq();
159 
160         dec_preempt_count();
161 #ifdef CONFIG_TRACE_IRQFLAGS
162         local_irq_restore(flags);
163 #endif
164         preempt_check_resched();
165 }
166 EXPORT_SYMBOL(local_bh_enable);



-- 
Greetings Michael.
