Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:33906 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZG3WKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 18:10:52 -0400
Received: by gxk9 with SMTP id 9so3139769gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 15:10:51 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jul 2009 15:05:28 -0700
Message-ID: <43e72e890907301505x16cdf4f3rd7ab5f3f0ae9912c@mail.gmail.com>
Subject: lockdep complaint between ieee80211_process_addba_resp() and
	del_timer_sync()
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get this upon association to my AP, not always reproducible, I
think. I do have my reg patches on top of this but I do not think that
should affect this. The issue is between
ieee80211_process_addba_resp() and del_timer_sync() it seems.

  Luis

[   83.047764] =======================================================
[   83.047982] [ INFO: possible circular locking dependency detected ]
[   83.048100] 2.6.31-rc4-wl #15
[   83.048195] -------------------------------------------------------
[   83.048299] swapper/0 is trying to acquire lock:
[   83.048393]
(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}, at:
[<ffffffff81062cc0>] del_timer_sync+0x0/0xc0
[   83.048739]
[   83.048739] but task is already holding lock:
[   83.048919]  (&sta->lock){+.-...}, at: [<ffffffffa0152454>]
ieee80211_process_addba_resp+0x44/0x110 [mac80211]
[   83.049276]
[   83.049276] which lock already depends on the new lock.
[   83.049277]
[   83.049548]
[   83.049548] the existing dependency chain (in reverse order) is:
[   83.049728]
[   83.049729] -> #1 (&sta->lock){+.-...}:
[   83.050140]        [<ffffffff810857b6>] __lock_acquire+0xd76/0x12b0
[   83.050315]        [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
[   83.050492]        [<ffffffff814f0e01>] _spin_lock_bh+0x31/0x40
[   83.050666]        [<ffffffffa01525ea>]
sta_addba_resp_timer_expired+0x3a/0x90 [mac80211]
[   83.050860]        [<ffffffff8106254e>] run_timer_softirq+0x1be/0x2b0
[   83.051035]        [<ffffffff8105cc2a>] __do_softirq+0xfa/0x1f0
[   83.051210]        [<ffffffff8101322c>] call_softirq+0x1c/0x30
[   83.051385]        [<ffffffff81014a65>] do_softirq+0x95/0xd0
[   83.051559]        [<ffffffff8105c645>] irq_exit+0x85/0xb0
[   83.051682]        [<ffffffff810141a3>] do_IRQ+0x73/0xf0
[   83.051682]        [<ffffffff81012a13>] ret_from_intr+0x0/0x16
[   83.051682]        [<ffffffffffffffff>] 0xffffffffffffffff
[   83.051682]
[   83.051682] -> #0 (&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}:
[   83.051682]        [<ffffffff8108587b>] __lock_acquire+0xe3b/0x12b0
[   83.051682]        [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
[   83.051682]        [<ffffffff81062d0a>] del_timer_sync+0x4a/0xc0
[   83.051682]        [<ffffffffa01524a9>]
ieee80211_process_addba_resp+0x99/0x110 [mac80211]
[   83.051682]        [<ffffffffa015f95f>]
ieee80211_invoke_rx_handlers+0x195f/0x1a90 [mac80211]
[   83.051682]        [<ffffffffa015fdc9>]
__ieee80211_rx_handle_packet+0x339/0x640 [mac80211]
[   83.051682]        [<ffffffffa01607e3>] __ieee80211_rx+0x403/0x6f0 [mac80211]
[   83.051682]        [<ffffffffa0248440>]
ath_rx_send_to_mac80211+0x130/0x140 [ath9k]
[   83.051682]        [<ffffffffa0248bd3>] ath_rx_tasklet+0x6d3/0xb70 [ath9k]
[   83.051682]        [<ffffffffa024680a>] ath9k_tasklet+0xea/0x130 [ath9k]
[   83.051682]        [<ffffffff8105c14d>] tasklet_action+0x7d/0x110
[   83.051682]        [<ffffffff8105cc2a>] __do_softirq+0xfa/0x1f0
[   83.051682]        [<ffffffff8101322c>] call_softirq+0x1c/0x30
[   83.051682]        [<ffffffff81014a65>] do_softirq+0x95/0xd0
[   83.051682]        [<ffffffff8105c645>] irq_exit+0x85/0xb0
[   83.051682]        [<ffffffff810141a3>] do_IRQ+0x73/0xf0
[   83.051682]        [<ffffffff81012a13>] ret_from_intr+0x0/0x16
[   83.051682]        [<ffffffffffffffff>] 0xffffffffffffffff
[   83.051682]
[   83.051682] other info that might help us debug this:
[   83.051682]
[   83.051682] 4 locks held by swapper/0:
[   83.051682]  #0:  (&sc->rx.rxflushlock){+.-...}, at:
[<ffffffffa0246800>] ath9k_tasklet+0xe0/0x130 [ath9k]
[   83.051682]  #1:  (&sc->rx.rxbuflock){+.-...}, at:
[<ffffffffa0248549>] ath_rx_tasklet+0x49/0xb70 [ath9k]
[   83.051682]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffffa01604cf>]
__ieee80211_rx+0xef/0x6f0 [mac80211]
[   83.051682]  #3:  (&sta->lock){+.-...}, at: [<ffffffffa0152454>]
ieee80211_process_addba_resp+0x44/0x110 [mac80211]
[   83.051682]
[   83.051682] stack backtrace:
[   83.051682] Pid: 0, comm: swapper Not tainted 2.6.31-rc4-wl #15
[   83.051682] Call Trace:
[   83.051682]  <IRQ>  [<ffffffff81083f0c>] print_circular_bug_tail+0xac/0x100
[   83.051682]  [<ffffffff8108587b>] __lock_acquire+0xe3b/0x12b0
[   83.051682]  [<ffffffff81085dd3>] lock_acquire+0xe3/0x120
[   83.051682]  [<ffffffff81062cc0>] ? del_timer_sync+0x0/0xc0
[   83.051682]  [<ffffffff81062d0a>] del_timer_sync+0x4a/0xc0
[   83.051682]  [<ffffffff81062cc0>] ? del_timer_sync+0x0/0xc0
[   83.051682]  [<ffffffffa01524a9>]
ieee80211_process_addba_resp+0x99/0x110 [mac80211]
[   83.051682]  [<ffffffffa015dde6>] ?
ieee80211_drop_unencrypted+0x66/0x190 [mac80211]
[   83.051682]  [<ffffffffa015f95f>]
ieee80211_invoke_rx_handlers+0x195f/0x1a90 [mac80211]
[   83.051682]  [<ffffffff810843fd>] ? mark_held_locks+0x6d/0x90
[   83.051682]  [<ffffffff814f0c3f>] ? _spin_unlock_irqrestore+0x3f/0x70
[   83.051682]  [<ffffffff81084647>] ? trace_hardirqs_on_caller+0x67/0x1a0
[   83.051682]  [<ffffffff81063259>] ? mod_timer+0xf9/0x160
[   83.051682]  [<ffffffffa015fdc9>]
__ieee80211_rx_handle_packet+0x339/0x640 [mac80211]
[   83.051682]  [<ffffffffa01607e3>] __ieee80211_rx+0x403/0x6f0 [mac80211]
[   83.051682]  [<ffffffffa01604cf>] ? __ieee80211_rx+0xef/0x6f0 [mac80211]
[   83.051682]  [<ffffffff814f0baf>] ? _spin_unlock_bh+0x2f/0x40
[   83.051682]  [<ffffffffa02481d5>] ? ath_get_virt_hw+0x25/0xa0 [ath9k]
[   83.051682]  [<ffffffffa0248440>] ath_rx_send_to_mac80211+0x130/0x140 [ath9k]
[   83.051682]  [<ffffffffa0248bd3>] ath_rx_tasklet+0x6d3/0xb70 [ath9k]
[   83.051682]  [<ffffffffa0248825>] ? ath_rx_tasklet+0x325/0xb70 [ath9k]
[   83.051682]  [<ffffffffa024680a>] ath9k_tasklet+0xea/0x130 [ath9k]
[   83.051682]  [<ffffffff8105c14d>] tasklet_action+0x7d/0x110
[   83.051682]  [<ffffffff8105cc2a>] __do_softirq+0xfa/0x1f0
[   83.051682]  [<ffffffff8101322c>] call_softirq+0x1c/0x30
[   83.051682]  [<ffffffff81014a65>] do_softirq+0x95/0xd0
[   83.051682]  [<ffffffff8105c645>] irq_exit+0x85/0xb0
[   83.051682]  [<ffffffff810141a3>] do_IRQ+0x73/0xf0
[   83.051682]  [<ffffffff81012a13>] ret_from_intr+0x0/0x16
[   83.051682]  <EOI>  [<ffffffff812a572a>] ? acpi_idle_enter_bm+0x258/0x28d
[   83.051682]  [<ffffffff812a5723>] ? acpi_idle_enter_bm+0x251/0x28d
[   83.051682]  [<ffffffff813cbc25>] ? cpuidle_idle_call+0xa5/0x100
[   83.051682]  [<ffffffff8101114d>] ? cpu_idle+0x6d/0xc0
[   83.051682]  [<ffffffff814d7fe5>] ? rest_init+0x65/0x70
[   83.051682]  [<ffffffff8187fddd>] ? start_kernel+0x3c0/0x475
[   83.051682]  [<ffffffff8187f2b9>] ? x86_64_start_reservations+0x99/0xb9
[   83.051682]  [<ffffffff8187f3df>] ? x86_64_start_kernel+0x106/0x121
[   83.051682]  [<ffffffff8187f140>] ? early_idt_handler+0x0/0x71
