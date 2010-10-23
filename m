Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34921 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab0JWDQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 23:16:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 20:16:11 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <amod.bodas@atheros.com>,
	<pstew@google.com>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<stable@kernel.org>
Subject: [RFT] mac80211: fix null pointer dereference on ieee80211_stop_tx_ba_session()
Date: Fri, 22 Oct 2010 20:16:18 -0700
Message-ID: <1287803778-10330-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RCU was not being used so we could race against the free'ing of the TID.

This should cure this panic:

IP: [<c03c6dea>] ieee80211_stop_tx_ba_session+0xa4/0xb6 [mac80211]
*pdpt = 0000000030495001 *pde = 0000000000000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-3/1-3:1.0/bInterfaceClass
Modules linked in: QCUSBNet2k usbnet uvcvideo qcserial videodev usb_wwan snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd nm10_gpio i2c_i801 soundcore snd_page_alloc rfcomm sco bnep l2cap btusb bluetooth i2c_dev ath3k tpm_tis tpm tpm_bios ath9k mac80211 ath9k_common ath9k_hw ath cfg80211 serio_raw

Pid: 3263, comm: chrome Not tainted (2.6.32.23+drm33.10 #1) Mario
EIP: 0060:[<c03c6dea>] EFLAGS: 00010202 CPU: 0
EIP is at ieee80211_stop_tx_ba_session+0xa4/0xb6 [mac80211]
EAX: b0642fd2 EBX: bdf90968 ECX: 455f524f EDX: 0000002e
ESI: 81573380 EDI: c03c6dcb EBP: b17dff24 ESP: b17dff24
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process chrome (pid: 3263, ti=b17de000 task=bbd869a0 task.ti=b17de000)
Stack:
 b17dff60 81037693 b17dff4c 0000029b b06431a0 81574190 81573f90 81573d90
<0> 81573b90 00000100 b17dff4c b17dff4c 8146fa04 81e02974 00000001 b17dff88
<0> 810319e8 00000000 815183e0 0000000a 00000100 00000101 00000046 81e02974
Call Trace:
 [<81037693>] ? run_timer_softirq+0x166/0x1e7
 [<810319e8>] ? __do_softirq+0xa7/0x144
 [<81031ab0>] ? do_softirq+0x2b/0x30
 [<81031b8c>] ? irq_exit+0x2e/0x61
 [<81015106>] ? smp_apic_timer_interrupt+0x6d/0x7b
 [<810035b5>] ? apic_timer_interrupt+0x31/0x38
Code: ff ff ff 59 89 f8 5b 5b 5e 5f 5d c3 55 89 e5 0f 1f 44 00 00 0f b6 10 29 d0 2d a0 01 00 00 8d 8c 90 4c 01 00 00 8b 09 85 c9 74 10 <f6> 41 48 02 75 0a 05 b8 01 00 00 e8 4c ff ff ff 5d c3 55 89 e5 
EIP: [<c03c6dea>] ieee80211_stop_tx_ba_session+0xa4/0xb6 [mac80211] SS:ESP 0068:b17dff24
CR2: 00000000455f5297
---[ end trace c8aa74f71bb40410 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 3263, comm: chrome Tainted: G      D    2.6.32.23+drm33.10 #1
Call Trace:
 [<8133f71d>] ? printk+0x14/0x17
 [<8133f663>] panic+0x3e/0xe4
 [<81005dcc>] oops_end+0x73/0x81
 [<81019dd4>] no_context+0x13c/0x146
 [<81019ec3>] __bad_area_nosemaphore+0xe5/0xed
 [<81019edd>] bad_area_nosemaphore+0x12/0x15
 [<8101a0f7>] do_page_fault+0xff/0x23c
 [<81019ff8>] ? do_page_fault+0x0/0x23c
 [<81341453>] error_code+0x73/0x78
 [<c03c6dcb>] ? ieee80211_stop_tx_ba_session+0x85/0xb6 [mac80211]
 [<8101007b>] ? set_mtrr_ops+0x13/0x1b
 [<810400d8>] ? sys_clock_gettime+0xe/0x7d
 [<c03c6dea>] ? ieee80211_stop_tx_ba_session+0xa4/0xb6 [mac80211]
 [<81037693>] run_timer_softirq+0x166/0x1e7
 [<810319e8>] __do_softirq+0xa7/0x144
 [<81031ab0>] do_softirq+0x2b/0x30
 [<81031b8c>] irq_exit+0x2e/0x61
 [<81015106>] smp_apic_timer_interrupt+0x6d/0x7b
 [<810035b5>] apic_timer_interrupt+0x31/0x38

For details refer to:

http://code.google.com/p/chromium-os/issues/detail?id=8054

Cc: Amod Bodas <amod.bodas@atheros.com>
Cc: Paul Stewart <pstew@google.com>
Cc: stable@kernel.org
Reported-by: Sam Leffler <sleffler@google.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Sam, please test and let me know if this fixes the issue you saw today.
Its the only way I see this being possible.

 net/mac80211/agg-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d4679b2..badd4b1 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -610,7 +610,7 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 		return -EINVAL;
 
 	spin_lock_bh(&sta->lock);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 
 	if (!tid_tx) {
 		ret = -ENOENT;
-- 
1.7.1

