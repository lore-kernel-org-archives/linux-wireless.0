Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59813 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab1GFDPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 23:15:48 -0400
Received: by ewy4 with SMTP id 4so2226998ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 20:15:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=-43qKpbb6HdYuNTna__5cxVMfoA@mail.gmail.com>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
	<4E0CDF8B.3020505@emulex.com>
	<294849c5-16f3-491b-98c2-2a96275e8378@exht1.ad.emulex.com>
	<BANLkTi=-43qKpbb6HdYuNTna__5cxVMfoA@mail.gmail.com>
Date: Tue, 5 Jul 2011 22:15:45 -0500
Message-ID: <CAPoiz9w9ju4o-nKHh2iEKZ-6BD2DTV9j8f2xjubRJXeX9LYzbg@mail.gmail.com> (sfid-20110706_051551_482969_4EC2263F)
Subject: Re: Warning: iwlegacy/iwlwifi/rtlwifi : removal of PCI_CAP_ID_EXP
From: Jon Mason <jdmason@kudzu.us>
To: James Smart <james.smart@emulex.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Richard Lary <rlary@us.ibm.com>, wey-yi.w.guy@intel.com,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per Richard Lary's testing, this is not an issue with the latest kernel.
http://www.spinics.net/lists/linux-pci/msg11350.html

Thanks,
Jon

On Fri, Jul 1, 2011 at 10:08 AM, Jon Mason <jdmason@kudzu.us> wrote:
> pci_is_pcie checks for a PCI-E capability offset that was determined
> by calling pci_find_capability during the PCI bus walking.  Based on
> your description above this should be functionally equivalent.  If
> this is not safe, then the PCI bus walking code is most likely busted
> on EEH enabled PPC systems (and that is a BIG problem).
>
> Thanks,
> Jon
>
> On Fri, Jul 1, 2011 at 9:49 AM, James Smart <james.smart@emulex.com> wrote:
>> All,
>>
>> I wanted to communicate a potential warning to those drivers that had a
>> patch submitted to replace config space searches of PCI_CAP_ID_EXP with
>> shorthand options such as is_pcie and pci_is_pcie().
>>
>> Testing with the lpfc driver and AER/EEH identified cases where the
>> short-hand search options would fail on PPC platforms.  The only successful
>> option in all cases was the explicit search via PCI_CAP_ID_EXP.   Therefore,
>> I recommend that this change not be accepted until the platform level issue
>> can be identified and corrected.
>>
>> -- james s
>>
>>
>>
>> On 6/30/2011 4:41 PM, James Smart wrote:
>>>
>>> Jon,
>>>
>>> I must NACK this patch to the lpfc driver and recommend that all other
>>> patches
>>> which replace pci_find_capability(pdef, PCI_CAP_ID_EXP) with
>>> "pci_is_pcie(pdev)" are NACK'd as well.
>>>
>>> The reason is due to an issue on PPC platforms whereby use of
>>> "pdev->is_pcie"
>>> and pci_is_pcie() will erroneously fail under some conditions, but
>>> explicit
>>> search for the capability struct via pci_find_capability() is always
>>> successful.   I expect this to be due a shadowing of pci config space in
>>> the
>>> hal/platform that isn't sufficiently built up.  We detected this issue
>>> while
>>> testing AER/EEH, and are functional only if the pci_find_capability()
>>> option
>>> is used.
>>>
>>> -- james s
>>>
>>>
>>>
>>> On 6/27/2011 1:39 PM, Jon Mason wrote:
>>>>
>>>> The PCIE capability offset is saved during PCI bus walking.  It will
>>>> remove an unnecessary search in the PCI configuration space if this
>>>> value is referenced instead of reacquiring it.  Also, pci_is_pcie is a
>>>> better way of determining if the device is PCIE or not (as it uses the
>>>> same saved PCIE capability offset).
>>>>
>>>> Signed-off-by: Jon Mason<jdmason@kudzu.us>
>>>> ---
>>>>   drivers/scsi/lpfc/lpfc_init.c |    2 +-
>>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/lpfc/lpfc_init.c
>>>> b/drivers/scsi/lpfc/lpfc_init.c
>>>> index 148b98d..9000ad0 100644
>>>> --- a/drivers/scsi/lpfc/lpfc_init.c
>>>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>>>> @@ -3970,7 +3970,7 @@ lpfc_enable_pci_dev(struct lpfc_hba *phba)
>>>>        pci_save_state(pdev);
>>>>
>>>>        /* PCIe EEH recovery on powerpc platforms needs fundamental reset
>>>> */
>>>> -       if (pci_find_capability(pdev, PCI_CAP_ID_EXP))
>>>> +       if (pci_is_pcie(pdev))
>>>>                pdev->needs_freset = 1;
>>>>
>>>>        return 0;
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
