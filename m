Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21146 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaKQPLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 10:11:35 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath10k: unify rx undecapping
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	<1415110931-10945-5-git-send-email-michal.kazior@tieto.com>
	<87ppclq4mu.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=Ws0JGsVBd2J0fe2_JqAhCVpHmNkn10CJx6BCNG-r0cg@mail.gmail.com>
Date: Mon, 17 Nov 2014 17:11:29 +0200
In-Reply-To: <CA+BoTQ=Ws0JGsVBd2J0fe2_JqAhCVpHmNkn10CJx6BCNG-r0cg@mail.gmail.com>
	(Michal Kazior's message of "Mon, 17 Nov 2014 15:54:23 +0100")
Message-ID: <87vbmdoo9q.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_161138_562848_39B4C18B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 17 November 2014 15:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> This creates a single, common path for MSDU,
>>> A-MSDU and fragmented Rx.
>>>
>>> Hopefully this will make it easier to understand
>>> Rx path and make it easier to work with.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> This patch had few checkpatch warnings. I fixed them with the folded
>> patch and full patch here:
>>
>> https://github.com/kvalo/ath/commit/71fbd07d43e54f5f9f442bc5f2f4f9ef83aead63
>
> Thanks!
>
> [...]
>> @@ -1132,7 +1133,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>>         bool has_fcs_err;
>>         bool has_crypto_err;
>>         bool has_tkip_err;
>> -       bool has_peer_idx_invalid;
>> +       bool has_idx_invalid;
>>         bool is_decrypted;
>
> I don't really like the has_idx_invalid. Perhaps has_peer_err conveys
> a bit more of the original meaning?

What about just peer_idx_invalid? IMHO we really don't need the has_
prefix in that relatively small function.

> As much as I'd like to leave the original var name I'd like to be
> checkpatch warning free. Sigh..

Same here. The checkpatch is just so useful tool to keep the style
unified.

-- 
Kalle Valo
