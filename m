Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39114 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaBTLXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 06:23:12 -0500
Received: by mail-bk0-f48.google.com with SMTP id 6so580672bkj.21
        for <linux-wireless@vger.kernel.org>; Thu, 20 Feb 2014 03:23:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lhx7xhno.fsf@kamboji.qca.qualcomm.com>
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-6-git-send-email-michal.kazior@tieto.com>
	<87lhx7xhno.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 20 Feb 2014 12:23:10 +0100
Message-ID: <CA+BoTQ=yRjvA9ZN6Dizp-Vf8_GRJE79uMfsVXNaNaidUchukfQ@mail.gmail.com> (sfid-20140220_122325_116816_1B044378)
Subject: Re: [RFC/RFT 5/7] ath10k: batch htt tx/rx completions
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 16:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> HTT Rx endpoint processes both frame rx
>> indications and frame tx completion indications.
>>
>> Those completions typically come in batches and
>> may be mixed so it makes sense to defer processing
>> hoping to get a bunch of them and take advantage
>> of hot caches.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -270,7 +274,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
>>       int idx;
>>       struct sk_buff *msdu;
>>
>> -     spin_lock_bh(&htt->rx_ring.lock);
>> +     lockdep_assert_held(&htt->rx_ring.lock);
>
> There are some locking changes which I think would be better to have in
> a separate patch.

I don't think it makes much sense. It seems silly to move a few lines
in one patch to move some of those lines again in another one.


>>       case HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION: {
>> +             struct htt_resp *resp = (struct htt_resp *)skb->data;
>>               struct htt_tx_done tx_done = {};
>>               int status = __le32_to_cpu(resp->mgmt_tx_completion.status);
>>
>> -             tx_done.msdu_id =
>> -                     __le32_to_cpu(resp->mgmt_tx_completion.desc_id);
>> +             tx_done.msdu_id = __le32_to_cpu(resp->mgmt_tx_completion.desc_id);
>
> I don't see any changes here.

Right. I'll cut this hunk out.


Michał
