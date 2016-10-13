Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13108 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932750AbcJMOWv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 10:22:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix kernel panic due to race in accessing arvif list
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1476109278-7957-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1476109278-7957-1-git-send-email-vthiagar@qti.qualcomm.com>
To: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <030f922c81064fa9aa26523b2e7f318d@euamsexm01a.eu.qualcomm.com> (sfid-20161013_162257_718731_0DCA441F)
Date: Thu, 13 Oct 2016 16:21:47 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> wrote:
> arvifs list is traversed within data_lock spin_lock in tasklet
> context to fill channel information from the corresponding vif.
> This means any access to arvifs list for add/del operations
> should also be protected with the same spin_lock to avoid the
> race. Fix this by performing list add/del on arvfis within the
> data_lock. This could fix kernel panic something like the below.
> 
>  LR is at ath10k_htt_rx_pktlog_completion_handler+0x100/0xb6c [ath10k_core]
>  PC is at ath10k_htt_rx_pktlog_completion_handler+0x1c0/0xb6c [ath10k_core]
>  Internal error: Oops: 17 [#1] PREEMPT SMP ARM
>  [<bf4857f4>] (ath10k_htt_rx_pktlog_completion_handler+0x2f4/0xb6c [ath10k_core])
>  [<bf487540>] (ath10k_htt_txrx_compl_task+0x8b4/0x1188 [ath10k_core])
>  [<c00312d4>] (tasklet_action+0x8c/0xec)
>  [<c00309a8>] (__do_softirq+0xdc/0x208)
>  [<c0030d6c>] (irq_exit+0x84/0xe0)
>  [<c005db04>] (__handle_domain_irq+0x80/0xa0)
>  [<c00085c4>] (gic_handle_irq+0x38/0x5c)
>  [<c0009640>] (__irq_svc+0x40/0x74)
> 
> (gdb) list *(ath10k_htt_rx_pktlog_completion_handler+0x1c0)
> 0x136c0 is in ath10k_htt_rx_h_channel (drivers/net/wireless/ath/ath10k/htt_rx.c:769)
> 764		struct cfg80211_chan_def def;
> 765
> 766		lockdep_assert_held(&ar->data_lock);
> 767
> 768		list_for_each_entry(arvif, &ar->arvifs, list) {
> 769			if (arvif->vdev_id == vdev_id &&
> 770			    ath10k_mac_vif_chan(arvif->vif, &def) == 0)
> 771				return def.chan;
> 772		}
> 773
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ebaa4b1620bf ath10k: fix kernel panic due to race in accessing arvif list

-- 
https://patchwork.kernel.org/patch/9369573/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
