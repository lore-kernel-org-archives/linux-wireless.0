Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41097 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1ERWa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 18:30:58 -0400
Received: by qwk3 with SMTP id 3so1069546qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 15:30:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD3AE1D.8000109@broadcom.com>
References: <1305716294-5753-1-git-send-email-zajec5@gmail.com>
	<4DD3A1CD.3040304@broadcom.com>
	<BANLkTinW=kfg2ONuA5NzmNbSAHUbUVOiRg@mail.gmail.com>
	<4DD3AE1D.8000109@broadcom.com>
Date: Thu, 19 May 2011 00:30:57 +0200
Message-ID: <BANLkTimyddd9G3bSbQNbENg+Mea43C3TTQ@mail.gmail.com> (sfid-20110519_003101_503439_63419ECC)
Subject: Re: [PATCH] bcma: pci: implement enabling interrupts
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 maja 2011 13:31 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 05/18/2011 01:26 PM, Rafał Miłecki wrote:
>>
>> W dniu 18 maja 2011 12:39 użytkownik Arend van Spriel
>> <arend@broadcom.com>  napisał:
>>>
>>> On 05/18/2011 12:58 PM, Rafał Miłecki wrote:
>>>>
>>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>>> ---
>>>>  drivers/bcma/driver_pci.c |   18 ++++++++++++++++++
>>>>  1 files changed, 18 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
>>>> index e757e4e..879fe1d 100644
>>>> --- a/drivers/bcma/driver_pci.c
>>>> +++ b/drivers/bcma/driver_pci.c
>>>> @@ -161,3 +161,21 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
>>>>  {
>>>>        bcma_pcicore_serdes_workaround(pc);
>>>>  }
>>>> +
>>>> +int bcma_core_pci_irq_enable(struct bcma_drv_pci *pc, struct
>>>> bcma_device
>>>> *core)
>>>> +{
>>>> +       struct pci_dev *pdev = pc->core->bus->host_pci;
>>>> +       u32 coremask, tmp;
>>>> +       int err;
>>>> +
>>>> +       coremask = BIT(core->core_index);
>>>> +
>>>> +       err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK,&tmp);
>>>> +       if (err)
>>>> +               goto out;
>>>> +       tmp |= coremask<<    8;
>>>> +       err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
>>>> +
>>>> +out:
>>>> +       return err;
>>>> +}
>>>
>>> Hi Rafał,
>>>
>>> Do you intend to have a disable as well?
>>
>> Sure. I just didn't test disabling function yet, that's why I didn't
>> publish it.
>
> Thanks,
>
> I was just wondering whether there would be a yang for this yin ;-)

Actually, we could use the same function to enable and disable
interrupts. Only one additional argument and one condition is needed.

John: can you drop this patch? In case one function will not be an
option, I'll just resend it.

-- 
Rafał
