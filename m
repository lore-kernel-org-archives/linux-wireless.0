Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34163 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcCIGOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 01:14:49 -0500
Received: by mail-wm0-f41.google.com with SMTP id p65so178014374wmp.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 22:14:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8a472460d3b4aa7ce614bdfe73b29844@codeaurora.org>
References: <1457457934-8563-1-git-send-email-rmanohar@qti.qualcomm.com>
	<CA+BoTQmxg7vK6KBENrx+P3vK_nYV4-h_yiavEBQi1oFTAANR=w@mail.gmail.com>
	<8a472460d3b4aa7ce614bdfe73b29844@codeaurora.org>
Date: Wed, 9 Mar 2016 07:14:48 +0100
Message-ID: <CA+BoTQmPccuZR=szNSqOg9uxtB9=QmbvQR8r88uDrd=9bUwakg@mail.gmail.com> (sfid-20160309_071453_846816_3D67221E)
Subject: Re: [PATCH v4] ath10k: move mgmt descriptor limit handle under mgmt_tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2016 at 07:08, Rajkumar Manoharan <rmanohar@codeaurora.org> wrote:
> On , Michal Kazior wrote:
>>
>> On 8 March 2016 at 18:25, Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> wrote:
>> [...]
>>>
>>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>>> @@ -2326,7 +2326,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar,
>>> struct sk_buff *skb)
>>>                         break;
>>>                 }
>>>
>>> -               ath10k_txrx_tx_unref(htt, &tx_done);
>>> +               status = ath10k_txrx_tx_unref(htt, &tx_done);
>>> +               if (!status) {
>>> +                       spin_lock_bh(&htt->tx_lock);
>>> +                       ath10k_htt_tx_mgmt_dec_pending(htt);
>>> +                       spin_unlock_bh(&htt->tx_lock);
>>> +               }
>>
>> [...]
>>>
>>> @@ -3978,14 +3976,13 @@ static void ath10k_mac_op_tx(struct ieee80211_hw
>>> *hw,
>>>         txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
>>>         is_htt = (txpath == ATH10K_MAC_TX_HTT ||
>>>                   txpath == ATH10K_MAC_TX_HTT_MGMT);
>>> +       is_mgmt = (txpath == ATH10K_MAC_TX_HTT_MGMT);
>>
>>
>> Are you sure you want to be counting nullfuncs here in as well (and
>> possibly other frames that end up, for whatever reason, on htt-mgmt
>> tx-path?)
>>
>
> frames that are transmitted via MGMT_TX are using reserved descriptor slots
> in firmware. So irrespective of frame type, num_pending_mgmt_tx should count
> all to limit probe resp. Here mgmt_tx does not mean frame type but HTT
> txmode (HTT_H2T_MSG_TYPE_MGMT_TX).
>
> So ATH10K_SKB_F_MGMT check in tx-compl is not needed. is_mgmt = (txpath ==
> ATH10K_MAC_TX_HTT_MGMT);
>
> Do you see any issues if nullfunc/other data via MGMT_TX are counted.

If firmware handles them the same way it should be okay I guess. I
would do suggest to make the commit log more explicit on this though
(i.e. the limit is for the path itself, not for mgmt frames per se).


Michał
