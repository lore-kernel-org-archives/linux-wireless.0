Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10805 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbYE1OiR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 10:38:17 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 07:38:17 -0700
Date: Wed, 28 May 2008 20:08:12 +0530
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <lrodriguez@atheros.com>, <ron.rindjunsky@intel.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix for NULL pointer dereference in
	sta_info_get()
Message-ID: <20080528143812.GA5244@senthil-lnx.users.atheros.com> (sfid-20080528_163820_713411_3D0A1C18)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses a NULL pointer dereference in sta_info_get().
TID and sta_info are extracted in ADDBA Timer expiry function
through the timer handler's argument.

The problem is extracging the TID (which was stored in
timer_to_tid[] array of type "u8") through "int *" typecast which
may also yield unwanted bytes for the MSB of TID that results
in incorrect sta_info and ieee80211_local pointers.

ieee80211_local pointer is NULL as illustrated below, it crashes in
sta_info_get(). The problem started when extracting ieee80211_local
pointer out of sta_info iteself and eventually crashed in
stat_info_get().

The proper way to fix is to change the data type of TID to u8
instead of u16. However changing all the occurences requires
some prototype changes as well. We should fix this in upcoming
patches.

BUG: unable to handle kernel NULL pointer dereference at 000000e8
IP: [<c038c0c5>] _read_lock_bh+0x15/0x30
*pde = 00000000
Oops: 0002 [#1] PREEMPT SMP
Modules -- lengthy line --

Pid: 0, comm: swapper Tainted: P         (2.6.25-rc3-wl #3)
EIP: 0060:[<c038c0c5>] EFLAGS: 00010202 CPU: 1
EIP is at _read_lock_bh+0x15/0x30
EAX: 000000e8 EBX: 000000e8 ECX: 00000103 EDX: f7e74f14
ESI: 00000103 EDI: f789c000 EBP: 000000e8 ESP: f7891e5c
DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=f7890000 task=f7888b00 task.ti=f7890000)
Stack: 00000000 f8e917f9 f7e74f14 f789c000 f7e74f14 00000103 f789c000 00000000
f8e98583 f8ead92e 000000e8 f7e74f00 00000000 00000100 f7e74f14 f7e75924
00000103 f789c000 f7891ed0 c01334a8 f8e98520 f7e755b8 00000000 00000ceb
Call Trace:
[<f8e917f9>] sta_info_get+0x19/0x60 [mac80211]
[<f8e98583>] sta_addba_resp_timer_expired+0x63/0x120 [mac80211]
[<c01334a8>] run_timer_softirq+0x128/0x1f0
[<f8e98520>] sta_addba_resp_timer_expired+0x0/0x120 [mac80211]
[<f8e98520>] sta_addba_resp_timer_expired+0x0/0x120 [mac80211]
[<c012f5ba>] __do_softirq+0x8a/0x110
[<c012f695>] do_softirq+0x55/0x60
[<c012f89d>] irq_exit+0x6d/0x90
[<c0116705>] smp_apic_timer_interrupt+0x55/0x80
[<c0147d95>] tick_notify+0x275/0x3b0
[<c012f882>] irq_exit+0x52/0x90
[<c0105c24>] apic_timer_interrupt+0x28/0x30
[<c038c2b7>] _spin_unlock_irqrestore+0x7/0x30
[<c027fcf4>] acpi_get_register+0x2a/0x30
[<f8b1ae95>] acpi_idle_enter_bm+0x59/0x376 [processor]
[<c0143713>] pm_qos_requirement+0x23/0x30
[<c02dc35d>] cpuidle_idle_call+0x7d/0xc0
[<c02dc2e0>] cpuidle_idle_call+0x0/0xc0
[<c0103f15>] cpu_idle+0x65/0x110
=======================
Code: 00 01 74 05 e8 81 fb ff ff 5b c3 8d 74 26 00 8d bc 27 00 00
00 00 53 89 c3 e8 e8 33 da ff 89 e0 25 00 e0 ff ff 83 40 14 01 89
d8 <f0> 83 28 01 79 05 e8 70 fb ff ff 5b c3 8d b4 26 00 00 00 00 8d
EIP: [<c038c0c5>] _read_lock_bh+0x15/0x30 SS:ESP 0068:f7891e5c
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c7819fd..0eb739d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1604,7 +1604,7 @@ void sta_addba_resp_timer_expired(unsigned long data)
 	 * only one argument, and both sta_info and TID are needed, so init
 	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
-	u16 tid = *(int *)data;
+	u16 tid = *(u8 *)data;
 	struct sta_info *temp_sta = container_of((void *)data,
 		struct sta_info, timer_to_tid[tid]);
 
@@ -1652,7 +1652,7 @@ timer_expired_exit:
 static void sta_rx_agg_session_timer_expired(unsigned long data)
 {
 	/* not an elegant detour, but there is no choice as the timer passes
-	 * only one argument, and verious sta_info are needed here, so init
+	 * only one argument, and various sta_info are needed here, so init
 	 * flow in sta_info_create gives the TID as data, while the timer_to_id
 	 * array gives the sta through container_of */
 	u8 *ptid = (u8 *)data;
-- 
1.5.2.2

