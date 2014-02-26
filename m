Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:3576 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaBZRaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 12:30:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: improve rx path when play with attention flags
References: <1393312414-9404-1-git-send-email-janusz.dziedzic@tieto.com>
	<CA+BoTQkgFVgWGJTTLOJ2tiqqaJ=0O7JvGAMDWc8JHt0rJP92UA@mail.gmail.com>
Date: Wed, 26 Feb 2014 19:29:57 +0200
In-Reply-To: <CA+BoTQkgFVgWGJTTLOJ2tiqqaJ=0O7JvGAMDWc8JHt0rJP92UA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 25 Feb 2014 08:24:49 +0100")
Message-ID: <871typlr3e.fsf@kamboji.qca.qualcomm.com> (sfid-20140226_183024_517324_C03A01FA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 25 February 2014 08:13, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
>> Currently when we check attention flags we do __le32_to_cpu()
>> four times for each packet. This could have performance
>> impact for BIG endian platforms. This patch improve this
>> little bit.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

[...]

>> @@ -929,6 +873,9 @@ static void ath10k_htt_rx_handler(struct ath10k_htt *htt,
>>                         struct sk_buff *msdu_head, *msdu_tail;
>>                         enum htt_rx_mpdu_status status;
>>                         int msdu_chaining;
>> +                       struct htt_rx_desc *rxd;
>> +                       u32 att_flags;
>> +
>
> No need for an empty line I suppose? I would also prefer `attention`
> instead of `att_flags`, but no big deal.

Yeah, attention is better.

And also the variable declarations should be in the beginning of
function. Apparently I have been sloppy missed that here.

-- 
Kalle Valo
