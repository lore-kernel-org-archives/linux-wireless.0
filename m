Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:38741 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbBFG40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 01:56:26 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH 3/4] bcma: support bringing up bus hosted on PCIe Gen 2
References: <1422638566-7593-1-git-send-email-zajec5@gmail.com>
	<1422638566-7593-3-git-send-email-zajec5@gmail.com>
	<54CBE299.4070709@hauke-m.de>
	<CACna6rwarKekDeR6YL73HcErmu1WGENcN7wVq0gMUEyHq0HekA@mail.gmail.com>
Date: Fri, 06 Feb 2015 08:56:18 +0200
In-Reply-To: <CACna6rwarKekDeR6YL73HcErmu1WGENcN7wVq0gMUEyHq0HekA@mail.gmail.com>
	(=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Sat, 31 Jan 2015
 00:08:50 +0100")
Message-ID: <87mw4rplyl.fsf@kamboji.qca.qualcomm.com> (sfid-20150206_075629_858893_5A73F860)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

>>> +void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2)
>>> +{
>>> +     struct bcma_bus *bus = pcie2->core->bus;
>>> +     struct pci_dev *dev = bus->host_pci;
>>> +
>>> +     pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
>>> +                                        PCI_EXP_DEVCTL_READRQ,
>>> +                                        pcie2->reqsize);
>>
>> Use pcie_set_readrq() if it is needed.
>
> What do you mean by "if needed"? Is there anything wrong?

So what's the conclusion? Can I apply these?

-- 
Kalle Valo
