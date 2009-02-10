Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:38465 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZBJQeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 11:34:12 -0500
Message-ID: <4991AC67.90104@openwrt.org> (sfid-20090210_173417_726855_7504F887)
Date: Tue, 10 Feb 2009 17:33:43 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: soft-safe -> soft-unsafe lock order detected
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm testing the ath9k driver in STA mode on an Atheros AR913x based board.
Yesterday while i have transferred a large file through wireless link, i got
this little gem with kernel 2.6.28.2 and compat-wireless-2009-02-02.

======================================================
[ INFO: soft-safe -> soft-unsafe lock order detected ]
2.6.28.2 #106
------------------------------------------------------
phy0/443 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&local->key_lock){....}, at: [<c0206e4c>] ieee80211_key_free+0x78/0xe0 [mac80211]

and this task is already holding:
 (&local->sta_lock){.+..}, at: [<c01ebc5c>] sta_info_unlink+0x34/0x70 [mac80211]
which would create a new lock dependency:
 (&local->sta_lock){.+..} -> (&local->key_lock){....}

but this new dependency connects a soft-irq-safe lock:
 (&local->sta_lock){.+..}
... which became soft-irq-safe at:
  [<800b21cc>] __lock_acquire+0x5a8/0x844
  [<800b24c4>] lock_acquire+0x5c/0x84
  [<8006b980>] _spin_lock_irqsave+0x50/0x74
  [<c020570c>] ieee80211_beacon_get+0x14c/0x3a4 [mac80211]
  [<c0341e08>] ath9k_beacon_tasklet+0x304/0x5c4 [ath9k]
  [<8008fd60>] tasklet_action+0x84/0xf0
  [<8008f74c>] __do_softirq+0x7c/0x130
  [<8008f84c>] do_softirq+0x4c/0xa0
  [<8006082c>] ret_from_irq+0x0/0x4
  [<80060b00>] r4k_wait+0x20/0x40
  [<8006dd50>] cpu_idle+0x20/0x40

to a soft-irq-unsafe lock:
 (todo_lock){--..}
... which became soft-irq-unsafe at:
...  [<800b2248>] __lock_acquire+0x624/0x844
  [<800b24c4>] lock_acquire+0x5c/0x84
  [<8006b8c4>] _spin_lock+0x34/0x48
  [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]

other info that might help us debug this:

4 locks held by phy0/443:
 #0:  ((wiphy_name(local->hw.wiphy))){--..}, at: [<8009c900>]
run_workqueue+0x5c/0x230
 #1:  (&ifsta->work){--..}, at: [<8009c900>] run_workqueue+0x5c/0x230
 #2:  (rcu_read_lock){..--}, at: [<c01f462c>]
ieee80211_sta_set_bssid+0x5bc/0x6c8 [mac80211]
 #3:  (&local->sta_lock){.+..}, at: [<c01ebc5c>] sta_info_unlink+0x34/0x70
[mac80211]

