Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37452 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbcEFQRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 12:17:45 -0400
Received: by mail-wm0-f52.google.com with SMTP id a17so85896527wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2016 09:17:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lh3ns8q5.fsf@kamboji.qca.qualcomm.com>
References: <1462390228-27863-1-git-send-email-csd@broadcom.com>
	<87lh3ns8q5.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 6 May 2016 09:17:43 -0700
Message-ID: <CAHCK0=OFL-kJqk-h++LSgr6rKz7W=bMNCgJOqQbCgnoJ9XqSFw@mail.gmail.com> (sfid-20160506_181749_631135_0E1F4E57)
Subject: Re: [PATCH] Fix kernel oops in failed chip_attach
From: Christian Daudt <csd@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 6, 2016 at 4:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Christian Daudt <csd@broadcom.com> writes:
>
>> When chip attach fails, brcmf_sdiod_intr_unregister is being called
>> but that is too early as sdiodev->settings has not been set yet
>> nor has brcmf_sdiod_intr_register been called.
>> Change to use oob_irq_requested + newly created sd_irq_requested
>> to decide on what to unregister at intr_unregister time.
>>
>> Steps to reproduce problem:
>> - modprobe brcmfmac using buggy FW
>> - rmmod brcmfmac
>> - modprobe brcmfmac again.
>>
>> If done with a buggy firmware, brcm_chip_attach will fail on the
>> 2nd modprobe triggering the call to intr_unregister and the
>> kernel oops when attempting to de-reference sdiodev->settings->bus.sdio
>> which has not yet been set.
>>
>> Signed-off-by: Christian Daudt <csd@broadcom.com>
>
> Please use prefix "brcmfmac: " in the title.
>
I'll resubmit with that mod after getting round 1 feedback. I was a
bit rusty on patch submissions and forgot about that part on the first
one.
 Thanks,
   csd
