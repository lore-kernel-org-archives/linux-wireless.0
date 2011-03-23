Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:42869 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1CWRh3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 13:37:29 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 10:37:05 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 1/2] ath9k: Fix kernel panic caused by invalid rate index access.
Date: Wed, 23 Mar 2011 23:07:21 +0530
Message-ID: <1300901842-3350-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the recent tx status optimization in mac80211, we bail out as
and and when invalid rate index is found. So the behavior of resetting
rate idx to -1 and count to 0 has changed for the rate indexes that
were not part of the driver's retry series.

This has resulted in ath9k using incorrect rate table index which
caused the system to panic. Ideally ath9k need to loop only for the
indexes that were part of the retry series and so simply use hw->max_rates
as the loop counter.

Pasted the stack trace of the panic issue for reference.

[  754.093192] BUG: unable to handle kernel paging request at ffff88046a9025b0
[  754.093256] IP: [<ffffffffa02eac49>] ath_tx_status+0x209/0x2f0 [ath9k]
[  754.094888] Call Trace:
[  754.094903]  <IRQ>
[  754.094928]  [<ffffffffa051f883>] ieee80211_tx_status+0x203/0x9e0 [mac80211]
[  754.094975]  [<ffffffffa053e305>] ? __ieee80211_wake_queue+0x125/0x140 [mac80211]
[  754.095017]  [<ffffffffa02e66c9>] ath_tx_complete_buf+0x1b9/0x370 [ath9k]
[  754.095054]  [<ffffffffa02e6fcf>] ath_tx_complete_aggr+0x51f/0xb50 [ath9k]
[  754.095098]  [<ffffffffa05382a3>] ? ieee80211_prepare_and_rx_handle+0x173/0xab0 [mac80211]
[  754.095148]  [<ffffffff81350e62>] ? _raw_spin_unlock_irqrestore+0x32/0x40
[  754.095186]  [<ffffffffa02e9735>] ath_tx_tasklet+0x365/0x4b0 [ath9k]
[  754.095224]  [<ffffffff8107a2a2>] ? clockevents_program_event+0x62/0xa0
[  754.095261]  [<ffffffffa02e2628>] ath9k_tasklet+0x168/0x1c0 [ath9k]
[  754.095298]  [<ffffffff8105599b>] tasklet_action+0x6b/0xe0
[  754.095331]  [<ffffffff81056278>] __do_softirq+0x98/0x120
[  754.095361]  [<ffffffff8100cd5c>] call_softirq+0x1c/0x30
[  754.095393]  [<ffffffff8100efb5>] do_softirq+0x65/0xa0
[  754.095423]  [<ffffffff810563fd>] irq_exit+0x8d/0x90
[  754.095453]  [<ffffffff8100ebc1>] do_IRQ+0x61/0xe0
[  754.095482]  [<ffffffff81351413>] ret_from_intr+0x0/0x15
[  754.095513]  <EOI>
[  754.095531]  [<ffffffff81014375>] ? native_sched_clock+0x15/0x70
[  754.096475]  [<ffffffffa02bcfa6>] ? acpi_idle_enter_bm+0x24d/0x285 [processor]
[  754.096475]  [<ffffffffa02bcf9f>] ? acpi_idle_enter_bm+0x246/0x285 [processor]
[  754.096475]  [<ffffffff8127fab2>] cpuidle_idle_call+0x82/0x100
[  754.096475]  [<ffffffff8100a236>] cpu_idle+0xa6/0xf0
[  754.096475]  [<ffffffff81339bc1>] rest_init+0x91/0xa0
[  754.096475]  [<ffffffff814efccd>] start_kernel+0x3fd/0x408
[  754.096475]  [<ffffffff814ef347>] x86_64_start_reservations+0x132/0x136
[  754.096475]  [<ffffffff814ef451>] x86_64_start_kernel+0x106/0x115
[  754.096475] RIP  [<ffffffffa02eac49>] ath_tx_status+0x209/0x2f0 [ath9k]

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 960d717..a3241cd 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1328,7 +1328,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+	for (i = 0; i < sc->hw->max_rates; i++) {
 		struct ieee80211_tx_rate *rate = &tx_info->status.rates[i];
 		if (!rate->count)
 			break;
-- 
1.7.3.4

