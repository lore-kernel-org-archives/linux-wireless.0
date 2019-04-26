Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE38AC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE0B5206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8swHKY+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RtINaDOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbfDZHHJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:07:09 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfDZHHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 03:07:09 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C9A160736; Fri, 26 Apr 2019 07:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556262428;
        bh=24kT1HnRZjrCbMcgQA4CP+mbQo8uvplZg4zehp6YyBU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g8swHKY+LBKS5B4yD29KAg3i8Zu0GJOm5o5IaxbD3tBLQYCnZcG4WgGnZxsogrB58
         YKa7PO8oRYlYIOunFgGIw8+KMPyiFmAPu4O6IF0oP/rZSHzAlW23T53Z5GQfCPNHvC
         6Vw9ZhKGxVXCkiSAX3+gjUTr1x8bDBqS6rEsE96U=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 332176053B;
        Fri, 26 Apr 2019 07:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556262427;
        bh=24kT1HnRZjrCbMcgQA4CP+mbQo8uvplZg4zehp6YyBU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RtINaDOd40ILPnT6/GX8bxtvtnwfxJL/PI0JkiP4IbmiCXvv4P0epORT/xaiB1H9i
         WEvQpDtaHWabrNQTUqSZ+opzOqQRbaSedZeeywiO+gkYShwOGXnVTuFkT3yM1HTaF+
         ftPmemLH8qY/dQIXoxrg3+VfYKCcbWFGuukKH/R0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 332176053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Erik Stromdahl <erik.stromdahl@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        yiboz@codeaurora.org
Subject: Re: [PATCH] ath10k: remove iteration in wake_tx_queue
References: <20190327162906.6010-1-erik.stromdahl@gmail.com>
        <87bm1qq92j.fsf@toke.dk>
        <8772dfe6-3f52-05ca-f55a-b7eae14fa7ac@gmail.com>
        <87imvdu5u8.fsf@toke.dk>
        <f915fa20-a4e1-7312-dea2-d60b716e4877@gmail.com>
Date:   Fri, 26 Apr 2019 10:07:03 +0300
In-Reply-To: <f915fa20-a4e1-7312-dea2-d60b716e4877@gmail.com> (Erik
        Stromdahl's message of "Wed, 17 Apr 2019 15:29:41 +0200")
Message-ID: <87sgu5utwo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> On 4/16/19 9:07 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>
>>> On 4/1/19 1:05 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>>>
>>>>> Iterating the TX queue and thereby dequeuing all available packets in=
 the
>>>>> queue could result in performance penalties on some SMP systems.
>>>>>
>>>>> The reason for this is most likely that the per-ac lock (active_txq_l=
ock)
>>>>> in mac80211 will be held by the CPU iterating the current queue.
>>>>>
>>>>> This will lock up other CPUs trying to push new messages on the TX
>>>>> queue.
>>>>>
>>>>> Instead of iterating the queue we fetch just one packet at the time,
>>>>> resulting in minimal starvation of the other CPUs.
>>>>
>>>> Did you test this with Felix' patches reducing the time the lock is he=
ld
>>>> in mac80211?
>>>>
>>>> -Toke
>>>>
>>> Hi Toke,
>>>
>>> I am not aware of these patches. Can you please point them out for me?
>>
>> They've already been merged. Commits dcec1d9bc8a7 and 7ef769459f14 in
>> mac80211-next :)
>>
>> -Toke
>>
>
> I see. I am using the ath tree and I couldn't find them there.
> I can cherry-pick them to my own tree and try them out
> (or wait until Kalle updates ath.git).

It will take a while before these commits trickle down to ath-next
branch, most likely after v5.2-rc1 is released.

--=20
Kalle Valo
