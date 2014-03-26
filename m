Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:7019 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaCZLKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 07:10:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/8] ath10k: cleanup ath10k_pci_wait_for_target_init()
References: <20140325091311.16651.15747.stgit@potku.adurom.net>
	<20140325091505.16651.15554.stgit@potku.adurom.net>
	<CA+BoTQns9QXCctzrMzd5=o6EyA=d0TG-eLJw3hztE1-MD7HwkQ@mail.gmail.com>
	<87lhvxz4up.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=N_L53c2Pgw3RQYcJx4-xp9fSOYvbeEUHgFCtSoP3QRA@mail.gmail.com>
Date: Wed, 26 Mar 2014 13:10:11 +0200
In-Reply-To: <CA+BoTQ=N_L53c2Pgw3RQYcJx4-xp9fSOYvbeEUHgFCtSoP3QRA@mail.gmail.com>
	(Michal Kazior's message of "Wed, 26 Mar 2014 10:52:59 +0100")
Message-ID: <87ha6lz04s.fsf@kamboji.qca.qualcomm.com> (sfid-20140326_121022_653119_46149213)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 March 2014 10:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>
> [...]
>
>>>> -       while (wait_limit-- &&
>>>> -              !(ioread32(ar_pci->mem + FW_INDICATOR_ADDRESS) &
>>>> -                FW_IND_INITIALIZED)) {
>>>> +       timeout = jiffies + msecs_to_jiffies(wait);
>>>> +
>>>> +       do {
>>>> +               val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
>>>> +               if (val == FW_IND_INITIALIZED)
>>>> +                       break;
>
> Ah, for some reason I've missed this earlier. You seem to replace &
> with ==. I wonder if that's okay?

No, it's not. Good catch, I'll change it back to '&'.

> FW indicator may contain FW_IND_EVENT_PENDING (i.e. firmware crashed
> bit) too.

I'm guessing that FW_IND_INITIALIZED should be the only bit set if
initialisation has happened correctly, but we cannot be certain (right
now). Hence I'll change it back to '&'.

> It might be a good idea to check for that too and return a different
> errno?

Maybe. But to keep this patch simple, I don't add that right now. We can
create a new patch for that.

>>> It might be worth to add:
>>>
>>>  if (val == 0xFFFFFFFF)
>>>    return -EIO;
>>
>> What does receiving 0xFFFFFFFF mean here? PCI bus kaput?
>
> A simple grepping (find drivers/net/ethernet/ -type f -name '*.[ch]' |
> xargs grep -nC5 ioread32 | grep -C5 -i 0xffffffff) turns out results
> like this:
>
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-200-  }
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-201-
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-202-  /* Use current
> fetch_index as the ring starting point */
>  drivers/net/ethernet/cisco/enic/vnic_rq.c:203:  fetch_index =
> ioread32(&rq->ctrl->fetch_index);
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-204-
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-205-  if (fetch_index ==
> 0xFFFFFFFF) { /* check for hardware gone  */
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-206-          /* Hardware
> surprise removal: reset fetch_index */
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-207-          fetch_index = 0;
>  drivers/net/ethernet/cisco/enic/vnic_rq.c-208-  }
>
>
>> Do we really want to stop trying after receiving that? What harm would
>> it cause to keep on trying? We would return an error anyway after the
>> timeout, right?
>
> Yes. It's harmless but having the check allows to discern a real
> timeout (target doesn't wake up for some reason) and a pci-e link
> issue.

Ok, I'll add the test you suggested.

-- 
Kalle Valo
