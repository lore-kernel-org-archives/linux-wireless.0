Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33601 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEZFhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 01:37:15 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so3128029wgh.31
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 22:37:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fvjytht6.fsf@kamboji.qca.qualcomm.com>
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
	<1400158139-13836-3-git-send-email-michal.kazior@tieto.com>
	<87fvjytht6.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 26 May 2014 07:37:13 +0200
Message-ID: <CA+BoTQkfZbzy62xZV0tcPw1xu8B-rioVVags3z+DJMGxMB-jFQ@mail.gmail.com> (sfid-20140526_073722_042740_9FA013B7)
Subject: Re: [PATCH 2/3] ath10k: revert incomplete scatter-gather pci tx
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 May 2014 09:53, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This prevents leaving incomplete scatter-gather
>> transfer on CE rings which can lead firmware to
>> crash.
>>
>> Reported-By: Avery Pennarun <apenwarr@gmail.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> The title is a bit misleading as usually the commit log with the word
> revert means that the commit is reverting another git commit. Maybe
> something like this is better:
>
> ath10k: drop incomplete scatter-gather pci tx transfers

Good point. I was actually thinking 'abort' .. 'properly'.


>> +     if (WARN_ON(src_ring->write_index == src_ring->sw_index))
>> +             return;
>> +
>> +     if (WARN_ON(src_ring->write_index ==
>> +                 ath10k_ce_src_ring_write_index_get(ar, ctrl_addr)))
>> +             return;
>
> WARN_ON() on data path is dangerous. WARN_ON_ONCE() or ath10k_warn() is
> better.

Good point!


>> +err:
>> +     for (; i > 0; i--)
>
> Isn't this just a fancy way to say 'while (i-- > 0)'?

Not really. More like do { .. } while (--i > 0), no? First iteration
must use unmodified `i`.


Michał
