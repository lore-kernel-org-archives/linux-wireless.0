Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49637 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcCHMyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 07:54:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 08 Mar 2016 18:24:13 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: move mgmt descriptor limit handle under
 mgmt_tx
In-Reply-To: <CA+BoTQ=Huzf7WoXMXcyj8yrykrJOd5BMc1EnmccqZgt7M1M_uA@mail.gmail.com>
References: <1457438096-20071-1-git-send-email-rmanohar@qti.qualcomm.com>
 <CA+BoTQ=Huzf7WoXMXcyj8yrykrJOd5BMc1EnmccqZgt7M1M_uA@mail.gmail.com>
Message-ID: <aa44bd32c9f94d8d1a90840189ac0602@codeaurora.org> (sfid-20160308_135418_087401_DBE77A75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Michal Kazior wrote:
> On 8 March 2016 at 12:54, Rajkumar Manoharan 
> <rmanohar@qti.qualcomm.com> wrote:
> [...]
>> +int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool 
>> is_mgmt,
>> +                                  bool is_presp)
>>  {
>>         struct ath10k *ar = htt->ar;
>> 
>>         lockdep_assert_held(&htt->tx_lock);
>> 
>> +       if (!is_mgmt)
>> +               return 0;
>> +
> 
>>         if (htt->num_pending_tx >= htt->max_num_pending_tx)
>>                 return -EBUSY;
> 
> This busy here will be hit when you use last tx slot because
> tx_inc_pending() is called before tx_mgmt_inc_pending().
> 
Yeah.. now this condition is not needed as 
ath10k_htt_tx_mgmt_inc_pending
will be called only when tx_inc_pending succeeds. will remove this.

> 
> [...]
>>         skb_cb = ATH10K_SKB_CB(msdu);
>>         txq = skb_cb->txq;
>>         artxq = (void *)txq->drv_priv;
>> 
>> -       if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
>> -           ar->hw_params.max_probe_resp_desc_thres)
>> -               limit_mgmt_desc = true;
>> -
> 
> Oh wait.. I didn't pay attention before, but this looks rather ugly.
> With this you will actually make the num_pending_mgmt_tx spin
> endlessly upwards on firmware with HTT 3.0 (and uses TX_FRM for mgmt
> tx and TX_COMPL_IND for completions), no?
> 
Oops.. num_pending_mgmt_tx should be incremented only for MGMT_TX. Thats
why it is moved out of txrx_tx_unref.

-Rajkumar
