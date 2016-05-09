Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43395 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcEIRTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 13:19:21 -0400
Subject: Re: [PATCH v2 5/5] ath10k: Fix deadlock when peer cannot be created.
To: ath10k@lists.infradead.org
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
 <1459545132-11295-5-git-send-email-greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5730C697.206@candelatech.com> (sfid-20160509_191925_574533_A5BE2B57)
Date: Mon, 9 May 2016 10:19:19 -0700
MIME-Version: 1.0
In-Reply-To: <1459545132-11295-5-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle:  I notice these 5 patches are not in the latest wireless-testing.

Are they not acceptable, or???

Thanks,
Ben

On 04/01/2016 02:12 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> We must not attempt to send WMI packets while holding the data-lock,
> as it may deadlock:
>
> BUG: sleeping function called from invalid context at drivers/net/wireless/ath/ath10k/wmi.c:1824
> in_atomic(): 1, irqs_disabled(): 0, pid: 2878, name: wpa_supplicant
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 4.4.6+ #21 Tainted: G        W  O
> ---------------------------------------------
> wpa_supplicant/2878 is trying to acquire lock:
>   (&(&ar->data_lock)->rlock){+.-...}, at: [<ffffffffa0721511>] ath10k_wmi_tx_beacons_iter+0x26/0x11a [ath10k_core]
>
> but task is already holding lock:
>   (&(&ar->data_lock)->rlock){+.-...}, at: [<ffffffffa070251b>] ath10k_peer_create+0x122/0x1ae [ath10k_core]
>
> other info that might help us debug this:
>   Possible unsafe locking scenario:
>
>         CPU0
>         ----
>    lock(&(&ar->data_lock)->rlock);
>    lock(&(&ar->data_lock)->rlock);
>
>   *** DEADLOCK ***
>
>   May be due to missing lock nesting notation
>
> 4 locks held by wpa_supplicant/2878:
>   #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff816493ca>] rtnl_lock+0x12/0x14
>   #1:  (&ar->conf_mutex){+.+.+.}, at: [<ffffffffa0706932>] ath10k_add_interface+0x3b/0xbda [ath10k_core]
>   #2:  (&(&ar->data_lock)->rlock){+.-...}, at: [<ffffffffa070251b>] ath10k_peer_create+0x122/0x1ae [ath10k_core]
>   #3:  (rcu_read_lock){......}, at: [<ffffffffa062f304>] rcu_read_lock+0x0/0x66 [mac80211]
>
> stack backtrace:
> CPU: 3 PID: 2878 Comm: wpa_supplicant Tainted: G        W  O    4.4.6+ #21
> Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
>   0000000000000000 ffff8801fcadf8f0 ffffffff8137086d ffffffff82681720
>   ffffffff82681720 ffff8801fcadf9b0 ffffffff8112e3be ffff8801fcadf920
>   0000000100000000 ffffffff82681720 ffffffffa0721500 ffff8801fcb8d348
> Call Trace:
>   [<ffffffff8137086d>] dump_stack+0x81/0xb6
>   [<ffffffff8112e3be>] __lock_acquire+0xc5b/0xde7
>   [<ffffffffa0721500>] ? ath10k_wmi_tx_beacons_iter+0x15/0x11a [ath10k_core]
>   [<ffffffff8112d0d0>] ? mark_lock+0x24/0x201
>   [<ffffffff8112e908>] lock_acquire+0x132/0x1cb
>   [<ffffffff8112e908>] ? lock_acquire+0x132/0x1cb
>   [<ffffffffa0721511>] ? ath10k_wmi_tx_beacons_iter+0x26/0x11a [ath10k_core]
>   [<ffffffffa07214eb>] ? ath10k_wmi_cmd_send_nowait+0x1ce/0x1ce [ath10k_core]
>   [<ffffffff816f9e2b>] _raw_spin_lock_bh+0x31/0x40
>   [<ffffffffa0721511>] ? ath10k_wmi_tx_beacons_iter+0x26/0x11a [ath10k_core]
>   [<ffffffffa0721511>] ath10k_wmi_tx_beacons_iter+0x26/0x11a [ath10k_core]
>   [<ffffffffa07214eb>] ? ath10k_wmi_cmd_send_nowait+0x1ce/0x1ce [ath10k_core]
>   [<ffffffffa062eb18>] __iterate_interfaces+0x9d/0x13d [mac80211]
>   [<ffffffffa062f609>] ieee80211_iterate_active_interfaces_atomic+0x32/0x3e [mac80211]
>   [<ffffffffa07214eb>] ? ath10k_wmi_cmd_send_nowait+0x1ce/0x1ce [ath10k_core]
>   [<ffffffffa071fa9f>] ath10k_wmi_tx_beacons_nowait.isra.13+0x14/0x16 [ath10k_core]
>   [<ffffffffa0721676>] ath10k_wmi_cmd_send+0x71/0x242 [ath10k_core]
>   [<ffffffffa07023f6>] ath10k_wmi_peer_delete+0x3f/0x42 [ath10k_core]
>   [<ffffffffa0702557>] ath10k_peer_create+0x15e/0x1ae [ath10k_core]
>   [<ffffffffa0707004>] ath10k_add_interface+0x70d/0xbda [ath10k_core]
>   [<ffffffffa05fffcc>] drv_add_interface+0x123/0x1a5 [mac80211]
>   [<ffffffffa061554b>] ieee80211_do_open+0x351/0x667 [mac80211]
>   [<ffffffffa06158aa>] ieee80211_open+0x49/0x4c [mac80211]
>   [<ffffffff8163ecf9>] __dev_open+0x88/0xde
>   [<ffffffff8163ef6e>] __dev_change_flags+0xa4/0x13a
>   [<ffffffff8163f023>] dev_change_flags+0x1f/0x54
>   [<ffffffff816a5532>] devinet_ioctl+0x2b9/0x5c9
>   [<ffffffff816514dd>] ? copy_to_user+0x32/0x38
>   [<ffffffff816a6115>] inet_ioctl+0x81/0x9d
>   [<ffffffff816a6115>] ? inet_ioctl+0x81/0x9d
>   [<ffffffff81621cf8>] sock_do_ioctl+0x20/0x3d
>   [<ffffffff816223c4>] sock_ioctl+0x222/0x22e
>   [<ffffffff8121cf95>] do_vfs_ioctl+0x453/0x4d7
>   [<ffffffff81625603>] ? __sys_recvmsg+0x4c/0x5b
>   [<ffffffff81225af1>] ? __fget_light+0x48/0x6c
>   [<ffffffff8121d06b>] SyS_ioctl+0x52/0x74
>   [<ffffffff816fa736>] entry_SYSCALL_64_fastpath+0x16/0x7a
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>   drivers/net/wireless/ath/ath10k/mac.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 020dd25..be8345c 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -700,10 +700,10 @@ static int ath10k_peer_create(struct ath10k *ar,
>
>   	peer = ath10k_peer_find(ar, vdev_id, addr);
>   	if (!peer) {
> +		spin_unlock_bh(&ar->data_lock);
>   		ath10k_warn(ar, "failed to find peer %pM on vdev %i after creation\n",
>   			    addr, vdev_id);
>   		ath10k_wmi_peer_delete(ar, vdev_id, addr);
> -		spin_unlock_bh(&ar->data_lock);
>   		return -ENOENT;
>   	}
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

