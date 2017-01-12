Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59815 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750893AbdALScZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 13:32:25 -0500
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
To: Michal Kazior <michal.kazior@tieto.com>, johannes@sipsolutions.net
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <f0d5cbb6-14cc-91c9-a378-2ab9b1551cef@nbd.name> (sfid-20170112_193336_890780_759B2F3A)
Date: Thu, 12 Jan 2017 19:11:01 +0100
MIME-Version: 1.0
In-Reply-To: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-12 15:28, Michal Kazior wrote:
> Station structure is considered as not uploaded
> (to driver) until drv_sta_state() finishes. This
> call is however done after the structure is
> attached to mac80211 internal lists and hashes.
> This means mac80211 can lookup (and use) station
> structure before it is uploaded to a driver.
> 
> If this happens (structure exists, but
> sta->uploaded is false) fast_tx path can still be
> taken. Deep in the fastpath call the sta->uploaded
> is checked against to derive "pubsta" argument for
> ieee80211_get_txq(). If sta->uploaded is false
> (and sta is actually non-NULL) ieee80211_get_txq()
> effectively downgraded to vif->txq.
> 
> At first glance this may look innocent but coerces
> mac80211 into a state that is almost guaranteed
> (codel may drop offending skb) to crash because a
> station-oriented skb gets queued up on
> vif-oriented txq. The ieee80211_tx_dequeue() ends
> up looking at info->control.flags and tries to use
> txq->sta which in the fail case is NULL.
> 
> It's probably pointless to pretend one can
> downgrade skb from sta-txq to vif-txq.
> 
> Only drivers using wake_tx_queue were affected.
> 
> Example crash dump before fix:
> 
>  Unable to handle kernel paging request at virtual address ffffe26c
>  PC is at ieee80211_tx_dequeue+0x204/0x690 [mac80211]
>  [<bf4252a4>] (ieee80211_tx_dequeue [mac80211]) from
>  [<bf4b1388>] (ath10k_mac_tx_push_txq+0x54/0x1c0 [ath10k_core])
>  [<bf4b1388>] (ath10k_mac_tx_push_txq [ath10k_core]) from
>  [<bf4bdfbc>] (ath10k_htt_txrx_compl_task+0xd78/0x11d0 [ath10k_core])
>  [<bf4bdfbc>] (ath10k_htt_txrx_compl_task [ath10k_core])
>  [<bf51c5a4>] (ath10k_pci_napi_poll+0x54/0xe8 [ath10k_pci])
>  [<bf51c5a4>] (ath10k_pci_napi_poll [ath10k_pci]) from
>  [<c0572e90>] (net_rx_action+0xac/0x160)
> 
> Reported-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
