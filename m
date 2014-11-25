Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41235 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaKYJYb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 04:24:31 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't drop corrupted mgmt frames
References: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
	<87egsr1wj7.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnk+40Pxkxfcu47Z-3j=8h2iMP8tKqXKf2GhAY3WkQxCw@mail.gmail.com>
Date: Tue, 25 Nov 2014 11:24:26 +0200
In-Reply-To: <CA+BoTQnk+40Pxkxfcu47Z-3j=8h2iMP8tKqXKf2GhAY3WkQxCw@mail.gmail.com>
	(Michal Kazior's message of "Tue, 25 Nov 2014 10:22:04 +0100")
Message-ID: <871tor1vlh.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_102439_328363_410388A0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 25 November 2014 at 10:04, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
> [...]
>>> @@ -1394,12 +1396,19 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
>>>               return false;
>>>       }
>>>
>>> +     is_mgmt = !!(rxd->attention.flags &
>>> +                  __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE));
>>> +     has_fcs_err = !!(rxd->attention.flags &
>>> +                      __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));
>>
>> I think I asked this before in some other patch, but isn't '!!' operator
>> useless here? is_mgmt is a boolean so the compiler should convert it
>> correctly without '!!' anyway, right?
>
> If I remove `!!` I get:
>
>  warning: incorrect type in assignment (different base types)
>     expected bool [unsigned] [usertype] is_mgmt
>     got restricted __le32

Oh. Sorry, my bad.

> I could do a temporary `u32 attention` to get rid of the `!!`. You
> want me to update it?

Please don't, this is fine.

-- 
Kalle Valo
