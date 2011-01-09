Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54088 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab1AIRtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 12:49:14 -0500
Message-ID: <4D29F512.3050707@candelatech.com>
Date: Sun, 09 Jan 2011 09:49:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Implement rx copy-break.
References: <1294500800-29191-1-git-send-email-greearb@candelatech.com> <4D296B12.8000801@openwrt.org>
In-Reply-To: <4D296B12.8000801@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2011 12:00 AM, Gabor Juhos wrote:
> Hi Ben,
>
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This saves us constantly allocating large, multi-page
>> skbs.  It should fix the order-1 allocation errors reported,
>> and in a 60-vif scenario, this significantly decreases CPU
>> utilization, and latency, and increases bandwidth.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> :100644 100644 b2497b8... ea2f67c... M	drivers/net/wireless/ath/ath9k/recv.c
>>   drivers/net/wireless/ath/ath9k/recv.c |   92 ++++++++++++++++++++++-----------
>>   1 files changed, 61 insertions(+), 31 deletions(-)
>
> <...>
>
>> +		if (use_copybreak) {
>> +			struct pci_dev *pdev = to_pci_dev(sc->dev);
>
> This would cause undefined behaviour with ath9k devices sitting on an AHB bus.
>
>> +			pci_dma_sync_single_for_cpu(pdev, bf->bf_buf_addr,
>> +						    len, PCI_DMA_FROMDEVICE);
>> +			skb_copy_from_linear_data(bf->bf_mpdu, skb->data, len);
>> +			pci_dma_sync_single_for_device(pdev, bf->bf_buf_addr,
>> +						       len, PCI_DMA_FROMDEVICE);
>
> Please use the bus agnostic equivalents of these DMA functions.

Any idea what that might be?

Should we just disable copybreak for things on AHB bus?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
