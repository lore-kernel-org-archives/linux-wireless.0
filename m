Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:36368 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab1AJHOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:14:07 -0500
Message-ID: <4D2AB1BA.4010205@openwrt.org>
Date: Mon, 10 Jan 2011 08:14:02 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D296B12.8000801@openwrt.org> <4D29F512.3050707@candelatech.com>
In-Reply-To: <4D29F512.3050707@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011.01.09. 18:49 keltezéssel, Ben Greear írta:
> On 01/09/2011 12:00 AM, Gabor Juhos wrote:
>> Hi Ben,
>>
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> This saves us constantly allocating large, multi-page
>>> skbs.  It should fix the order-1 allocation errors reported,
>>> and in a 60-vif scenario, this significantly decreases CPU
>>> utilization, and latency, and increases bandwidth.
>>>
>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>> ---
>>> :100644 100644 b2497b8... ea2f67c... M    drivers/net/wireless/ath/ath9k/recv.c
>>>   drivers/net/wireless/ath/ath9k/recv.c |   92 ++++++++++++++++++++++-----------
>>>   1 files changed, 61 insertions(+), 31 deletions(-)
>>
>> <...>
>>
>>> +        if (use_copybreak) {
>>> +            struct pci_dev *pdev = to_pci_dev(sc->dev);
>>
>> This would cause undefined behaviour with ath9k devices sitting on an AHB bus.
>>
>>> +            pci_dma_sync_single_for_cpu(pdev, bf->bf_buf_addr,
>>> +                            len, PCI_DMA_FROMDEVICE);
>>> +            skb_copy_from_linear_data(bf->bf_mpdu, skb->data, len);
>>> +            pci_dma_sync_single_for_device(pdev, bf->bf_buf_addr,
>>> +                               len, PCI_DMA_FROMDEVICE);
>>
>> Please use the bus agnostic equivalents of these DMA functions.
> 
> Any idea what that might be?

Invalid/null pointer dereference probably. The problem is that sc->dev is
pointing to a device structure inside a platform_device structure when it is not
PCI device. Converting sc->dev to 'struct *pci_dev' and using the result as a
parameter for a PCI specific function is not correct in this case.

> Should we just disable copybreak for things on AHB bus?

We should not disable it, order-1 allocation failures are present there as well.

-Gabor
