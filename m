Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41648 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754940AbcLBAZB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 19:25:01 -0500
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: Michal Kazior <michal.kazior@tieto.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com>
 <57B70AED.2010200@candelatech.com>
 <ba1cc818-6194-11d6-7cc3-1db28036a519@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <ef7e16a6-9353-0f63-ac70-fc8e234d6c25@candelatech.com> (sfid-20161202_012504_524251_B9570F34)
Date: Thu, 1 Dec 2016 16:24:59 -0800
MIME-Version: 1.0
In-Reply-To: <ba1cc818-6194-11d6-7cc3-1db28036a519@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2016 02:52 PM, Ben Greear wrote:
> On 08/19/2016 06:34 AM, Ben Greear wrote:
>>
>>
>> On 08/18/2016 11:59 PM, Michal Kazior wrote:
>>> On 19 August 2016 at 03:26,  <greearb@candelatech.com> wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> I was seeing kernel crashes due to accessing freed memory
>>>> while debugging a 9984 firmware that was crashing often.
>>>>
>>>> This patch fixes the crashes.  I am not certain if there
>>>> is a better way or not.

Michal, thanks for the help on IRC.  I added this logic:

static void ieee80211_drv_tx(struct ieee80211_local *local,
			     struct ieee80211_vif *vif,
			     struct ieee80211_sta *pubsta,
			     struct sk_buff *skb)
{
	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
	struct ieee80211_tx_control control = {
		.sta = pubsta,
	};
	struct ieee80211_txq *txq = NULL;
	struct txq_info *txqi;
	u8 ac;

