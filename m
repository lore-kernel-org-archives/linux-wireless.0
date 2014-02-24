Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56730 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbaBXLt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 06:49:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 5/7] ath10k: batch htt tx/rx completions
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-6-git-send-email-michal.kazior@tieto.com>
	<87lhx7xhno.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=yRjvA9ZN6Dizp-Vf8_GRJE79uMfsVXNaNaidUchukfQ@mail.gmail.com>
Date: Mon, 24 Feb 2014 13:49:23 +0200
In-Reply-To: <CA+BoTQ=yRjvA9ZN6Dizp-Vf8_GRJE79uMfsVXNaNaidUchukfQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 20 Feb 2014 12:23:10 +0100")
Message-ID: <87sir8u3wc.fsf@kamboji.qca.qualcomm.com> (sfid-20140224_124931_794016_C3DD6613)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 19 February 2014 16:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> HTT Rx endpoint processes both frame rx
>>> indications and frame tx completion indications.
>>>
>>> Those completions typically come in batches and
>>> may be mixed so it makes sense to defer processing
>>> hoping to get a bunch of them and take advantage
>>> of hot caches.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> [...]
>>
>>> @@ -270,7 +274,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
>>>       int idx;
>>>       struct sk_buff *msdu;
>>>
>>> -     spin_lock_bh(&htt->rx_ring.lock);
>>> +     lockdep_assert_held(&htt->rx_ring.lock);
>>
>> There are some locking changes which I think would be better to have in
>> a separate patch.
>
> I don't think it makes much sense. It seems silly to move a few lines
> in one patch to move some of those lines again in another one.

I'm not really getting your point here. Moving things back and forth
would not make any sense, but that's not what I was asking either.

I noticed that you were taking locks in a larger scope (and earlier)
than before. I was just thinking would it be possible to make that
locking changes in a separate patch, that way it would be easier to
bisect regressions if/when they show up.

-- 
Kalle Valo
