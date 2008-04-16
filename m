Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:36710 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYDPWF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 18:05:58 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JmFlL-0007yg-Q1
	for linux-wireless@vger.kernel.org; Wed, 16 Apr 2008 22:05:55 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 22:05:55 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 16 Apr 2008 22:05:55 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 23:05:43 +0100
Message-ID: <fu5t7s$mfb$1@ger.gmane.org> (sfid-20080416_230607_345574_A66E69A4)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 22:22 in
<D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> On Wednesday, April 16, 2008 1:05 PM, Dan Williams  wrote:
> 
>> On Wed, 2008-04-16 at 20:48 +0100, Marcus Furlong wrote:
>>> On Wednesday 16 April 2008 20:01 in
>> <fu5iel$c45$1@ger.gmane.org>, Marcus
>>> Furlong wrote:
>>> 
>>>> On Wednesday 16 April 2008 19:28 in
>>>> 
>>> 
>>
<D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.in
> tel.com>,
>>>> Chatre, Reinette wrote:
>>>> 
>>>>> Looks like the device is being brought up and down a lot ... are
>>>>> you perhaps running wpa_supplicant or some other user application
>>>>> that is doing this? Could you please give more information about
>>>>> what you were doing when these errors started to appear?
>>>> 
>>>> Yes, wpa_supplicant is running as part of the boot process. Should
>>>> I use some other application? (Do wireless-tools support WPA?) Or
>>>> should I just load the module on it's own and give the dmesg output
>>>> from that?
>>> 
>>> Here is the output from the module loading without wpa_supplicant,
>>> then me reloading it with debug flags, and running ifconfig wlan0
>>> and iwlist scanning. Still some Microcode SW and FW errors in there,
>>> but there's a lot less noise.
>>> 
>>> 
>> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwl3945-output-no-wpasu
>> pplicant.bz2
>> 
>> Interesting; can you run wpa_supplicant again but dump it's detailed
>> output using "-dddt" for us so we can see what it's doing and if it's
>> causing the restarts?
> 
> The driver itself is responsible for many of the restarts because of the
> firmware errors. A wpa_supplicant log will still be useful.

Trying to get a wpa_supplicant log but the machine hangs reliably pretty
much every time. Got an oops over the serial cable here:

[  854.789883] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  854.792850] Modules linked in: i915 drm iwl3945 mac80211 cfg80211
intel_agp agpgart scsi_wait_scan
[  854.792850] 
[  854.792850] Pid: 9, comm: events/0 Not tainted (2.6.25-rc9 #2)
[  854.792850] EIP: 0060:[<c039e62f>] EFLAGS: 00010093 CPU: 0
[  854.792850] EIP is at alps_process_byte+0x1f/0x80
[  854.792850] EAX: 00000000 EBX: f73e2280 ECX: f68de400 EDX: 00000000
[  854.792850] ESI: f68de400 EDI: f722a400 EBP: c0652f2c ESP: c0652f28
[  854.792850]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  854.792850] Process events/0 (pid: 9, ti=c0652000 task=f787e000
task.ti=f7854000)
[  854.792850] Stack: f68de400 c0652f48 c039baef 00000000 00000002 00000001
c0391d71 00000000 
[  854.792850]        c0652f70 c039c378 00000000 c0652f70 c047a00a 00000000
00000002 f722a400 
[  854.792850]        c05c8560 00000000 c0652f90 c0391d89 00000092 f722a44c
00000096 00000000 
[  854.792850] Call Trace:
[  854.792850]  [<c039baef>] ? psmouse_handle_byte+0xf/0x110
[  854.792850]  [<c0391d71>] ? serio_interrupt+0x21/0x80
[  854.792850]  [<c039c378>] ? psmouse_interrupt+0xc8/0x2a0
[  854.792850]  [<c047a00a>] ? _spin_lock_irqsave+0x4a/0x60
[  854.792850]  [<c0391d89>] ? serio_interrupt+0x39/0x80
[  854.792850]  [<c0392a69>] ? i8042_interrupt+0x109/0x250
[  854.792850]  [<c0157c78>] ? handle_IRQ_event+0x28/0x60
[  854.792850]  [<c01590d3>] ? handle_edge_irq+0xb3/0x140
[  854.792850]  [<c0159020>] ? handle_edge_irq+0x0/0x140
[  854.792850]  [<c010738b>] ? do_IRQ+0x8b/0xf0
[  854.792850]  [<c0104c12>] ? common_interrupt+0x2e/0x34
[  854.792850]  [<c01400d8>] ? posix_cpu_timer_set+0x368/0x430
[  854.792850]  [<c047a3a7>] ? _spin_unlock_irqrestore+0x57/0x70
[  854.792850]  [<c01340b7>] ? __mod_timer+0xa7/0xc0
[  854.792850]  [<c013b2d4>] ? queue_delayed_work_on+0x84/0xc0
[  854.792850]  [<c013b4e1>] ? queue_delayed_work+0x51/0x60
[  854.792850]  [<c013b51a>] ? schedule_delayed_work+0x2a/0x40
[  854.792850]  [<c0168089>] ? vmstat_update+0x39/0x50
[  854.792850]  [<c013aa6c>] ? run_workqueue+0x12c/0x1e0
[  854.792850]  [<c013aa14>] ? run_workqueue+0xd4/0x1e0
[  854.792850]  [<c047a389>] ? _spin_unlock_irqrestore+0x39/0x70
[  854.792850]  [<c0168050>] ? vmstat_update+0x0/0x50
[  854.792850]  [<c013b5c9>] ? worker_thread+0x99/0xf0
[  854.792850]  [<c013e250>] ? autoremove_wake_function+0x0/0x50
[  854.792850]  [<c013b530>] ? worker_thread+0x0/0xf0
[  854.792850]  [<c013df62>] ? kthread+0x42/0x70
[  854.792850]  [<c013df20>] ? kthread+0x0/0x70
[  854.792850]  [<c0104e97>] ? kernel_thread_helper+0x7/0x10
[  854.792850]  =======================
[  854.792850] Code: b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 c1 89 e5 53
0f b6 90 a0 00 00 00 8b 18 0f b6 c2 25 c8 00 00 00 83 f8 08 74 37 8b 43 24
<22> 50 04 3a 50 03 74 09 5b 31 c0 5d c3 8d 74 26 00 0f b6 91 a9 
[  854.792850] EIP: [<c039e62f>] alps_process_byte+0x1f/0x80 SS:ESP
0068:c0652f28

I guess this is what's causing the jerkiness of the mouse/keyboard.

> Could you please give more information about what the system is trying
> to do here? In the first log you sent most failures appear to occur when
> A band channels are configured ... does this match with what you are
> trying to do? Can you explain why the BSSID is all zeroes?

I have no idea why the BSSID is all zeros. This usually happens first thing
after boot, even with the ipw driver. I usually use wpa_gui to select the
second network in my wpa_supplicant list (which is not actually present at
my current location), then reselect the first network (which is present).
It usually then associates. That's with the ipw driver, so I was seeing if
the same trick would work with the iwl driver (in the first log). Not sure
what "A band channels" means, can you explain that and possibly I can
answer..

Marcus.