	if ((info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM) ||
	    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
		goto tx_normal;

	if (!ieee80211_is_data(hdr->frame_control))
		goto tx_normal;

	if (unlikely(!ieee80211_sdata_running(sdata))) {
		WARN_ON_ONCE(1);
		goto delete_and_return;
	}

...

	if (atomic_read(&sdata->txqs_len[ac]) >=
	    (local->hw.txq_ac_max_pending * 2)) {
		/* Must be that something is not paying attention to
		 * max-pending, like pktgen, so just drop this frame.
		 */
delete_and_return:
		ieee80211_free_txskb(&local->hw, skb);
		return;
	}


But, I still see the txq entries on the ar->txqs list in the ath10k_mac_txq_init
after firmware crash in my test case.  Is this the test you were suggesting?


Thanks,
Ben

>
>
> I did some more hacking on this today.  I think I found some better clue on this.
>
> I added this code:
>
> static void ath10k_mac_txq_init(struct ath10k *ar, struct ieee80211_txq *txq)
> {
>     struct ath10k_txq *artxq = (void *)txq->drv_priv;
>     struct ath10k_txq *tmp, *walker;
>     struct ieee80211_txq *txq_tmp;
>     int i = 0;
>
>     if (!txq)
>         return;
>
>     spin_lock_bh(&ar->txqs_lock);
>     ar->txqs_lock.rlock.dbg1 = 104;
>
>     /* Remove from ar->txqs in case it still exists there. */
>     list_for_each_entry_safe(walker, tmp, &ar->txqs, list) {
>         txq_tmp = container_of((void *)walker, struct ieee80211_txq,
>                        drv_priv);
>         if ((++i % 10000) == 0) {
>             ath10k_err(ar, "txq-init: Checking txq_tmp: %p i: %d\n", txq_tmp, i);
>             ath10k_err(ar, "txq-init: txqs: %p walker->list: %p w->next: %p  w->prev: %p ar->txqs: %p\n",
>                    &ar->txqs, &(walker->list), walker->list.next, walker->list.prev, &ar->txqs);
>         }
>
>         if (txq_tmp == txq) {
>             WARN_ON_ONCE(1);
>             ath10k_err(ar, "txq-init: Found txq when it should be deleted, txq_tmp: %p  txq: %p\n",
>                    txq_tmp, txq);
>             list_del(&walker->list);
>         }
>     }
>     spin_unlock_bh(&ar->txqs_lock);
>
>     INIT_LIST_HEAD(&artxq->list);
> }
>
>
> [firmware has just crashed]
>
> Dec 01 14:43:06 wave2 kernel: ------------[ cut here ]------------
> Dec 01 14:43:06 wave2 kernel: WARNING: CPU: 0 PID: 193 at /home/greearb/git/linux-4.7.dev.y/drivers/net/wireless/ath/ath10k/mac.c:4217
> ath10k_mac_txq_init+0x1a7/0x1b0 [ath10k_core]
> Dec 01 14:43:06 wave2 kernel: Modules linked in: nf_conntrack_netlink nf_conntrack nfnetlink nf_defrag_ipv4 bridge 8021q garp mrp stp llc bnep bluetooth fuse
> macvlan pktgen rpcsec_gss_krb5 nfsv4 nfs fscache coretemp hwmon intel_rapl x86_pkg_temp_thermal intel_powerclamp snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_codec_generic kvm iTCO_wdt irqbypass iTCO_vendor_support ath10k_pci ath10k_core joydev ath snd_hda_intel mac80211 snd_hda_codec snd_hda_core snd_hwdep
> snd_seq snd_seq_device pcspkr cfg80211 snd_pcm snd_timer snd i2c_i801 lpc_ich shpchp soundcore tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc serio_raw
> i915 i2c_algo_bit ata_generic drm_kms_helper pata_acpi e1000e ptp drm pps_core i2c_core fjes video ipv6 [last unloaded: nf_conntrack]
> Dec 01 14:43:06 wave2 kernel: CPU: 0 PID: 193 Comm: kworker/0:1 Not tainted 4.7.10+ #14
> Dec 01 14:43:06 wave2 kernel: Hardware name: To be filled by O.E.M. To be filled by O.E.M./ChiefRiver, BIOS 4.6.5 06/07/2013
> Dec 01 14:43:06 wave2 kernel: Workqueue: events_freezable ieee80211_restart_work [mac80211]
> Dec 01 14:43:06 wave2 kernel:  ffffffffa0e29507 ffff8801d14f7920 ffffffff8169ed08 0000000000000000
> Dec 01 14:43:06 wave2 kernel:  0000000000000000 ffff8801d14f7968 ffffffff811569bc ffff8801d14e4f00
> Dec 01 14:43:06 wave2 kernel:  0000107900000001 ffff8800c43ec9a0 0000000000000027 ffff8800c43ec988
> Dec 01 14:43:06 wave2 kernel: Call Trace:
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0e29507>] ? ath10k_mac_txq_init+0x1a7/0x1b0 [ath10k_core]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff8169ed08>] dump_stack+0x85/0xcd
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff811569bc>] __warn+0x10c/0x130
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81156b58>] warn_slowpath_null+0x18/0x20
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0e29507>] ath10k_mac_txq_init+0x1a7/0x1b0 [ath10k_core]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0e3766f>] ath10k_sta_state+0x4ef/0x1350 [ath10k_core]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff811e10ed>] ? mark_lock+0x6d/0x8a0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0e37180>] ? ath10k_station_assoc+0x920/0x920 [ath10k_core]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff811ddd14>] ? __lock_is_held+0x84/0xc0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0c0095f>] drv_sta_state+0xef/0xc50 [mac80211]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0c6b1b0>] ieee80211_reconfig+0x10a0/0x2890 [mac80211]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffffa0bf8361>] ieee80211_restart_work+0xb1/0xf0 [mac80211]
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81184dad>] process_one_work+0x42d/0xac0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81184cf4>] ? process_one_work+0x374/0xac0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81184980>] ? pwq_dec_nr_in_flight+0x110/0x110
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff811854c6>] worker_thread+0x86/0x730
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81df25aa>] ? _raw_spin_unlock_irqrestore+0x5a/0x70
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81185440>] ? process_one_work+0xac0/0xac0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff8118f381>] kthread+0x191/0x1b0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff8118f1f0>] ? kthread_create_on_node+0x320/0x320
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff8119baa3>] ? preempt_count_sub+0x13/0xd0
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff81df2f8f>] ret_from_fork+0x1f/0x40
> Dec 01 14:43:06 wave2 kernel:  [<ffffffff8118f1f0>] ? kthread_create_on_node+0x320/0x320
> Dec 01 14:43:06 wave2 kernel: ---[ end trace e64bc8f0c1a2531b ]---
> Dec 01 14:43:06 wave2 kernel: ath10k_pci 0000:05:00.0: txq-init: Found txq when it should be deleted, txq_tmp: ffff8800c43ec988  txq: ffff8800c43ec988
> Dec 01 14:43:07 wave2 kernel: ath10k_pci 0000:05:00.0: dropping dbg buffer due to crash since read
>
>
> Thanks,
> Ben
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
