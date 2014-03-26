Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:54746 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCZJxA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 05:53:00 -0400
Received: by mail-we0-f174.google.com with SMTP id t60so937014wes.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 02:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87lhvxz4up.fsf@kamboji.qca.qualcomm.com>
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
	<20140325091505.16651.15554.stgit@potku.adurom.net>
	<CA+BoTQns9QXCctzrMzd5=o6EyA=d0TG-eLJw3hztE1-MD7HwkQ@mail.gmail.com>
	<87lhvxz4up.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 26 Mar 2014 10:52:59 +0100
Message-ID: <CA+BoTQ=N_L53c2Pgw3RQYcJx4-xp9fSOYvbeEUHgFCtSoP3QRA@mail.gmail.com> (sfid-20140326_105305_561267_12AAA8D1)
Subject: Re: [PATCH 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2014 10:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:

[...]

>>> -       while (wait_limit-- &&
>>> -              !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &
>>> -                FW_IND_INITIALIZED)) {
>>> +       timeout = jiffies + msecs_to_jiffies(wait);
>>> +
>>> +       do {
>>> +               val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
>>> +               if (val == FW_IND_INITIALIZED)
>>> +                       break;

Ah, for some reason I've missed this earlier. You seem to replace &
with ==. I wonder if that's okay?

FW indicator may contain FW_IND_EVENT_PENDING (i.e. firmware crashed
bit) too. It might be a good idea to check for that too and return a
different errno?


>>> +
>>
>> It might be worth to add:
>>
>>  if (val == 0xFFFFFFFF)
>>    return -EIO;
>
> What does receiving 0xFFFFFFFF mean here? PCI bus kaput?

A simple grepping (find drivers/net/ethernet/ -type f -name '*.[ch]' |
xargs grep -nC5 ioread32 | grep -C5 -i 0xffffffff) turns out results
like this:

 drivers/net/ethernet/cisco/enic/vnic_rq.c-200-  }
 drivers/net/ethernet/cisco/enic/vnic_rq.c-201-
 drivers/net/ethernet/cisco/enic/vnic_rq.c-202-  /* Use current
fetch_index as the ring starting point */
 drivers/net/ethernet/cisco/enic/vnic_rq.c:203:  fetch_index =
ioread32(&rq->ctrl->fetch_index);
 drivers/net/ethernet/cisco/enic/vnic_rq.c-204-
 drivers/net/ethernet/cisco/enic/vnic_rq.c-205-  if (fetch_index ==
0xFFFFFFFF) { /* check for hardware gone  */
 drivers/net/ethernet/cisco/enic/vnic_rq.c-206-          /* Hardware
surprise removal: reset fetch_index */
 drivers/net/ethernet/cisco/enic/vnic_rq.c-207-          fetch_index = 0;
 drivers/net/ethernet/cisco/enic/vnic_rq.c-208-  }


> Do we really want to stop trying after receiving that? What harm would
> it cause to keep on trying? We would return an error anyway after the
> timeout, right?

Yes. It's harmless but having the check allows to discern a real
timeout (target doesn't wake up for some reason) and a pci-e link
issue.


Michał
