Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13109 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LPNIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 08:08:55 -0500
Message-ID: <4EEB42DF.1000207@qca.qualcomm.com> (sfid-20111216_140859_138661_D5274080)
Date: Fri, 16 Dec 2011 18:38:47 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH 1/1] ath9k: fix a soft lockup
References: <1324040752-4583-1-git-send-email-mohammed@qca.qualcomm.com> <4EEB42A5.7050805@qca.qualcomm.com>
In-Reply-To: <4EEB42A5.7050805@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 December 2011 06:37 PM, Mohammed Shafi Shajakhan wrote:
> On Friday 16 December 2011 06:35 PM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> with the recent changes in the tx path we got a soft lockup.
>> introduced by the commit 3ad2952998b08442044690fa9b4ec38c6c3fc4a9
>> ath_send_bar seems to later call ath9k_tx which in turn seems to
>> acquire the same axq_lock before calling ath_tx_start_dma
>
> this seems to fix the softlock up with my preliminary testing.
> if some one finds a flaw in this or a better fix please feel free
> to resend. i will be out of station for two days.
>
>>
>> Call Trace:
>> [<c03ba9ae>] __delay+0xe/0x10
>> [<c03c1dc2>] do_raw_spin_lock+0xb2/0x100
>> [<c0671a67>] _raw_spin_lock_bh+0x67/0x80
>> [<f984aa81>] ? ath_tx_start+0x151/0x4c0 [ath9k]
>> [<f984aa81>] ath_tx_start+0x151/0x4c0 [ath9k]
>> [<f984248c>] ath9k_tx+0x9c/0x1f0 [ath9k]
>> [<f97eae3e>] __ieee80211_tx+0x18e/0x2d0 [mac80211]
>> [<f97ec9ac>] ieee80211_tx+0xfc/0x130 [mac80211]
>> [<f97ec8e3>] ? ieee80211_tx+0x33/0x130 [mac80211]
>> [<f97ecd88>] ieee80211_xmit+0xc8/0x130 [mac80211]
>> [<f97eccc0>] ? ieee80211_tx_pending+0x2e0/0x2e0
>> [mac80211]
>> [<f97ece3d>] ieee80211_tx_skb_tid+0x4d/0x60 [mac80211]
>> [<f97ceda4>] ieee80211_send_bar+0xd4/0xf0 [mac80211]
>> [<f984a04a>] ath_tx_complete_aggr+0x52a/0xaa0 [ath9k]
>> [<f9849bd0>] ? ath_tx_complete_aggr+0xb0/0xaa0 [ath9k]
>> [<f9840029>] ? setup_ht_cap+0x169/0x180 [ath9k]
>> [<f984b606>] ? ath_tx_edma_tasklet+0x76/0x2a0 [ath9k]
>> [<f984b606>] ? ath_tx_edma_tasklet+0x76/0x2a0 [ath9k]
>> [<f984a628>] ath_tx_process_buffer+0x68/0xe0 [ath9k]
>> [<f984b705>] ath_tx_edma_tasklet+0x175/0x2a0 [ath9k]
>> [<f983fc2d>] ? ath9k_ioread32+0x2d/0x70 [ath9k]
>> [<f9842b4b>] ath9k_tasklet+0x10b/0x1c0 [ath9k]
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>> drivers/net/wireless/ath/ath9k/xmit.c | 7 ++++++-
>> 1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
>> b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 23e80e6..ef81df0 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -189,8 +189,11 @@ static void ath_tx_flush_tid(struct ath_softc
>> *sc, struct ath_atx_tid *tid)
>> tid->state&= ~AGGR_CLEANUP;
>> }
>>
>> - if (sendbar)
>> + if (sendbar) {
>> + spin_unlock_bh(&txq->axq_lock);
>> ath_send_bar(tid, tid->seq_start);
>> + spin_lock_bh(&txq->axq_lock);
>> + }
>> }
>>
>> static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid
>> *tid,
>> @@ -556,7 +559,9 @@ static void ath_tx_complete_aggr(struct ath_softc
>> *sc, struct ath_txq *txq,
>>
>> if (bar_index>= 0) {
>> u16 bar_seq = ATH_BA_INDEX2SEQ(seq_first, bar_index);
>> + spin_unlock_bh(&txq->axq_lock);
>> ath_send_bar(tid, ATH_BA_INDEX2SEQ(seq_first, bar_index + 1));
>> + spin_lock_bh(&txq->axq_lock);
>> if (BAW_WITHIN(tid->seq_start, tid->baw_size, bar_seq))
>> tid->bar_index = ATH_BA_INDEX(tid->seq_start, bar_seq);
>> }
>
>


-- 
thanks,
shafi
