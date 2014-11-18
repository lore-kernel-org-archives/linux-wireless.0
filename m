Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34997 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaKRGqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 01:46:36 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so26720589wgg.36
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 22:46:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vbmdoo9q.fsf@kamboji.qca.qualcomm.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	<1415110931-10945-5-git-send-email-michal.kazior@tieto.com>
	<87ppclq4mu.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=Ws0JGsVBd2J0fe2_JqAhCVpHmNkn10CJx6BCNG-r0cg@mail.gmail.com>
	<87vbmdoo9q.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 18 Nov 2014 07:46:35 +0100
Message-ID: <CA+BoTQm1tzJhz7HtF941z8hrkOpyCpfJhqzmx1tifVFCMo=R1A@mail.gmail.com> (sfid-20141118_074656_314567_47041154)
Subject: Re: [PATCH 4/7] ath10k: unify rx undecapping
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2014 16:11, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>> On 17 November 2014 15:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
[...]
>>> This patch had few checkpatch warnings. I fixed them with the folded
>>> patch and full patch here:
>>>
>>> https://github.com/kvalo/ath/commit/71fbd07d43e54f5f9f442bc5f2f4f9ef83aead63
[...]
>>> @@ -1132,7 +1133,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>>         bool has_fcs_err;
>>>         bool has_crypto_err;
>>>         bool has_tkip_err;
>>> -       bool has_peer_idx_invalid;
>>> +       bool has_idx_invalid;
>>>         bool is_decrypted;
>>
>> I don't really like the has_idx_invalid. Perhaps has_peer_err conveys
>> a bit more of the original meaning?
>
> What about just peer_idx_invalid? IMHO we really don't need the has_
> prefix in that relatively small function.

Good point but the assignment line with `peer_idx_invalid` will still
be over 80 chars long, no?

So perhaps instead of doing `rxd->attention.flags &
__cpu_to_le32(FLAG)` it could be `attention =
__le32_to_cpu(rxd->attention.flags)` and then `attention & FLAG` ?
This way it shouldn't exceed the 80 char limit and var names won't
need to be changed. Hopefully compiler will optimize it away.


Michał
