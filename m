Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41168 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaB1J22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 04:28:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 4/8] ath10k: bypass htc for htt tx path
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-1-git-send-email-michal.kazior@tieto.com>
	<1393485587-16879-5-git-send-email-michal.kazior@tieto.com>
	<8738j3d2t2.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQn8GTu3A4LdRGtpJeVr0SnaApTwnNZAoZ8=3Vj5qF+W=g@mail.gmail.com>
Date: Fri, 28 Feb 2014 11:28:23 +0200
In-Reply-To: <CA+BoTQn8GTu3A4LdRGtpJeVr0SnaApTwnNZAoZ8=3Vj5qF+W=g@mail.gmail.com>
	(Michal Kazior's message of "Fri, 28 Feb 2014 10:15:20 +0100")
Message-ID: <87txbjbn7s.fsf@kamboji.qca.qualcomm.com> (sfid-20140228_102835_093730_912FF0B8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 28 February 2014 10:06, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/htc.c
>>> +++ b/drivers/net/wireless/ath/ath10k/htc.c
>>> @@ -202,10 +202,8 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
>>>       struct ath10k_htc *htc = &ar->htc;
>>>       struct ath10k_htc_ep *ep = &htc->endpoint[eid];
>>>
>>> -     if (!skb) {
>>> -             ath10k_warn("invalid sk_buff completion - NULL pointer. firmware crashed?\n");
>>> +     if (WARN_ON(!skb))
>>>               return 0;
>>> -     }
>>
>> WARN_ON() is a bit dangerous here as it might cause excessive spamming.
>> Why did you want to change this? I think either ath10k_warn() or
>> WARN_ON_ONCE() would be safer, but not sure which one to use.
>
> After the scatter-gather patch no NULL skb should be ever passed to tx
> completion handler as those are ignored by hif/pci.

Sure. But that's just theory, in practise all sorts bugs can always
happen :)

> Perhaps the hunk should be moved from this patch to the scatter-gather
> one.

Nah, I don't think that's necessary.

> Perhaps WARN_ON() is a bit over the top here, but since this is now
> more of a logic issue rather than runtime issue I decided to change it
> from ath10k_warn to WARN_ON(). It's probably still a good idea to make
> it _ONCE generally, although if you actually get skbuff it's already
> too late or it should be screaming loudly because someone must've
> changed the code in an incorrect/incomplete way.

So I change it to WARN_ON_ONCE(), ok?

-- 
Kalle Valo
