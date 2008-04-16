Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838AbYDPWzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 18:55:48 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE:  RE: iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 15:55:46 -0700
Message-ID: <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com> (sfid-20080416_235557_375194_C4D7E48D)
In-Reply-To: A<fu5t7s$mfb$1@ger.gmane.org>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> A<fu5t7s$mfb$1@ger.gmane.org>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Marcus Furlong" <furlongm@hotmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Marcus Furlong  wrote:

> On Wednesday 16 April 2008 22:22 in
> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.in
> tel.com>, Chatre, Reinette wrote:
> 

> Trying to get a wpa_supplicant log but the machine hangs
> reliably pretty
> much every time. Got an oops over the serial cable here:
> 
> [  854.789883] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  854.792850] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
> intel_agp agpgart scsi_wait_scan
> [  854.792850]
> [  854.792850] Pid: 9, comm: events/0 Not tainted (2.6.25-rc9 #2)
> [  854.792850] EIP: 0060:[<c039e62f>] EFLAGS: 00010093 CPU: 0
> [  854.792850] EIP is at alps_process_byte+0x1f/0x80
> [  854.792850] EAX: 00000000 EBX: f73e2280 ECX: f68de400 EDX: 00000000
> [  854.792850] ESI: f68de400 EDI: f722a400 EBP: c0652f2c ESP: c0652f28
> [  854.792850]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [  854.792850] Process events/0 (pid: 9, ti=c0652000 task=f787e000
> task.ti=f7854000) [  854.792850] Stack: f68de400 c0652f48 c039baef
> 00000000 00000002 00000001 c0391d71 00000000
> [  854.792850]        c0652f70 c039c378 00000000 c0652f70
> c047a00a 00000000
> 00000002 f722a400
> [  854.792850]        c05c8560 00000000 c0652f90 c0391d89 00000092
> f722a44c 00000096 00000000
> [  854.792850] Call Trace:
> [  854.792850]  [<c039baef>] ? psmouse_handle_byte+0xf/0x110
> [  854.792850]  [<c0391d71>] ? serio_interrupt+0x21/0x80
> [  854.792850]  [<c039c378>] ? psmouse_interrupt+0xc8/0x2a0
> [  854.792850]  [<c047a00a>] ? _spin_lock_irqsave+0x4a/0x60
> [  854.792850]  [<c0391d89>] ? serio_interrupt+0x39/0x80
> [  854.792850]  [<c0392a69>] ? i8042_interrupt+0x109/0x250
> [  854.792850]  [<c0157c78>] ? handle_IRQ_event+0x28/0x60
> [  854.792850]  [<c01590d3>] ? handle_edge_irq+0xb3/0x140
> [  854.792850]  [<c0159020>] ? handle_edge_irq+0x0/0x140
> [  854.792850]  [<c010738b>] ? do_IRQ+0x8b/0xf0
> [  854.792850]  [<c0104c12>] ? common_interrupt+0x2e/0x34
> [  854.792850]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
> [  854.792850]  [<c047a3a7>] ? _spin_unlock_irqrestore+0x57/0x70
> [  854.792850]  [<c01340b7>] ? __mod_timer+0xa7/0xc0
> [  854.792850]  [<c013b2d4>] ? queue_delayed_work_on+0x84/0xc0
> [  854.792850]  [<c013b4e1>] ? queue_delayed_work+0x51/0x60
> [  854.792850]  [<c013b51a>] ? schedule_delayed_work+0x2a/0x40
> [  854.792850]  [<c0168089>] ? vmstat_update+0x39/0x50
> [  854.792850]  [<c013aa6c>] ? run_workqueue+0x12c/0x1e0
> [  854.792850]  [<c013aa14>] ? run_workqueue+0xd4/0x1e0
> [  854.792850]  [<c047a389>] ? _spin_unlock_irqrestore+0x39/0x70
> [  854.792850]  [<c0168050>] ? vmstat_update+0x0/0x50
> [  854.792850]  [<c013b5c9>] ? worker_thread+0x99/0xf0
> [  854.792850]  [<c013e250>] ? autoremove_wake_function+0x0/0x50
> [  854.792850]  [<c013b530>] ? worker_thread+0x0/0xf0
> [  854.792850]  [<c013df62>] ? kthread+0x42/0x70
> [  854.792850]  [<c013df20>] ? kthread+0x0/0x70
> [  854.792850]  [<c0104e97>] ? kernel_thread_helper+0x7/0x10
> [  854.792850]  =======================
> [  854.792850] Code: b6 00 00 00 00 8d bc 27 00 00 00 00 55 89
> c1 89 e5 53
> 0f b6 90 a0 00 00 00 8b 18 0f b6 c2 25 c8 00 00 00 83 f8 08 74 37 8b
> 43 24 <22> 50 04 3a 50 03 74 09 5b 31 c0 5d c3 8d 74 26 00 0f b6 91 a9
> [  854.792850] EIP: [<c039e62f>] alps_process_byte+0x1f/0x80 SS:ESP
> 0068:c0652f28 
> 
> I guess this is what's causing the jerkiness of the mouse/keyboard.

I don't know what to say about the above ... it seems to be a different
problem.

> 
>> Could you please give more information about what the system is
>> trying to do here? In the first log you sent most failures appear to
>> occur when A band channels are configured ... does this match with
>> what you are trying to do? Can you explain why the BSSID is all
>> zeroes? 
> 
> I have no idea why the BSSID is all zeros. This usually
> happens first thing
> after boot, even with the ipw driver. I usually use wpa_gui to
> select the
> second network in my wpa_supplicant list (which is not
> actually present at
> my current location), then reselect the first network (which
> is present).

Can you send a copy of your wpa_supplicant configuration file (comment
out the private parts)?

> It usually then associates. That's with the ipw driver, so I
> was seeing if
> the same trick would work with the iwl driver (in the first
> log). 

There seems to be a lot going on through initialization scripts of your
distribution. Could you disable all that and try to get up and running
with as little variables as possible? It may be that the interface is
automatically brought up when the module is loaded - this script should
be among your network init scripts. Can you disable that? You can load
the driver with debugging and see through the logs if anything is trying
to use it. The first goal is to load the driver and not have it do any
work after initial load.

After this follow the following steps (I am assuming you are not using
security):
$ /sbin/ip link set dev wlan0 up 
$ iwlist wlan0 scan
Search for your AP in the above output - should match with your
wpa_supplicant conf file.
$ iwconfig wlan0 channel <channel of your AP> ap <MAC of your AP> essid
<essid of your AP> 
$ iwconfig
check above output to see if you are associated
next use your usual net app to get an IP (dhclient?)

Can you associate with the above steps? What do the logs look like? 

> Not sure
> what "A band channels" means, can you explain that and possibly I can
> answer.. 

A band operates at 5GHz as opposed to B and G that operates in 2.4GHz.
Do you know what your AP is configured as?

Reinette




