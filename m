Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:46850 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412AbbBHOMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 09:12:31 -0500
Message-ID: <54D76ECD.9080904@hauke-m.de> (sfid-20150208_151237_120791_15C8B7E0)
Date: Sun, 08 Feb 2015 15:12:29 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 3/4] bcma: support bringing up bus hosted on PCIe Gen
 2
References: <1422638566-7593-1-git-send-email-zajec5@gmail.com>	<1422638566-7593-3-git-send-email-zajec5@gmail.com>	<54CBE299.4070709@hauke-m.de>	<CACna6rwarKekDeR6YL73HcErmu1WGENcN7wVq0gMUEyHq0HekA@mail.gmail.com> <87mw4rplyl.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87mw4rplyl.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2015 07:56 AM, Kalle Valo wrote:
> Rafał Miłecki <zajec5@gmail.com> writes:
> 
>>>> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2)
>>>> +{
>>>> +     struct bcma_bus *bus = pcie2->core->bus;
>>>> +     struct pci_dev *dev = bus->host_pci;
>>>> +
>>>> +     pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
>>>> +                                        PCI_EXP_DEVCTL_READRQ,
>>>> +                                        pcie2->reqsize);
>>>
>>> Use pcie_set_readrq() if it is needed.
>>
>> What do you mean by "if needed"? Is there anything wrong?
> 
> So what's the conclusion? Can I apply these?
> 
Ah sorry,

The "if needed" referenced the comment above about if setting this is
needed at all, or if this should be done by the driver for the (broken?)
PCIe controller.

pcie_set_readrq() does the setting of this register in the Linux kernel
and does some additional checks, I would suggest using this function
instead of setting this register by yourself.

Hauke
