Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36866 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcCHNB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 08:01:29 -0500
Received: by mail-wm0-f48.google.com with SMTP id p65so26567963wmp.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 05:01:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <aa44bd32c9f94d8d1a90840189ac0602@codeaurora.org>
References: <1457438096-20071-1-git-send-email-rmanohar@qti.qualcomm.com>
	<CA+BoTQ=Huzf7WoXMXcyj8yrykrJOd5BMc1EnmccqZgt7M1M_uA@mail.gmail.com>
	<aa44bd32c9f94d8d1a90840189ac0602@codeaurora.org>
Date: Tue, 8 Mar 2016 14:01:27 +0100
Message-ID: <CA+BoTQk3i9QjF-W_1AZpMcwyceO-KDx8=R-swP0J-thqdxRcMg@mail.gmail.com> (sfid-20160308_140136_590636_F8421B94)
Subject: Re: [PATCH v3] ath10k: move mgmt descriptor limit handle under mgmt_tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2016 at 13:54, Rajkumar Manoharan <rmanohar@codeaurora.org> wrote:
> On , Michal Kazior wrote:
>>
>> On 8 March 2016 at 12:54, Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> wrote:
>> [...]
>>>
>>> +int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
>>> +                                  bool is_presp)
>>>  {
>>>         struct ath10k *ar = htt->ar;
>>>
>>>         lockdep_assert_held(&htt->tx_lock);
>>>
>>> +       if (!is_mgmt)
>>> +               return 0;
>>> +
>>
>>
>>>         if (htt->num_pending_tx >= htt->max_num_pending_tx)
>>>                 return -EBUSY;
>>
>>
>> This busy here will be hit when you use last tx slot because
>> tx_inc_pending() is called before tx_mgmt_inc_pending().
>>
> Yeah.. now this condition is not needed as ath10k_htt_tx_mgmt_inc_pending
> will be called only when tx_inc_pending succeeds. will remove this.
>
>>
>> [...]
>>>
>>>         skb_cb = ATH10K_SKB_CB(msdu);
>>>         txq = skb_cb->txq;
>>>         artxq = (void *)txq->drv_priv;
>>>
>>> -       if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
>>> -           ar->hw_params.max_probe_resp_desc_thres)
>>> -               limit_mgmt_desc = true;
>>> -
>>
>>
>> Oh wait.. I didn't pay attention before, but this looks rather ugly.
>> With this you will actually make the num_pending_mgmt_tx spin
>> endlessly upwards on firmware with HTT 3.0 (and uses TX_FRM for mgmt
>> tx and TX_COMPL_IND for completions), no?
>>
> Oops.. num_pending_mgmt_tx should be incremented only for MGMT_TX. Thats
> why it is moved out of txrx_tx_unref.

Hmm.. in that case I think you should change is_htt in mac_op_tx() to
compare only against TX_HTT_MGMT (instead of both TX_HTT and
TX_HTT_MGMT).

Note, the is_mgmt should stay as it is possible for the TX_HTT_MGMT to
be used for non-mgmt frames in some cases. This also implies you need
to check for ATH10K_SKB_F_MGMT on the mgmt-tx-completion event as well
(you might get to handle NullFunc there).


Michał
