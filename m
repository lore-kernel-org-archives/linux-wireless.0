Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37391 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbcEFQ3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2016 12:29:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Christian Daudt <csd@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH] Fix kernel oops in failed chip_attach
References: <1462390228-27863-1-git-send-email-csd@broadcom.com>
	<87lh3ns8q5.fsf@kamboji.qca.qualcomm.com>
	<CAHCK0=OFL-kJqk-h++LSgr6rKz7W=bMNCgJOqQbCgnoJ9XqSFw@mail.gmail.com>
Date: Fri, 06 May 2016 19:29:10 +0300
In-Reply-To: <CAHCK0=OFL-kJqk-h++LSgr6rKz7W=bMNCgJOqQbCgnoJ9XqSFw@mail.gmail.com>
	(Christian Daudt's message of "Fri, 6 May 2016 09:17:43 -0700")
Message-ID: <87r3dfnoa1.fsf@kamboji.qca.qualcomm.com> (sfid-20160506_182918_907801_BD434231)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Daudt <csd@broadcom.com> writes:

> On Fri, May 6, 2016 at 4:53 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Christian Daudt <csd@broadcom.com> writes:
>>
>>> When chip attach fails, brcmf_sdiod_intr_unregister is being called
>>> but that is too early as sdiodev->settings has not been set yet
>>> nor has brcmf_sdiod_intr_register been called.
>>> Change to use oob_irq_requested + newly created sd_irq_requested
>>> to decide on what to unregister at intr_unregister time.
>>>
>>> Steps to reproduce problem:
>>> - modprobe brcmfmac using buggy FW
>>> - rmmod brcmfmac
>>> - modprobe brcmfmac again.
>>>
>>> If done with a buggy firmware, brcm_chip_attach will fail on the
>>> 2nd modprobe triggering the call to intr_unregister and the
>>> kernel oops when attempting to de-reference sdiodev->settings->bus.sdio
>>> which has not yet been set.
>>>
>>> Signed-off-by: Christian Daudt <csd@broadcom.com>
>>
>> Please use prefix "brcmfmac: " in the title.
>>
> I'll resubmit with that mod after getting round 1 feedback. I was a
> bit rusty on patch submissions and forgot about that part on the first
> one.

No worries, that's why we do review :)

-- 
Kalle Valo