the soft-irq-safe lock's dependencies:
-> (&local->sta_lock){.+..} ops: 0 {
   initial-use  at:
                        [<800b2260>] __lock_acquire+0x63c/0x844
                        [<800b24c4>] lock_acquire+0x5c/0x84
                        [<8006b980>] _spin_lock_irqsave+0x50/0x74
                        [<c01ec30c>] sta_info_flush+0xa0/0x26c [mac80211]
                        [<c01f9950>] ieee80211_if_change_type+0xd10/0x122c
[mac80211]
                        [<c01f98ac>] ieee80211_if_change_type+0xc6c/0x122c
[mac80211]
   in-softirq-W at:
                        [<800b21cc>] __lock_acquire+0x5a8/0x844
                        [<800b24c4>] lock_acquire+0x5c/0x84
                        [<8006b980>] _spin_lock_irqsave+0x50/0x74
                        [<c020570c>] ieee80211_beacon_get+0x14c/0x3a4 [mac80211]
                        [<c0341e08>] ath9k_beacon_tasklet+0x304/0x5c4 [ath9k]
                        [<8008fd60>] tasklet_action+0x84/0xf0
                        [<8008f74c>] __do_softirq+0x7c/0x130
                        [<8008f84c>] do_softirq+0x4c/0xa0
                        [<8006082c>] ret_from_irq+0x0/0x4
                        [<80060b00>] r4k_wait+0x20/0x40
                        [<8006dd50>] cpu_idle+0x20/0x40
 }
 ... key      at: [<c0223d70>] __this_module+0x190/0xffff29dc [mac80211]
 -> (&sta->flaglock){.+..} ops: 0 {
    initial-use  at:
                          [<800b2260>] __lock_acquire+0x63c/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b980>] _spin_lock_irqsave+0x50/0x74
                          [<c01ff8b4>] ieee80211_rx_irqsafe+0x14fc/0x3a9c [mac80211]
                          [<801d2508>] dev_alloc_skb+0x1c/0x48
    in-softirq-W at:
                          [<800b21cc>] __lock_acquire+0x5a8/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b980>] _spin_lock_irqsave+0x50/0x74
                          [<c01ff8b4>] ieee80211_rx_irqsafe+0x14fc/0x3a9c [mac80211]
                          [<801d2508>] dev_alloc_skb+0x1c/0x48
  }
  ... key      at: [<c0223d78>] __this_module+0x198/0xffff29dc [mac80211]
 ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b980>] _spin_lock_irqsave+0x50/0x74
   [<c01ebae4>] ieee80211_alloc_hw+0x2320/0x2464 [mac80211]

 -> (&txq->axq_lock){-+..} ops: 0 {
    initial-use  at:
                          [<800b2260>] __lock_acquire+0x63c/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b918>] _spin_lock_bh+0x40/0x58
                          [<c0348ac4>] ath_draintxq+0x54/0x2f8 [ath9k]
                          [<c034a530>] ath_drain_all_txq+0x164/0x194 [ath9k]
                          [<c0343f50>] ath_rf_name+0x196c/0x2418 [ath9k]
    in-softirq-W at:
                          [<800b21cc>] __lock_acquire+0x5a8/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b918>] _spin_lock_bh+0x40/0x58
                          [<c0349d2c>] ath_tx_tasklet+0xf0/0x5e8 [ath9k]
                          [<c0345034>] ath_reset+0x568/0x948 [ath9k]
    hardirq-on-W at:
                          [<800b2224>] __lock_acquire+0x600/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b918>] _spin_lock_bh+0x40/0x58
                          [<c0348ac4>] ath_draintxq+0x54/0x2f8 [ath9k]
                          [<c034a530>] ath_drain_all_txq+0x164/0x194 [ath9k]
                          [<c0343f50>] ath_rf_name+0x196c/0x2418 [ath9k]
  }
  ... key      at: [<c036b8d8>] btcoex_enable+0x5d4/0xfffe32d8 [ath9k]
 ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b8c4>] _spin_lock+0x34/0x48
   [<c034ad9c>] ath_tx_node_cleanup+0x64/0x194 [ath9k]
   [<c01ebb90>] ieee80211_alloc_hw+0x23cc/0x2464 [mac80211]


