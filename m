Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34274 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJWNTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 09:19:05 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so1086459wgh.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 06:19:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871tpzq67b.fsf@kamboji.qca.qualcomm.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
	<1413807282-27951-5-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQ=P2XOaOsaVOj+=fEs=nGfhUCNQvDYx6qb=A=JRCnbQmg@mail.gmail.com>
	<871tpzq67b.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 23 Oct 2014 15:19:03 +0200
Message-ID: <CA+BoTQmSRCMM9S9UrdKvMRxc4qGMGRNvmZQ5kJ7k6rGAtymPqQ@mail.gmail.com> (sfid-20141023_151910_598533_E29C0130)
Subject: Re: [PATCH v2 4/6] ath10k: make warm reset a bit safer and faster
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 October 2014 15:14, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 20 October 2014 14:14, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> One of the problems with warm reset I've found is
>>> that it must be guaranteed that copy engine
>>> registers are not being accessed while being
>>> reset. Otherwise in worst case scenario the host
>>> may lock up.
>>>
>>> Instead of using sleeps and hoping the device is
>>> operational in some arbitrary timeframes use
>>> firmware indication register.
>>>
>>> As a side effect this makes driver
>>> boot/stop/recovery faster.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>> ---
>>>
>>> Notes:
>>>     v2:
>>>      * fix kernel panic on early fw crash due to CE not being fully initialized [Janusz]
>>
>> Marek reported he sees a memory leak and git bisect blames this patch.
>> Please don't apply this patch yet.
>
> Ok, thanks for letting me know. What about rest of the patches in the
> patchset? I assume it's safe to apply them.

It's safe to apply:

  ath10k: re-disable interrupts after target init
  ath10k: mask/unmask msi fw irq
  ath10k: split ce pipe init/alloc further

Please, do not apply the following yet:
  ath10k: make warm reset a bit safer and faster (this patch)
  ath10k: split reset logic from power up
  ath10k: don't reset chip on power_down


Michał
