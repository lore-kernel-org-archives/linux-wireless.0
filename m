Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65021 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0LULuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 06:50:54 -0500
Received: by qwa26 with SMTP id 26so3881414qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Dec 2010 03:50:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D105A51.9070702@gmail.com>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
	<1292893316-26694-5-git-send-email-hauke@hauke-m.de>
	<4D105A51.9070702@gmail.com>
Date: Tue, 21 Dec 2010 12:50:53 +0100
Message-ID: <AANLkTin77zgbHJtkxL4bLMO_OdutAzQFnnT-6DwxiOXg@mail.gmail.com>
Subject: Re: [PATCH 4/7] rt2x00: Use pci_is_pcie()
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 12/21/10 02:01, Hauke Mehrtens wrote:
>> Use function pci_is_pcie() instead of accessing struct member directly.
>>
>> CC: Ivo van Doorn <IvDoorn@gmail.com>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>> ---
>>  drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
>> index 28e6ff1..73631c6 100644
>> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
>> @@ -286,7 +286,7 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>>       rt2x00dev->irq = pci_dev->irq;
>>       rt2x00dev->name = pci_name(pci_dev);
>>
>> -     if (pci_dev->is_pcie)
>> +     if (pci_is_pcie(pci_dev))
>>               rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCIE);
>>       else
>>               rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