the soft-irq-unsafe lock's dependencies:
-> (todo_lock){--..} ops: 0 {
   initial-use  at:
                        [<800b2260>] __lock_acquire+0x63c/0x844
                        [<800b24c4>] lock_acquire+0x5c/0x84
                        [<8006b8c4>] _spin_lock+0x34/0x48
                        [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0
[mac80211]
   softirq-on-W at:
                        [<800b2248>] __lock_acquire+0x624/0x844
                        [<800b24c4>] lock_acquire+0x5c/0x84
                        [<8006b8c4>] _spin_lock+0x34/0x48
                        [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0
[mac80211]
   hardirq-on-W at:
                        [<800b2224>] __lock_acquire+0x600/0x844
                        [<800b24c4>] lock_acquire+0x5c/0x84
                        [<8006b8c4>] _spin_lock+0x34/0x48
                        [<c0206d9c>] ieee80211_set_default_key+0x4b8/0x4f0
[mac80211]
 }
 ... key      at: [<c0223a30>] mac80211_config_ops+0xd0/0xffff2c5c [mac80211]
 -> (&cwq->lock){.+..} ops: 0 {
    initial-use  at:
                          [<800b2260>] __lock_acquire+0x63c/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b980>] _spin_lock_irqsave+0x50/0x74
                          [<8009d4b0>] __queue_work+0x20/0x54
                          [<8009d550>] queue_work_on+0x50/0x6c
                          [<8009c4c0>] call_usermodehelper_exec+0xf0/0x130
                          [<8017bb68>] kobject_uevent_env+0x350/0x3bc
                          [<8017aedc>] kset_register+0x44/0x5c
                          [<801ad7c4>] bus_register+0xb0/0x260
                          [<802f92f8>] platform_bus_init+0x34/0x60
                          [<802f942c>] driver_init+0x30/0x44
                          [<802e95d4>] kernel_init+0x78/0x104
                          [<8006de18>] kernel_thread_helper+0x10/0x18
    in-softirq-W at:
                          [<800b21cc>] __lock_acquire+0x5a8/0x844
                          [<800b24c4>] lock_acquire+0x5c/0x84
                          [<8006b980>] _spin_lock_irqsave+0x50/0x74
                          [<8009d4b0>] __queue_work+0x20/0x54
                          [<8009d550>] queue_work_on+0x50/0x6c
                          [<80094d50>] run_timer_softirq+0x120/0x19c
                          [<8008f74c>] __do_softirq+0x7c/0x130
                          [<8008f84c>] do_softirq+0x4c/0xa0
                          [<8006082c>] ret_from_irq+0x0/0x4
  }
  ... key      at: [<80670880>] __key.18562+0x0/0x8
  -> (&q->lock){.+..} ops: 0 {
     initial-use  at:
                            [<800b2260>] __lock_acquire+0x63c/0x844
                            [<800b24c4>] lock_acquire+0x5c/0x84
                            [<8006bdcc>] _spin_lock_irq+0x48/0x60
                            [<80068ac4>] wait_for_common+0x3c/0x188
                            [<800a0fb4>] kthread_create+0x80/0xc0
                            [<803048fc>] cpu_callback+0x68/0xd0
                            [<802f1088>] spawn_ksoftirqd+0x1c/0x4c
                            [<8006c04c>] __kprobes_text_end+0x64/0x1ac
                            [<802e95a0>] kernel_init+0x44/0x104
                            [<8006de18>] kernel_thread_helper+0x10/0x18
     in-softirq-W at:
                            [<800b21cc>] __lock_acquire+0x5a8/0x844
                            [<800b24c4>] lock_acquire+0x5c/0x84
                            [<8006b980>] _spin_lock_irqsave+0x50/0x74
                            [<80083394>] complete+0x24/0x6c
                            [<800bf298>] __rcu_process_callbacks+0x23c/0x33c
                            [<800bf3b4>] rcu_process_callbacks+0x1c/0x3c
                            [<8008f74c>] __do_softirq+0x7c/0x130
                            [<8008f84c>] do_softirq+0x4c/0xa0
                            [<8006082c>] ret_from_irq+0x0/0x4
                            [<80060b00>] r4k_wait+0x20/0x40
                            [<8006dd50>] cpu_idle+0x20/0x40
                            [<802e99f0>] start_kernel+0x390/0x3c4
   }
   ... key      at: [<80670c10>] __key.13688+0x0/0x10
   -> (&rq->lock){++..} ops: 0 {
      initial-use  at:
                              [<800b2260>] __lock_acquire+0x63c/0x844
                              [<800b24c4>] lock_acquire+0x5c/0x84
                              [<8006b980>] _spin_lock_irqsave+0x50/0x74
                              [<80304754>] init_idle+0x2c/0xc4
                              [<802f0b20>] sched_init+0x25c/0x298
                              [<802e979c>] start_kernel+0x13c/0x3c4
      in-hardirq-W at:
                              [<800b21a8>] __lock_acquire+0x584/0x844
                              [<800b24c4>] lock_acquire+0x5c/0x84
                              [<8006b8c4>] _spin_lock+0x34/0x48
                              [<80087920>] scheduler_tick+0x24/0xc8
                              [<800954a8>] update_process_times+0x58/0x70
                              [<800ac460>] tick_handle_periodic+0x20/0x134
                              [<80072404>] c0_compare_interrupt+0x54/0x64
                              [<800bbdbc>] handle_IRQ_event+0x38/0x94
                              [<800bd7dc>] handle_percpu_irq+0x54/0xac
                              [<8006cb94>] plat_irq_dispatch+0x398/0x3c8
                              [<8006082c>] ret_from_irq+0x0/0x4
                              [<8008b028>] vprintk+0x434/0x460
                              [<8008b078>] printk+0x24/0x30
                              [<802f2354>] lockdep_info+0x34/0xac
                              [<802e98ec>] start_kernel+0x28c/0x3c4
      in-softirq-W at:
                              [<800b21cc>] __lock_acquire+0x5a8/0x844
                              [<800b24c4>] lock_acquire+0x5c/0x84
                              [<8006b8c4>] _spin_lock+0x34/0x48
                              [<8008504c>] task_rq_lock+0x2c/0x40
                              [<80085314>] try_to_wake_up+0x40/0xe4
                              [<800822c8>] __wake_up_common+0x54/0xc0
                              [<800833bc>] complete+0x4c/0x6c
                              [<800bf298>] __rcu_process_callbacks+0x23c/0x33c
                              [<800bf3b4>] rcu_process_callbacks+0x1c/0x3c
                              [<8008f74c>] __do_softirq+0x7c/0x130
                              [<8008f84c>] do_softirq+0x4c/0xa0
                              [<8006082c>] ret_from_irq+0x0/0x4
                              [<80060b00>] r4k_wait+0x20/0x40
                              [<8006dd50>] cpu_idle+0x20/0x40
                              [<802e99f0>] start_kernel+0x390/0x3c4
    }
    ... key      at: [<8066a7a4>] __key.33804+0x0/0x8
    -> (&rt_b->rt_runtime_lock){++..} ops: 0 {
       initial-use  at:
                                [<800b2260>] __lock_acquire+0x63c/0x844
                                [<800b24c4>] lock_acquire+0x5c/0x84
                                [<8006b8c4>] _spin_lock+0x34/0x48
                                [<80085d08>] __enqueue_rt_entity+0x10c/0x1e4
                                [<80085e70>] enqueue_task_rt+0x44/0x70
                                [<80082048>] enqueue_task+0x1c/0x34
                                [<80082144>] activate_task+0x30/0x4c
                                [<800859d8>] __sched_setscheduler+0x2c4/0x3a8
                                [<800bbb20>] watchdog+0x38/0x218
                                [<800a104c>] kthread+0x58/0x98
                                [<8006de18>] kernel_thread_helper+0x10/0x18
       in-hardirq-W at:
                                [<800b21a8>] __lock_acquire+0x584/0x844
                                [<800b24c4>] lock_acquire+0x5c/0x84
                                [<8006b8c4>] _spin_lock+0x34/0x48
                                [<80085d08>] __enqueue_rt_entity+0x10c/0x1e4
                                [<80085e70>] enqueue_task_rt+0x44/0x70
                                [<80082048>] enqueue_task+0x1c/0x34
                                [<80082144>] activate_task+0x30/0x4c
                                [<80085354>] try_to_wake_up+0x80/0xe4
                                [<800bba24>] softlockup_tick+0xe4/0x1a8
                                [<8009547c>] update_process_times+0x2c/0x70
                                [<800ace44>] tick_sched_timer+0x308/0x35c
                                [<800a485c>] __run_hrtimer+0x5c/0xd0
                                [<800a5414>] hrtimer_interrupt+0x1ec/0x2c8
                                [<80072404>] c0_compare_interrupt+0x54/0x64
                                [<800bbdbc>] handle_IRQ_event+0x38/0x94
                                [<800bd7dc>] handle_percpu_irq+0x54/0xac
                                [<8006cb94>] plat_irq_dispatch+0x398/0x3c8
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<80060b00>] r4k_wait+0x20/0x40
                                [<8006dd50>] cpu_idle+0x20/0x40
       in-softirq-W at:
                                [<800b21cc>] __lock_acquire+0x5a8/0x844
                                [<800b24c4>] lock_acquire+0x5c/0x84
                                [<8006b8c4>] _spin_lock+0x34/0x48
                                [<80085d08>] __enqueue_rt_entity+0x10c/0x1e4
                                [<80085e70>] enqueue_task_rt+0x44/0x70
                                [<80082048>] enqueue_task+0x1c/0x34
                                [<80082144>] activate_task+0x30/0x4c
                                [<80085354>] try_to_wake_up+0x80/0xe4
                                [<800bba24>] softlockup_tick+0xe4/0x1a8
                                [<8009547c>] update_process_times+0x2c/0x70
                                [<800ace44>] tick_sched_timer+0x308/0x35c
                                [<800a485c>] __run_hrtimer+0x5c/0xd0
                                [<800a5414>] hrtimer_interrupt+0x1ec/0x2c8
                                [<80072404>] c0_compare_interrupt+0x54/0x64
                                [<800bbdbc>] handle_IRQ_event+0x38/0x94
                                [<800bd7dc>] handle_percpu_irq+0x54/0xac
                                [<8006cb94>] plat_irq_dispatch+0x398/0x3c8
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<8006bb18>] _read_lock_bh+0x0/0x58
                                [<c03c5a94>] ipt_do_table+0xc4/0x3a8 [ip_tables]
                                [<801f7c88>] nf_iterate+0x70/0xf8
                                [<801f7ee8>] nf_hook_slow+0xb8/0x17c
                                [<801ffe64>] ip_local_deliver+0x74/0xac
                                [<801ff770>] ip_rcv_finish+0x3c4/0x430
                                [<801d8e68>] netif_receive_skb+0x4b8/0x544
                                [<801dbde8>] process_backlog+0xa8/0x158
                                [<801db69c>] net_rx_action+0x90/0x1e8
                                [<8008f74c>] __do_softirq+0x7c/0x130
                                [<8008f84c>] do_softirq+0x4c/0xa0
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<80060b00>] r4k_wait+0x20/0x40
                                [<8006dd50>] cpu_idle+0x20/0x40
     }
     ... key      at: [<8066a7ac>] __key.30229+0x0/0x8
     -> (&cpu_base->lock){++..} ops: 0 {
        initial-use  at:
                                  [<800b2260>] __lock_acquire+0x63c/0x844
                                  [<800b24c4>] lock_acquire+0x5c/0x84
                                  [<8006bdcc>] _spin_lock_irq+0x48/0x60
                                  [<800a45ac>] run_hrtimer_pending+0x20/0x160
                                  [<80094c50>] run_timer_softirq+0x20/0x19c
                                  [<8008f74c>] __do_softirq+0x7c/0x130
                                  [<8008f84c>] do_softirq+0x4c/0xa0
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<8008b028>] vprintk+0x434/0x460
                                  [<8008b078>] printk+0x24/0x30
                                  [<802f2354>] lockdep_info+0x34/0xac
                                  [<802e98ec>] start_kernel+0x28c/0x3c4
        in-hardirq-W at:
                                  [<800b21a8>] __lock_acquire+0x584/0x844
                                  [<800b24c4>] lock_acquire+0x5c/0x84
                                  [<8006b8c4>] _spin_lock+0x34/0x48
                                  [<800a49e4>] hrtimer_run_queues+0x114/0x1f4
                                  [<80095178>] run_local_timers+0x10/0x24
                                  [<8009547c>] update_process_times+0x2c/0x70
                                  [<800ac460>] tick_handle_periodic+0x20/0x134
                                  [<80072404>] c0_compare_interrupt+0x54/0x64
                                  [<800bbdbc>] handle_IRQ_event+0x38/0x94
                                  [<800bd7dc>] handle_percpu_irq+0x54/0xac
                                  [<8006cb94>] plat_irq_dispatch+0x398/0x3c8
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<8006bf44>] _spin_unlock_irqrestore+0x74/0x8c
                                  [<800a1024>] kthread+0x30/0x98
                                  [<8006de18>] kernel_thread_helper+0x10/0x18
        in-softirq-W at:
                                  [<800b21cc>] __lock_acquire+0x5a8/0x844
                                  [<800b24c4>] lock_acquire+0x5c/0x84
                                  [<8006bdcc>] _spin_lock_irq+0x48/0x60
                                  [<800a45ac>] run_hrtimer_pending+0x20/0x160
                                  [<80094c50>] run_timer_softirq+0x20/0x19c
                                  [<8008f74c>] __do_softirq+0x7c/0x130
                                  [<8008f84c>] do_softirq+0x4c/0xa0
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<8008b028>] vprintk+0x434/0x460
                                  [<8008b078>] printk+0x24/0x30
                                  [<802f2354>] lockdep_info+0x34/0xac
                                  [<802e98ec>] start_kernel+0x28c/0x3c4
      }
      ... key      at: [<80670c50>] __key.16042+0x0/0x8
     ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b980>] _spin_lock_irqsave+0x50/0x74
   [<800a4d44>] hrtimer_start_range_ns+0x3c/0x180
   [<80085dac>] __enqueue_rt_entity+0x1b0/0x1e4
   [<80085e70>] enqueue_task_rt+0x44/0x70
   [<80082048>] enqueue_task+0x1c/0x34
   [<80082144>] activate_task+0x30/0x4c
   [<800859d8>] __sched_setscheduler+0x2c4/0x3a8
   [<800bbb20>] watchdog+0x38/0x218
   [<800a104c>] kthread+0x58/0x98
   [<8006de18>] kernel_thread_helper+0x10/0x18

    ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b8c4>] _spin_lock+0x34/0x48
   [<80085d08>] __enqueue_rt_entity+0x10c/0x1e4
   [<80085e70>] enqueue_task_rt+0x44/0x70
   [<80082048>] enqueue_task+0x1c/0x34
   [<80082144>] activate_task+0x30/0x4c
   [<800859d8>] __sched_setscheduler+0x2c4/0x3a8
   [<800bbb20>] watchdog+0x38/0x218
   [<800a104c>] kthread+0x58/0x98
   [<8006de18>] kernel_thread_helper+0x10/0x18

    -> (&rt_rq->rt_runtime_lock){....} ops: 0 {
       initial-use  at:
                                [<800b2260>] __lock_acquire+0x63c/0x844
                                [<800b24c4>] lock_acquire+0x5c/0x84
                                [<8006b8c4>] _spin_lock+0x34/0x48
                                [<800830b0>] update_curr_rt+0xe4/0x1f0
                                [<80085dfc>] dequeue_task_rt+0x1c/0x4c
                                [<80082100>] dequeue_task+0xa0/0xb4
                                [<80082190>] deactivate_task+0x30/0x4c
                                [<80068da8>] schedule+0x110/0x354
                                [<800bbb48>] watchdog+0x60/0x218
                                [<800a104c>] kthread+0x58/0x98
                                [<8006de18>] kernel_thread_helper+0x10/0x18
     }
     ... key      at: [<8066a7b4>] __key.33788+0x0/0xc
    ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b8c4>] _spin_lock+0x34/0x48
   [<800830b0>] update_curr_rt+0xe4/0x1f0
   [<80085dfc>] dequeue_task_rt+0x1c/0x4c
   [<80082100>] dequeue_task+0xa0/0xb4
   [<80082190>] deactivate_task+0x30/0x4c
   [<80068da8>] schedule+0x110/0x354
   [<800bbb48>] watchdog+0x60/0x218
   [<800a104c>] kthread+0x58/0x98
   [<8006de18>] kernel_thread_helper+0x10/0x18

   ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b8c4>] _spin_lock+0x34/0x48
   [<8008504c>] task_rq_lock+0x2c/0x40
   [<80085314>] try_to_wake_up+0x40/0xe4
   [<800822c8>] __wake_up_common+0x54/0xc0
   [<800833bc>] complete+0x4c/0x6c
   [<800a1024>] kthread+0x30/0x98
   [<8006de18>] kernel_thread_helper+0x10/0x18

  ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b980>] _spin_lock_irqsave+0x50/0x74
   [<80083498>] __wake_up+0x30/0x74
   [<8009d4c4>] __queue_work+0x34/0x54
   [<8009d550>] queue_work_on+0x50/0x6c
   [<8009c4c0>] call_usermodehelper_exec+0xf0/0x130
   [<8017bb68>] kobject_uevent_env+0x350/0x3bc
   [<8017aedc>] kset_register+0x44/0x5c
   [<801ad7c4>] bus_register+0xb0/0x260
   [<802f92f8>] platform_bus_init+0x34/0x60
   [<802f942c>] driver_init+0x30/0x44
   [<802e95d4>] kernel_init+0x78/0x104
   [<8006de18>] kernel_thread_helper+0x10/0x18

 ... acquired at:
   [<800b18c4>] validate_chain+0xb20/0xe80
   [<800b23c4>] __lock_acquire+0x7a0/0x844
   [<800b24c4>] lock_acquire+0x5c/0x84
   [<8006b980>] _spin_lock_irqsave+0x50/0x74
   [<8009d4b0>] __queue_work+0x20/0x54
   [<8009d550>] queue_work_on+0x50/0x6c
   [<c02065bc>] ieee80211_tx_pending+0x3ec/0x470 [mac80211]


stack backtrace:
Call Trace:
[<800715f4>] dump_stack+0x8/0x34
[<800b0c80>] check_usage+0x414/0x444
[<800b1598>] validate_chain+0x7f4/0xe80
[<800b23c4>] __lock_acquire+0x7a0/0x844
[<800b24c4>] lock_acquire+0x5c/0x84
[<8006b980>] _spin_lock_irqsave+0x50/0x74
[<c0206e4c>] ieee80211_key_free+0x78/0xe0 [mac80211]
[<c01eba7c>] ieee80211_alloc_hw+0x22b8/0x2464 [mac80211]

Anyone got anything similar already?

Regards,
Gabor
