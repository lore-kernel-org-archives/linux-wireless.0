Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38572 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab1ERL0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 07:26:24 -0400
Received: by qwk3 with SMTP id 3so736478qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 04:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD3A1CD.3040304@broadcom.com>
References: <1305716294-5753-1-git-send-email-zajec5@gmail.com>
	<4DD3A1CD.3040304@broadcom.com>
Date: Wed, 18 May 2011 13:26:23 +0200
Message-ID: <BANLkTinW=kfg2ONuA5NzmNbSAHUbUVOiRg@mail.gmail.com> (sfid-20110518_132628_382088_924431A5)
Subject: Re: [PATCH] bcma: pci: implement enabling interrupts
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 maja 2011 12:39 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 05/18/2011 12:58 PM, Rafał Miłecki wrote:
>>
>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>> ---
>>  drivers/bcma/driver_pci.c |   18 ++++++++++++++++++
>>  1 files changed, 18 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
>> index e757e4e..879fe1d 100644
>> --- a/drivers/bcma/driver_pci.c
>> +++ b/drivers/bcma/driver_pci.c
>> @@ -161,3 +161,21 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
>>  {
>>        bcma_pcicore_serdes_workaround(pc);
>>  }
>> +
>> +int bcma_core_pci_irq_enable(struct bcma_drv_pci *pc, struct bcma_device
>> *core)
>> +{
>> +       struct pci_dev *pdev = pc->core->bus->host_pci;
>> +       u32 coremask, tmp;
>> +       int err;
>> +
>> +       coremask = BIT(core->core_index);
>> +
>> +       err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK,&tmp);
>> +       if (err)
>> +               goto out;
>> +       tmp |= coremask<<  8;
>> +       err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
>> +
>> +out:
>> +       return err;
>> +}
>
> Hi Rafał,
>
> Do you intend to have a disable as well?

Sure. I just didn't test disabling function yet, that's why I didn't publish it.

-- 
Rafał
