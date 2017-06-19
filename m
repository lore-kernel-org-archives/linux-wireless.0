Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:52020 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754323AbdFSPiA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Jun 2017 11:38:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: Peter Oh <peter.oh@bowerswilkins.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 05/10] ath10k: htt: High latency TX support
Date: Mon, 19 Jun 2017 15:37:37 +0000
Message-ID: <87efugxa2o.fsf@kamboji.qca.qualcomm.com> (sfid-20170619_173821_684537_B2977F79)
References: <1497279791-9598-1-git-send-email-erik.stromdahl@gmail.com>
        <1497279791-9598-6-git-send-email-erik.stromdahl@gmail.com>
        <f446d226-ca60-7dcb-f62d-00de6ead4cd4@bowerswilkins.com>
        <3b0e54b7-fa0f-3609-e793-f443e05d7595@gmail.com>
In-Reply-To: <3b0e54b7-fa0f-3609-e793-f443e05d7595@gmail.com> (Erik
        Stromdahl's message of "Sat, 17 Jun 2017 19:59:59 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 2017-06-13 19:38, Peter Oh wrote:
>> On 06/12/2017 08:03 AM, Erik Stromdahl wrote:
>>> Add HTT TX function for HL interfaces.
>>> Intended for SDIO and USB.
>>>
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>> ---
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c
>>> b/drivers/net/wireless/ath/ath10k/mac.c
>>> index 48418f9..c5fd803 100644
>>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>>> @@ -3572,7 +3572,10 @@ static int ath10k_mac_tx_submit(struct ath10k *a=
r,
>>>       switch (txpath) {
>>>       case ATH10K_MAC_TX_HTT:
>>> -        ret =3D ath10k_htt_tx(htt, txmode, skb);
>>> +        if (ar->is_high_latency)
>> Can we use function pointers at initial time to avoid condition check at=
 hot path?
>> I'm afraid adding more lines on hot path.
>
> I haven't made any comparison of assembly code between if-paths or
> function pointers, but since most architectures have conditional
> instructions I don't think the penalty is that big (if there is any
> penalty at all). There are plenty of other condition checks in the RX
> path (mac80211 is full of them), so I don't really see this as an
> issue.

Unless we can measure it I wouldn't be that worried either. Without
numbers trying to optimise is hard to get right.

> That being said, any improvement is always welcome (even micro
> optimizations if they are beneficial). I will think about this and see
> if adding function pointers can be done in a nice way.

But are function pointers really that much faster? You have to do a
function call anyway. And maybe use of likely() would be better, we want
to optimise for the low latency case anyway, but I still doubt we could
even measure that.

--=20
Kalle Valo=
