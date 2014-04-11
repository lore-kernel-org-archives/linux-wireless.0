Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61357 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaDKH64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2014 03:58:56 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so4995503wgh.31
        for <linux-wireless@vger.kernel.org>; Fri, 11 Apr 2014 00:58:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=gUBsw43M2at0y7iZU3VhwdjH9EBqzdOmKpxLjjqusPw@mail.gmail.com>
References: <53461A8A.4030209@candelatech.com>
	<1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
	<8738hkh193.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=gUBsw43M2at0y7iZU3VhwdjH9EBqzdOmKpxLjjqusPw@mail.gmail.com>
Date: Fri, 11 Apr 2014 09:58:54 +0200
Message-ID: <CA+BoTQ=L7Cj5V04RGEFcdGm1rxEO8NOYMEhSRiQNdoBoMTm5Pg@mail.gmail.com> (sfid-20140411_095931_815076_39F4F962)
Subject: Re: [PATCH] ath10k: double check bmi xfer pointers
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 April 2014 07:47, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 11 April 2014 07:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> If for some reason copy engine ring buffer became
>>> corrupt ath10k could crash the machine due to
>>> invalid pointer dereference. It's very unlikely
>>> but devices can never be fully trusted so verify
>>> if the bmi xfer pointer read back from copy engine
>>> matches the original pointer.
>>
>> The big question is why does this happen? Does this happen only with
>> Ben's firmware or is it a more generic problem?
>
> I'll look more into this.

Hmm.. After going through the code a few times I think the bug is
actually something else.

If the crash happened in complete() it means the completion structure
wasn't set up properly. However it is always initialized in
ath10k_pci_hif_exchange_bmi_msg() before proceeding. This means xfer
pointer read back from ath10k_ce_completed_send_next() or
ath10k_ce_completed_recv_next() is wrong. Since the pointer to it is
kept on host getting wrong xfer means sw_index must be wrong. If I
assume indexes are managed correctly (i.e. no overflows, locking is
fine) then it is the entry the sw_index points to that is actually
unexpected.

This could happen if concurrent transfers occur on pipe 0 or 1 (used
for bmi communication) during device bootup. This could be either a
concurrent bmi transfer or a non-bmi buffer or an old bmi xfer data.
The latter shouldn't be the case because
ath10k_pci_hif_exchange_bmi_msg() cleans up after itself. Concurrent
access doesn't seem to be the case either.

I conclude the bug is not present in the vanilla ath10k code.

TL;DR drop the patch, please


Michał
