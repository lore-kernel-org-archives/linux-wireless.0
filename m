Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:36697 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZFUTt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 15:49:58 -0400
Message-ID: <4A3E8EE0.6040609@openwrt.org>
Date: Sun, 21 Jun 2009 21:49:52 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k: serialize ath9k_ps_{wakeup,restore} calls
References: <1245599268-2441-1-git-send-email-juhosg@openwrt.org> <1245599268-2441-3-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245599268-2441-3-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos írta:
> These functions are changing the power mode of the chip, but this may
> have unpredictable effects, if another code are trying to set the power
> mode via 'ath9k_hw_setpower' in the same time from another context.
> 
> Changes-licensed-under: ISC
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
>  drivers/net/wireless/ath/ath9k/hw.c    |   42 ++++++++++++++++++++++----------
>  2 files changed, 30 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 9865452..23b5586 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -561,7 +561,7 @@ struct ath_softc {
>  	u32 keymax;
>  	DECLARE_BITMAP(keymap, ATH_KEYMAX);
>  	u8 splitmic;
> -	atomic_t ps_usecount;
> +	unsigned long ps_usecount;
>  	enum ath9k_int imask;
>  	enum ath9k_ht_extprotspacing ht_extprotspacing;
>  	enum ath9k_ht_macmode tx_chan_width;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index acf5256..b321209 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2777,23 +2777,39 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
>  
>  void ath9k_ps_wakeup(struct ath_softc *sc)
>  {
> -	if (atomic_inc_return(&sc->ps_usecount) == 1)
> -		if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
> -			sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
> -			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
> -		}
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sc->sc_pm_lock, flags);
> +	if (++sc->ps_usecount != 1)
> +		goto unlock;
> +
> +	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
> +		sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
> +		ath9k_hw_setpower_nolock(sc->sc_ah, ATH9K_PM_AWAKE);
> +	}
> +
> + unlock:
> +	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>  }
>  
>  void ath9k_ps_restore(struct ath_softc *sc)
>  {
> -	if (atomic_dec_and_test(&sc->ps_usecount))
> -		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
> -		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
> -				      SC_OP_WAIT_FOR_CAB |
> -				      SC_OP_WAIT_FOR_PSPOLL_DATA |
> -				      SC_OP_WAIT_FOR_TX_ACK)))
> -			ath9k_hw_setpower(sc->sc_ah,
> -					  sc->sc_ah->restore_mode);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&sc->sc_pm_lock, flags);
> +	if (--sc->ps_usecount != 0)
> +		goto unlock;
> +
> +	if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
> +		!(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
> +				SC_OP_WAIT_FOR_CAB |
> +				SC_OP_WAIT_FOR_PSPOLL_DATA |
> +				SC_OP_WAIT_FOR_TX_ACK)))
> +		ath9k_hw_setpower_nolock(sc->sc_ah,
> +				      sc->sc_ah->restore_mode);
> +
> + unlock:
> +	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>  }
>  
>  /*

John, 

Please wait with these 3 patches, I got this while the interface is in Master mode:

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.30 #37
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&local->sta_lock){..-...}, at: [<c0252f3c>] ieee80211_beacon_get+0x148/0x518 [mac80211]
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (todo_lock){+.+...}

and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (rcu_read_lock){.+.+..}, at: [<c0252df4>] ieee80211_beacon_get+0x0/0x518 [mac80211]

the first lock's dependencies:
-> (&local->sta_lock){..-...} ops: 0 {
   IN-SOFTIRQ-W at:
                        [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                        [<800b4dc0>] lock_acquire+0x5c/0x84
                        [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                        [<c0252f3c>] ieee80211_beacon_get+0x148/0x518 [mac80211]
                        [<c0c87168>] ath_beacon_tasklet+0x248/0x528 [ath9k]
                        [<8008f710>] tasklet_action+0x84/0xf0
                        [<8008f0fc>] __do_softirq+0x7c/0x128
                        [<8008f1f4>] do_softirq+0x4c/0xa0
                        [<8006082c>] ret_from_irq+0x0/0x4
                        [<80060b00>] r4k_wait+0x20/0x40
                        [<8006ce1c>] cpu_idle+0x20/0x40
                        [<8031e9f0>] start_kernel+0x36c/0x388
   INITIAL USE at:
                       [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                       [<800b4dc0>] lock_acquire+0x5c/0x84
                       [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                       [<c023a784>] sta_info_insert+0xb0/0x1ec [mac80211]
                       [<c0243fd4>] ieee80211_beacon_loss_work+0x7a0/0xcc8 [mac80211]
 }
 ... key      at: [<c0271250>] __this_module+0x1a0/0xffff27fc [mac80211]
 -> (&local->key_lock){......} ops: 0 {
    INITIAL USE at:
                         [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                         [<800b4dc0>] lock_acquire+0x5c/0x84
                         [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                         [<c0253ce8>] ieee80211_key_todo+0x88/0x114 [mac80211]
  }
  ... key      at: [<c0271220>] __this_module+0x170/0xffff27fc [mac80211]
  -> (todo_lock){+.+...} ops: 0 {
     HARDIRQ-ON-W at:
                            [<800b3cfc>] __lock_acquire+0x630/0x8b0
                            [<800b4dc0>] lock_acquire+0x5c/0x84
                            [<8006a974>] _spin_lock+0x34/0x48
                            [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
     SOFTIRQ-ON-W at:
                            [<800b3d20>] __lock_acquire+0x654/0x8b0
                            [<800b4dc0>] lock_acquire+0x5c/0x84
                            [<8006a974>] _spin_lock+0x34/0x48
                            [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
     INITIAL USE at:
                           [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                           [<800b4dc0>] lock_acquire+0x5c/0x84
                           [<8006a974>] _spin_lock+0x34/0x48
                           [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
   }
   ... key      at: [<c0270f00>] mac80211_config_ops+0xf0/0xffff2a9c [mac80211]
   -> (&cwq->lock){..-...} ops: 0 {
      IN-SOFTIRQ-W at:
                              [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                              [<800b4dc0>] lock_acquire+0x5c/0x84
                              [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                              [<8009d210>] __queue_work+0x20/0x54
                              [<800949e0>] run_timer_softirq+0x174/0x204
                              [<8008f0fc>] __do_softirq+0x7c/0x128
                              [<8008f1f4>] do_softirq+0x4c/0xa0
                              [<8006082c>] ret_from_irq+0x0/0x4
      INITIAL USE at:
                             [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                             [<800b4dc0>] lock_acquire+0x5c/0x84
                             [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                             [<8009d210>] __queue_work+0x20/0x54
                             [<8009d2b0>] queue_work_on+0x50/0x6c
                             [<8009c38c>] call_usermodehelper_exec+0x104/0x144
                             [<801861fc>] kobject_uevent_env+0x370/0x3dc
                             [<80185538>] kset_register+0x44/0x5c
                             [<801ba354>] bus_register+0xb0/0x260
                             [<8032e288>] platform_bus_init+0x38/0x64
                             [<8032e504>] driver_init+0x30/0x44
                             [<8031e5f8>] kernel_init+0x80/0x10c
                             [<8006cee4>] kernel_thread_helper+0x10/0x18
    }
    ... key      at: [<80a1a320>] __key.20477+0x0/0x8
    -> (&q->lock){..-.-.} ops: 0 {
       IN-SOFTIRQ-W at:
                                [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                [<800b4dc0>] lock_acquire+0x5c/0x84
                                [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                [<800829e0>] __wake_up+0x30/0x74
                                [<8008f710>] tasklet_action+0x84/0xf0
                                [<8008f0fc>] __do_softirq+0x7c/0x128
                                [<8008f1f4>] do_softirq+0x4c/0xa0
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<8006aff4>] _spin_unlock_irqrestore+0x74/0x8c
                                [<801b16cc>] uart_write+0xf0/0x120
                                [<801aa19c>] n_tty_write+0x290/0x3fc
                                [<801a76a4>] tty_write+0x1b0/0x26c
                                [<800ecd2c>] sys_write+0x54/0x98
                                [<80062778>] stack_done+0x20/0x3c
       IN-RECLAIM_FS-W at:
                                   [<800b3d64>] __lock_acquire+0x698/0x8b0
                                   [<800b4dc0>] lock_acquire+0x5c/0x84
                                   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                   [<800a1584>] prepare_to_wait+0x34/0x80
                                   [<800d03d4>] kswapd+0xc0/0x4bc
                                   [<800a11c0>] kthread+0x60/0xa4
                                   [<8006cee4>] kernel_thread_helper+0x10/0x18
       INITIAL USE at:
                               [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                               [<800b4dc0>] lock_acquire+0x5c/0x84
                               [<8006ae7c>] _spin_lock_irq+0x48/0x60
                               [<80067944>] wait_for_common+0x3c/0x188
                               [<800a10f8>] kthread_create+0x80/0xe8
                               [<80339b7c>] cpu_callback+0x68/0xd0
                               [<80324cbc>] spawn_ksoftirqd+0x1c/0x4c
                               [<8006b0fc>] do_one_initcall+0x64/0x1c8
                               [<8031e5c4>] kernel_init+0x4c/0x10c
                               [<8006cee4>] kernel_thread_helper+0x10/0x18
     }
     ... key      at: [<80a1a6a0>] __key.15349+0x0/0x10
     -> (&rq->lock){-.-.-.} ops: 0 {
        IN-HARDIRQ-W at:
                                  [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                                  [<800b4dc0>] lock_acquire+0x5c/0x84
                                  [<8006a974>] _spin_lock+0x34/0x48
                                  [<80086f6c>] scheduler_tick+0x24/0xc4
                                  [<8009523c>] update_process_times+0x58/0x70
                                  [<800ae16c>] tick_handle_periodic+0x20/0x140
                                  [<80071530>] c0_compare_interrupt+0x54/0x64
                                  [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                  [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                  [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<8008a940>] vprintk+0x434/0x460
                                  [<8008a990>] printk+0x24/0x30
                                  [<80326004>] lockdep_info+0x34/0xac
                                  [<8031e8e4>] start_kernel+0x260/0x388
        IN-SOFTIRQ-W at:
                                  [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                  [<800b4dc0>] lock_acquire+0x5c/0x84
                                  [<8006a974>] _spin_lock+0x34/0x48
                                  [<80084670>] task_rq_lock+0x2c/0x40
                                  [<8008492c>] try_to_wake_up+0x40/0x15c
                                  [<8008f178>] __do_softirq+0xf8/0x128
                                  [<8008f1f4>] do_softirq+0x4c/0xa0
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<800a8a0c>] sysctl_check_lookup+0xb8/0x164
                                  [<800a8cf0>] sysctl_check_table+0x1c4/0x6f0
                                  [<800a9190>] sysctl_check_table+0x664/0x6f0
                                  [<8009273c>] __register_sysctl_paths+0x114/0x2f8
                                  [<80331c00>] inet_init+0x6c/0x26c
                                  [<8006b0fc>] do_one_initcall+0x64/0x1c8
                                  [<8031e614>] kernel_init+0x9c/0x10c
                                  [<8006cee4>] kernel_thread_helper+0x10/0x18
        IN-RECLAIM_FS-W at:
                                     [<800b3d64>] __lock_acquire+0x698/0x8b0
                                     [<800b4dc0>] lock_acquire+0x5c/0x84
                                     [<8006ae7c>] _spin_lock_irq+0x48/0x60
                                     [<80067b80>] __schedule+0x68/0x3c0
                                     [<80067ee8>] schedule+0x10/0x28
                                     [<800d03f4>] kswapd+0xe0/0x4bc
                                     [<800a11c0>] kthread+0x60/0xa4
                                     [<8006cee4>] kernel_thread_helper+0x10/0x18
        INITIAL USE at:
                                 [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                                 [<800b4dc0>] lock_acquire+0x5c/0x84
                                 [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                 [<803399d4>] init_idle+0x2c/0xc4
                                 [<80324708>] sched_init+0x254/0x290
                                 [<8031e78c>] start_kernel+0x108/0x388
      }
      ... key      at: [<80a146cc>] __key.35967+0x0/0x8
      -> (&rt_b->rt_runtime_lock){-.-...} ops: 0 {
         IN-HARDIRQ-W at:
                                    [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                                    [<800b4dc0>] lock_acquire+0x5c/0x84
                                    [<8006a974>] _spin_lock+0x34/0x48
                                    [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                                    [<80086690>] enqueue_task_rt+0x44/0x70
                                    [<80081034>] enqueue_task+0x34/0x4c
                                    [<8008114c>] activate_task+0x48/0x64
                                    [<8008496c>] try_to_wake_up+0x80/0x15c
                                    [<800bda80>] softlockup_tick+0xe4/0x1a8
                                    [<80095210>] update_process_times+0x2c/0x70
                                    [<800aebc0>] tick_sched_timer+0x308/0x35c
                                    [<800a4724>] __run_hrtimer+0x6c/0xc8
                                    [<800a5654>] hrtimer_interrupt+0x224/0x2d0
                                    [<80071530>] c0_compare_interrupt+0x54/0x64
                                    [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                    [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                    [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                    [<8006082c>] ret_from_irq+0x0/0x4
                                    [<80060b00>] r4k_wait+0x20/0x40
                                    [<8006ce1c>] cpu_idle+0x20/0x40
                                    [<8031e9f0>] start_kernel+0x36c/0x388
         IN-SOFTIRQ-W at:
                                    [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                    [<800b4dc0>] lock_acquire+0x5c/0x84
                                    [<8006a974>] _spin_lock+0x34/0x48
                                    [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                                    [<80086690>] enqueue_task_rt+0x44/0x70
                                    [<80081034>] enqueue_task+0x34/0x4c
                                    [<8008114c>] activate_task+0x48/0x64
                                    [<8008496c>] try_to_wake_up+0x80/0x15c
                                    [<800bda80>] softlockup_tick+0xe4/0x1a8
                                    [<80095210>] update_process_times+0x2c/0x70
                                    [<800aebc0>] tick_sched_timer+0x308/0x35c
                                    [<800a4724>] __run_hrtimer+0x6c/0xc8
                                    [<800a5654>] hrtimer_interrupt+0x224/0x2d0
                                    [<80071530>] c0_compare_interrupt+0x54/0x64
                                    [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                    [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                    [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                    [<8006082c>] ret_from_irq+0x0/0x4
                                    [<c0c8a6f8>] ath_reset+0x4c4/0x5f8 [ath9k]
         INITIAL USE at:
                                   [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                                   [<800b4dc0>] lock_acquire+0x5c/0x84
                                   [<8006a974>] _spin_lock+0x34/0x48
                                   [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                                   [<80086690>] enqueue_task_rt+0x44/0x70
                                   [<80081034>] enqueue_task+0x34/0x4c
                                   [<8008114c>] activate_task+0x48/0x64
                                   [<80084f10>] __sched_setscheduler+0x2b4/0x390
                                   [<800bdb64>] watchdog+0x20/0x88
                                   [<800a11c0>] kthread+0x60/0xa4
                                   [<8006cee4>] kernel_thread_helper+0x10/0x18
       }
       ... key      at: [<80a146d4>] __key.32178+0x0/0x8
       -> (&cpu_base->lock){-.-...} ops: 0 {
          IN-HARDIRQ-W at:
                                      [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                                      [<800b4dc0>] lock_acquire+0x5c/0x84
                                      [<8006a974>] _spin_lock+0x34/0x48
                                      [<800a4894>] hrtimer_run_queues+0x114/0x1b0
                                      [<800950f8>] run_local_timers+0x10/0x24
                                      [<80095210>] update_process_times+0x2c/0x70
                                      [<800ae16c>] tick_handle_periodic+0x20/0x140
                                      [<80071530>] c0_compare_interrupt+0x54/0x64
                                      [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                      [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                      [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                      [<8006082c>] ret_from_irq+0x0/0x4
                                      [<8008a940>] vprintk+0x434/0x460
                                      [<8008a990>] printk+0x24/0x30
                                      [<801ddfd0>] sock_register+0x94/0xac
                                      [<8033071c>] netlink_proto_init+0x134/0x180
                                      [<8006b0fc>] do_one_initcall+0x64/0x1c8
                                      [<8031e614>] kernel_init+0x9c/0x10c
                                      [<8006cee4>] kernel_thread_helper+0x10/0x18
          IN-SOFTIRQ-W at:
                                      [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                      [<800b4dc0>] lock_acquire+0x5c/0x84
                                      [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                      [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
                                      [<800a5158>] hrtimer_start_range_ns+0x24/0x30
                                      [<800ae874>] tick_setup_sched_timer+0x224/0x268
                                      [<800a5c24>] hrtimer_run_pending+0xdc/0x15c
                                      [<80094894>] run_timer_softirq+0x28/0x204
                                      [<8008f0fc>] __do_softirq+0x7c/0x128
                                      [<8008f1f4>] do_softirq+0x4c/0xa0
                                      [<8006082c>] ret_from_irq+0x0/0x4
                                      [<800a8a0c>] sysctl_check_lookup+0xb8/0x164
                                      [<800a8cf0>] sysctl_check_table+0x1c4/0x6f0
                                      [<800a9190>] sysctl_check_table+0x664/0x6f0
                                      [<8009273c>] __register_sysctl_paths+0x114/0x2f8
                                      [<80331c00>] inet_init+0x6c/0x26c
                                      [<8006b0fc>] do_one_initcall+0x64/0x1c8
                                      [<8031e614>] kernel_init+0x9c/0x10c
                                      [<8006cee4>] kernel_thread_helper+0x10/0x18
          INITIAL USE at:
                                     [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                                     [<800b4dc0>] lock_acquire+0x5c/0x84
                                     [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                     [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
                                     [<800853f8>] __enqueue_rt_entity+0x1ac/0x1e4
                                     [<80086690>] enqueue_task_rt+0x44/0x70
                                     [<80081034>] enqueue_task+0x34/0x4c
                                     [<8008114c>] activate_task+0x48/0x64
                                     [<80084f10>] __sched_setscheduler+0x2b4/0x390
                                     [<800bdb64>] watchdog+0x20/0x88
                                     [<800a11c0>] kthread+0x60/0xa4
                                     [<8006cee4>] kernel_thread_helper+0x10/0x18
        }
        ... key      at: [<80a1a6e0>] __key.16951+0x0/0x8
       ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
   [<800853f8>] __enqueue_rt_entity+0x1ac/0x1e4
   [<80086690>] enqueue_task_rt+0x44/0x70
   [<80081034>] enqueue_task+0x34/0x4c
   [<8008114c>] activate_task+0x48/0x64
   [<80084f10>] __sched_setscheduler+0x2b4/0x390
   [<800bdb64>] watchdog+0x20/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

      ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80085350>] __enqueue_rt_entity+0x104/0x1e4
   [<80086690>] enqueue_task_rt+0x44/0x70
   [<80081034>] enqueue_task+0x34/0x4c
   [<8008114c>] activate_task+0x48/0x64
   [<80084f10>] __sched_setscheduler+0x2b4/0x390
   [<800bdb64>] watchdog+0x20/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

      -> (&rt_rq->rt_runtime_lock){......} ops: 0 {
         INITIAL USE at:
                                   [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                                   [<800b4dc0>] lock_acquire+0x5c/0x84
                                   [<8006a974>] _spin_lock+0x34/0x48
                                   [<80082488>] update_curr_rt+0x124/0x234
                                   [<800866d8>] dequeue_task_rt+0x1c/0x4c
                                   [<800810e8>] dequeue_task+0x9c/0xb8
                                   [<800811b0>] deactivate_task+0x48/0x64
                                   [<80067c24>] __schedule+0x10c/0x3c0
                                   [<80067ee8>] schedule+0x10/0x28
                                   [<800bdb8c>] watchdog+0x48/0x88
                                   [<800a11c0>] kthread+0x60/0xa4
                                   [<8006cee4>] kernel_thread_helper+0x10/0x18
       }
       ... key      at: [<80a146dc>] __key.35951+0x0/0xc
      ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80082488>] update_curr_rt+0x124/0x234
   [<800866d8>] dequeue_task_rt+0x1c/0x4c
   [<800810e8>] dequeue_task+0x9c/0xb8
   [<800811b0>] deactivate_task+0x48/0x64
   [<80067c24>] __schedule+0x10c/0x3c0
   [<80067ee8>] schedule+0x10/0x28
   [<800bdb8c>] watchdog+0x48/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

     ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80084670>] task_rq_lock+0x2c/0x40
   [<8008492c>] try_to_wake_up+0x40/0x15c
   [<80081380>] __wake_up_common+0x54/0xc0
   [<800828ec>] complete+0x4c/0x6c
   [<800a119c>] kthread+0x3c/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

    ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<800829e0>] __wake_up+0x30/0x74
   [<8009d224>] __queue_work+0x34/0x54
   [<8009d2b0>] queue_work_on+0x50/0x6c
   [<8009c38c>] call_usermodehelper_exec+0x104/0x144
   [<801861fc>] kobject_uevent_env+0x370/0x3dc
   [<80185538>] kset_register+0x44/0x5c
   [<801ba354>] bus_register+0xb0/0x260
   [<8032e288>] platform_bus_init+0x38/0x64
   [<8032e504>] driver_init+0x30/0x44
   [<8031e5f8>] kernel_init+0x80/0x10c
   [<8006cee4>] kernel_thread_helper+0x10/0x18

   ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<8009d210>] __queue_work+0x20/0x54
   [<8009d2b0>] queue_work_on+0x50/0x6c
   [<c0253288>] ieee80211_beacon_get+0x494/0x518 [mac80211]

  ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<c0253218>] ieee80211_beacon_get+0x424/0x518 [mac80211]

 ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<c0253b18>] ieee80211_key_free+0x78/0xe0 [mac80211]
   [<c0239824>] ieee80211_alloc_hw+0x1240/0x13ec [mac80211]

 -> (&sta->flaglock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                          [<800b4dc0>] lock_acquire+0x5c/0x84
                          [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                          [<c024bd14>] ieee80211_rx_irqsafe+0x298/0x3568 [mac80211]
    INITIAL USE at:
                         [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                         [<800b4dc0>] lock_acquire+0x5c/0x84
                         [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                         [<c0243d04>] ieee80211_beacon_loss_work+0x4d0/0xcc8 [mac80211]
  }
  ... key      at: [<c0271260>] __this_module+0x1b0/0xffff27fc [mac80211]
 ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<c023988c>] ieee80211_alloc_hw+0x12a8/0x13ec [mac80211]

 -> (&txq->axq_lock){+.-...} ops: 0 {
    HARDIRQ-ON-W at:
                          [<800b3cfc>] __lock_acquire+0x630/0x8b0
                          [<800b4dc0>] lock_acquire+0x5c/0x84
                          [<8006a9c8>] _spin_lock_bh+0x40/0x58
                          [<c0c8f2e4>] ath_draintxq+0x54/0x2f4 [ath9k]
                          [<c0c90c4c>] ath_drain_all_txq+0x164/0x194 [ath9k]
                          [<c0c89c38>] ath_set_channel+0x84/0x5a0 [ath9k]
                          [<c0c8c278>] ath_descdma_setup+0x550/0x5d4 [ath9k]
    IN-SOFTIRQ-W at:
                          [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                          [<800b4dc0>] lock_acquire+0x5c/0x84
                          [<8006a9c8>] _spin_lock_bh+0x40/0x58
                          [<c0c90570>] ath_tx_tasklet+0xf0/0x4c0 [ath9k]
                          [<c0c8a7a0>] ath_reset+0x56c/0x5f8 [ath9k]
                          [<8006a820>] _spin_unlock+0x20/0x34
    INITIAL USE at:
                         [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                         [<800b4dc0>] lock_acquire+0x5c/0x84
                         [<8006a9c8>] _spin_lock_bh+0x40/0x58
                         [<c0c8f2e4>] ath_draintxq+0x54/0x2f4 [ath9k]
                         [<c0c90c4c>] ath_drain_all_txq+0x164/0x194 [ath9k]
                         [<c0c89c38>] ath_set_channel+0x84/0x5a0 [ath9k]
                         [<c0c8c278>] ath_descdma_setup+0x550/0x5d4 [ath9k]
  }
  ... key      at: [<c0cb41b8>] btcoex_enable+0x614/0xfffe2ff0 [ath9k]
 ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<c0c914ac>] ath_tx_node_cleanup+0x64/0x190 [ath9k]
   [<c0239938>] ieee80211_alloc_hw+0x1354/0x13ec [mac80211]


the second lock's dependencies:
-> (todo_lock){+.+...} ops: 0 {
   HARDIRQ-ON-W at:
                        [<800b3cfc>] __lock_acquire+0x630/0x8b0
                        [<800b4dc0>] lock_acquire+0x5c/0x84
                        [<8006a974>] _spin_lock+0x34/0x48
                        [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
   SOFTIRQ-ON-W at:
                        [<800b3d20>] __lock_acquire+0x654/0x8b0
                        [<800b4dc0>] lock_acquire+0x5c/0x84
                        [<8006a974>] _spin_lock+0x34/0x48
                        [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
   INITIAL USE at:
                       [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                       [<800b4dc0>] lock_acquire+0x5c/0x84
                       [<8006a974>] _spin_lock+0x34/0x48
                       [<c0253a68>] ieee80211_set_default_key+0x4b8/0x4f0 [mac80211]
 }
 ... key      at: [<c0270f00>] mac80211_config_ops+0xf0/0xffff2a9c [mac80211]
 -> (&cwq->lock){..-...} ops: 0 {
    IN-SOFTIRQ-W at:
                          [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                          [<800b4dc0>] lock_acquire+0x5c/0x84
                          [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                          [<8009d210>] __queue_work+0x20/0x54
                          [<800949e0>] run_timer_softirq+0x174/0x204
                          [<8008f0fc>] __do_softirq+0x7c/0x128
                          [<8008f1f4>] do_softirq+0x4c/0xa0
                          [<8006082c>] ret_from_irq+0x0/0x4
    INITIAL USE at:
                         [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                         [<800b4dc0>] lock_acquire+0x5c/0x84
                         [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                         [<8009d210>] __queue_work+0x20/0x54
                         [<8009d2b0>] queue_work_on+0x50/0x6c
                         [<8009c38c>] call_usermodehelper_exec+0x104/0x144
                         [<801861fc>] kobject_uevent_env+0x370/0x3dc
                         [<80185538>] kset_register+0x44/0x5c
                         [<801ba354>] bus_register+0xb0/0x260
                         [<8032e288>] platform_bus_init+0x38/0x64
                         [<8032e504>] driver_init+0x30/0x44
                         [<8031e5f8>] kernel_init+0x80/0x10c
                         [<8006cee4>] kernel_thread_helper+0x10/0x18
  }
  ... key      at: [<80a1a320>] __key.20477+0x0/0x8
  -> (&q->lock){..-.-.} ops: 0 {
     IN-SOFTIRQ-W at:
                            [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                            [<800b4dc0>] lock_acquire+0x5c/0x84
                            [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                            [<800829e0>] __wake_up+0x30/0x74
                            [<8008f710>] tasklet_action+0x84/0xf0
                            [<8008f0fc>] __do_softirq+0x7c/0x128
                            [<8008f1f4>] do_softirq+0x4c/0xa0
                            [<8006082c>] ret_from_irq+0x0/0x4
                            [<8006aff4>] _spin_unlock_irqrestore+0x74/0x8c
                            [<801b16cc>] uart_write+0xf0/0x120
                            [<801aa19c>] n_tty_write+0x290/0x3fc
                            [<801a76a4>] tty_write+0x1b0/0x26c
                            [<800ecd2c>] sys_write+0x54/0x98
                            [<80062778>] stack_done+0x20/0x3c
     IN-RECLAIM_FS-W at:
                               [<800b3d64>] __lock_acquire+0x698/0x8b0
                               [<800b4dc0>] lock_acquire+0x5c/0x84
                               [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                               [<800a1584>] prepare_to_wait+0x34/0x80
                               [<800d03d4>] kswapd+0xc0/0x4bc
                               [<800a11c0>] kthread+0x60/0xa4
                               [<8006cee4>] kernel_thread_helper+0x10/0x18
     INITIAL USE at:
                           [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                           [<800b4dc0>] lock_acquire+0x5c/0x84
                           [<8006ae7c>] _spin_lock_irq+0x48/0x60
                           [<80067944>] wait_for_common+0x3c/0x188
                           [<800a10f8>] kthread_create+0x80/0xe8
                           [<80339b7c>] cpu_callback+0x68/0xd0
                           [<80324cbc>] spawn_ksoftirqd+0x1c/0x4c
                           [<8006b0fc>] do_one_initcall+0x64/0x1c8
                           [<8031e5c4>] kernel_init+0x4c/0x10c
                           [<8006cee4>] kernel_thread_helper+0x10/0x18
   }
   ... key      at: [<80a1a6a0>] __key.15349+0x0/0x10
   -> (&rq->lock){-.-.-.} ops: 0 {
      IN-HARDIRQ-W at:
                              [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                              [<800b4dc0>] lock_acquire+0x5c/0x84
                              [<8006a974>] _spin_lock+0x34/0x48
                              [<80086f6c>] scheduler_tick+0x24/0xc4
                              [<8009523c>] update_process_times+0x58/0x70
                              [<800ae16c>] tick_handle_periodic+0x20/0x140
                              [<80071530>] c0_compare_interrupt+0x54/0x64
                              [<800be2d0>] handle_IRQ_event+0x38/0x12c
                              [<800bff9c>] handle_percpu_irq+0x48/0xa0
                              [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                              [<8006082c>] ret_from_irq+0x0/0x4
                              [<8008a940>] vprintk+0x434/0x460
                              [<8008a990>] printk+0x24/0x30
                              [<80326004>] lockdep_info+0x34/0xac
                              [<8031e8e4>] start_kernel+0x260/0x388
      IN-SOFTIRQ-W at:
                              [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                              [<800b4dc0>] lock_acquire+0x5c/0x84
                              [<8006a974>] _spin_lock+0x34/0x48
                              [<80084670>] task_rq_lock+0x2c/0x40
                              [<8008492c>] try_to_wake_up+0x40/0x15c
                              [<8008f178>] __do_softirq+0xf8/0x128
                              [<8008f1f4>] do_softirq+0x4c/0xa0
                              [<8006082c>] ret_from_irq+0x0/0x4
                              [<800a8a0c>] sysctl_check_lookup+0xb8/0x164
                              [<800a8cf0>] sysctl_check_table+0x1c4/0x6f0
                              [<800a9190>] sysctl_check_table+0x664/0x6f0
                              [<8009273c>] __register_sysctl_paths+0x114/0x2f8
                              [<80331c00>] inet_init+0x6c/0x26c
                              [<8006b0fc>] do_one_initcall+0x64/0x1c8
                              [<8031e614>] kernel_init+0x9c/0x10c
                              [<8006cee4>] kernel_thread_helper+0x10/0x18
      IN-RECLAIM_FS-W at:
                                 [<800b3d64>] __lock_acquire+0x698/0x8b0
                                 [<800b4dc0>] lock_acquire+0x5c/0x84
                                 [<8006ae7c>] _spin_lock_irq+0x48/0x60
                                 [<80067b80>] __schedule+0x68/0x3c0
                                 [<80067ee8>] schedule+0x10/0x28
                                 [<800d03f4>] kswapd+0xe0/0x4bc
                                 [<800a11c0>] kthread+0x60/0xa4
                                 [<8006cee4>] kernel_thread_helper+0x10/0x18
      INITIAL USE at:
                             [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                             [<800b4dc0>] lock_acquire+0x5c/0x84
                             [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                             [<803399d4>] init_idle+0x2c/0xc4
                             [<80324708>] sched_init+0x254/0x290
                             [<8031e78c>] start_kernel+0x108/0x388
    }
    ... key      at: [<80a146cc>] __key.35967+0x0/0x8
    -> (&rt_b->rt_runtime_lock){-.-...} ops: 0 {
       IN-HARDIRQ-W at:
                                [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                                [<800b4dc0>] lock_acquire+0x5c/0x84
                                [<8006a974>] _spin_lock+0x34/0x48
                                [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                                [<80086690>] enqueue_task_rt+0x44/0x70
                                [<80081034>] enqueue_task+0x34/0x4c
                                [<8008114c>] activate_task+0x48/0x64
                                [<8008496c>] try_to_wake_up+0x80/0x15c
                                [<800bda80>] softlockup_tick+0xe4/0x1a8
                                [<80095210>] update_process_times+0x2c/0x70
                                [<800aebc0>] tick_sched_timer+0x308/0x35c
                                [<800a4724>] __run_hrtimer+0x6c/0xc8
                                [<800a5654>] hrtimer_interrupt+0x224/0x2d0
                                [<80071530>] c0_compare_interrupt+0x54/0x64
                                [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<80060b00>] r4k_wait+0x20/0x40
                                [<8006ce1c>] cpu_idle+0x20/0x40
                                [<8031e9f0>] start_kernel+0x36c/0x388
       IN-SOFTIRQ-W at:
                                [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                [<800b4dc0>] lock_acquire+0x5c/0x84
                                [<8006a974>] _spin_lock+0x34/0x48
                                [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                                [<80086690>] enqueue_task_rt+0x44/0x70
                                [<80081034>] enqueue_task+0x34/0x4c
                                [<8008114c>] activate_task+0x48/0x64
                                [<8008496c>] try_to_wake_up+0x80/0x15c
                                [<800bda80>] softlockup_tick+0xe4/0x1a8
                                [<80095210>] update_process_times+0x2c/0x70
                                [<800aebc0>] tick_sched_timer+0x308/0x35c
                                [<800a4724>] __run_hrtimer+0x6c/0xc8
                                [<800a5654>] hrtimer_interrupt+0x224/0x2d0
                                [<80071530>] c0_compare_interrupt+0x54/0x64
                                [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                [<8006082c>] ret_from_irq+0x0/0x4
                                [<c0c8a6f8>] ath_reset+0x4c4/0x5f8 [ath9k]
       INITIAL USE at:
                               [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                               [<800b4dc0>] lock_acquire+0x5c/0x84
                               [<8006a974>] _spin_lock+0x34/0x48
                               [<80085350>] __enqueue_rt_entity+0x104/0x1e4
                               [<80086690>] enqueue_task_rt+0x44/0x70
                               [<80081034>] enqueue_task+0x34/0x4c
                               [<8008114c>] activate_task+0x48/0x64
                               [<80084f10>] __sched_setscheduler+0x2b4/0x390
                               [<800bdb64>] watchdog+0x20/0x88
                               [<800a11c0>] kthread+0x60/0xa4
                               [<8006cee4>] kernel_thread_helper+0x10/0x18
     }
     ... key      at: [<80a146d4>] __key.32178+0x0/0x8
     -> (&cpu_base->lock){-.-...} ops: 0 {
        IN-HARDIRQ-W at:
                                  [<800b3c7c>] __lock_acquire+0x5b0/0x8b0
                                  [<800b4dc0>] lock_acquire+0x5c/0x84
                                  [<8006a974>] _spin_lock+0x34/0x48
                                  [<800a4894>] hrtimer_run_queues+0x114/0x1b0
                                  [<800950f8>] run_local_timers+0x10/0x24
                                  [<80095210>] update_process_times+0x2c/0x70
                                  [<800ae16c>] tick_handle_periodic+0x20/0x140
                                  [<80071530>] c0_compare_interrupt+0x54/0x64
                                  [<800be2d0>] handle_IRQ_event+0x38/0x12c
                                  [<800bff9c>] handle_percpu_irq+0x48/0xa0
                                  [<8006b914>] plat_irq_dispatch+0x90/0x2a4
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<8008a940>] vprintk+0x434/0x460
                                  [<8008a990>] printk+0x24/0x30
                                  [<801ddfd0>] sock_register+0x94/0xac
                                  [<8033071c>] netlink_proto_init+0x134/0x180
                                  [<8006b0fc>] do_one_initcall+0x64/0x1c8
                                  [<8031e614>] kernel_init+0x9c/0x10c
                                  [<8006cee4>] kernel_thread_helper+0x10/0x18
        IN-SOFTIRQ-W at:
                                  [<800b3ca0>] __lock_acquire+0x5d4/0x8b0
                                  [<800b4dc0>] lock_acquire+0x5c/0x84
                                  [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                  [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
                                  [<800a5158>] hrtimer_start_range_ns+0x24/0x30
                                  [<800ae874>] tick_setup_sched_timer+0x224/0x268
                                  [<800a5c24>] hrtimer_run_pending+0xdc/0x15c
                                  [<80094894>] run_timer_softirq+0x28/0x204
                                  [<8008f0fc>] __do_softirq+0x7c/0x128
                                  [<8008f1f4>] do_softirq+0x4c/0xa0
                                  [<8006082c>] ret_from_irq+0x0/0x4
                                  [<800a8a0c>] sysctl_check_lookup+0xb8/0x164
                                  [<800a8cf0>] sysctl_check_table+0x1c4/0x6f0
                                  [<800a9190>] sysctl_check_table+0x664/0x6f0
                                  [<8009273c>] __register_sysctl_paths+0x114/0x2f8
                                  [<80331c00>] inet_init+0x6c/0x26c
                                  [<8006b0fc>] do_one_initcall+0x64/0x1c8
                                  [<8031e614>] kernel_init+0x9c/0x10c
                                  [<8006cee4>] kernel_thread_helper+0x10/0x18
        INITIAL USE at:
                                 [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                                 [<800b4dc0>] lock_acquire+0x5c/0x84
                                 [<8006aa30>] _spin_lock_irqsave+0x50/0x74
                                 [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
                                 [<800853f8>] __enqueue_rt_entity+0x1ac/0x1e4
                                 [<80086690>] enqueue_task_rt+0x44/0x70
                                 [<80081034>] enqueue_task+0x34/0x4c
                                 [<8008114c>] activate_task+0x48/0x64
                                 [<80084f10>] __sched_setscheduler+0x2b4/0x390
                                 [<800bdb64>] watchdog+0x20/0x88
                                 [<800a11c0>] kthread+0x60/0xa4
                                 [<8006cee4>] kernel_thread_helper+0x10/0x18
      }
      ... key      at: [<80a1a6e0>] __key.16951+0x0/0x8
     ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<800a4eb4>] __hrtimer_start_range_ns+0x44/0x298
   [<800853f8>] __enqueue_rt_entity+0x1ac/0x1e4
   [<80086690>] enqueue_task_rt+0x44/0x70
   [<80081034>] enqueue_task+0x34/0x4c
   [<8008114c>] activate_task+0x48/0x64
   [<80084f10>] __sched_setscheduler+0x2b4/0x390
   [<800bdb64>] watchdog+0x20/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

    ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80085350>] __enqueue_rt_entity+0x104/0x1e4
   [<80086690>] enqueue_task_rt+0x44/0x70
   [<80081034>] enqueue_task+0x34/0x4c
   [<8008114c>] activate_task+0x48/0x64
   [<80084f10>] __sched_setscheduler+0x2b4/0x390
   [<800bdb64>] watchdog+0x20/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

    -> (&rt_rq->rt_runtime_lock){......} ops: 0 {
       INITIAL USE at:
                               [<800b3d7c>] __lock_acquire+0x6b0/0x8b0
                               [<800b4dc0>] lock_acquire+0x5c/0x84
                               [<8006a974>] _spin_lock+0x34/0x48
                               [<80082488>] update_curr_rt+0x124/0x234
                               [<800866d8>] dequeue_task_rt+0x1c/0x4c
                               [<800810e8>] dequeue_task+0x9c/0xb8
                               [<800811b0>] deactivate_task+0x48/0x64
                               [<80067c24>] __schedule+0x10c/0x3c0
                               [<80067ee8>] schedule+0x10/0x28
                               [<800bdb8c>] watchdog+0x48/0x88
                               [<800a11c0>] kthread+0x60/0xa4
                               [<8006cee4>] kernel_thread_helper+0x10/0x18
     }
     ... key      at: [<80a146dc>] __key.35951+0x0/0xc
    ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80082488>] update_curr_rt+0x124/0x234
   [<800866d8>] dequeue_task_rt+0x1c/0x4c
   [<800810e8>] dequeue_task+0x9c/0xb8
   [<800811b0>] deactivate_task+0x48/0x64
   [<80067c24>] __schedule+0x10c/0x3c0
   [<80067ee8>] schedule+0x10/0x28
   [<800bdb8c>] watchdog+0x48/0x88
   [<800a11c0>] kthread+0x60/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

   ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006a974>] _spin_lock+0x34/0x48
   [<80084670>] task_rq_lock+0x2c/0x40
   [<8008492c>] try_to_wake_up+0x40/0x15c
   [<80081380>] __wake_up_common+0x54/0xc0
   [<800828ec>] complete+0x4c/0x6c
   [<800a119c>] kthread+0x3c/0xa4
   [<8006cee4>] kernel_thread_helper+0x10/0x18

  ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<800829e0>] __wake_up+0x30/0x74
   [<8009d224>] __queue_work+0x34/0x54
   [<8009d2b0>] queue_work_on+0x50/0x6c
   [<8009c38c>] call_usermodehelper_exec+0x104/0x144
   [<801861fc>] kobject_uevent_env+0x370/0x3dc
   [<80185538>] kset_register+0x44/0x5c
   [<801ba354>] bus_register+0xb0/0x260
   [<8032e288>] platform_bus_init+0x38/0x64
   [<8032e504>] driver_init+0x30/0x44
   [<8031e5f8>] kernel_init+0x80/0x10c
   [<8006cee4>] kernel_thread_helper+0x10/0x18

 ... acquired at:
   [<800b3310>] validate_chain+0xb44/0xf00
   [<800b3ee4>] __lock_acquire+0x818/0x8b0
   [<800b4dc0>] lock_acquire+0x5c/0x84
   [<8006aa30>] _spin_lock_irqsave+0x50/0x74
   [<8009d210>] __queue_work+0x20/0x54
   [<8009d2b0>] queue_work_on+0x50/0x6c
   [<c0253288>] ieee80211_beacon_get+0x494/0x518 [mac80211]


stack backtrace:
Call Trace:
[<800706e4>] dump_stack+0x8/0x34
[<800b065c>] print_irq_inversion_bug+0x1a0/0x1c4
[<800b4918>] check_usage_forwards+0xd0/0xf0
[<800b0c74>] mark_lock+0x408/0x6f0
[<800b3ca0>] __lock_acquire+0x5d4/0x8b0
[<800b4dc0>] lock_acquire+0x5c/0x84
[<8006aa30>] _spin_lock_irqsave+0x50/0x74
[<c0252f3c>] ieee80211_beacon_get+0x148/0x518 [mac80211]
[<c0c87168>] ath_beacon_tasklet+0x248/0x528 [ath9k]
[<8008f710>] tasklet_action+0x84/0xf0
[<8008f0fc>] __do_softirq+0x7c/0x128
[<8008f1f4>] do_softirq+0x4c/0xa0
[<8006082c>] ret_from_irq+0x0/0x4
[<80060b00>] r4k_wait+0x20/0x40
[<8006ce1c>] cpu_idle+0x20/0x40
[<8031e9f0>] start_kernel+0x36c/0x388
