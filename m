Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51388 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759278Ab2IEUYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 16:24:49 -0400
Received: by iahk25 with SMTP id k25so1242216iah.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 13:24:48 -0700 (PDT)
Message-ID: <5047B508.5030606@lwfinger.net> (sfid-20120905_222452_960791_29BFBFE6)
Date: Wed, 05 Sep 2012 15:24:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
CC: linux-wireless@vger.kernel.org,
	=?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
References: <20120905185510.2ab501cd@destiny.ordissimo> <50478E10.6030808@lwfinger.net> <20120905201437.70c008ca@destiny.ordissimo>
In-Reply-To: <20120905201437.70c008ca@destiny.ordissimo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 01:14 PM, Anisse Astier wrote:
> On Wed, 05 Sep 2012 12:38:24 -0500, Larry Finger <Larry.Finger@lwfinger.net> wrote :
>
>> I have two different revisions of the RTL8188CE card. The newer one, marked
>> RTL8188CE-VL, gives the following lspci output:
>>
>> 06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE
>> 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
>>           Subsystem: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi
>> Adapter [10ec:8176]
>>           Flags: bus master, fast devsel, latency 0, IRQ 20
>>           I/O ports at 4000 [size=256]
>>           Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
>>           Capabilities: [40] Power Management version 3
>>           Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>>           Capabilities: [70] Express Endpoint, MSI 00
>>           Capabilities: [100] Advanced Error Reporting
>>           Capabilities: [140] Virtual Channel
>>           Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
>>           Kernel driver in use: rtl8192ce
>>
>> It certainly does not yield the rx descriptor problem. Please send the lspci
>> output when the driver has not been loaded.
>
> The subsystem ID is different on my wireless card (8212):
>
> 06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
>          Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8212]
>          Flags: bus master, fast devsel, latency 0, IRQ 3
>          I/O ports at 3000 [size=256]
>          Memory at f0200000 (64-bit, non-prefetchable) [size=16K]
>          Capabilities: [40] Power Management version 3
>          Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
>          Capabilities: [70] Express Endpoint, MSI 00
>          Capabilities: [100] Advanced Error Reporting
>          Capabilities: [140] Virtual Channel
>          Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
>
> This id is nowhere to be found in the rtlwifi driver. The only matches in
> Google are my previous problem report (FWLPS freeze) and windows driver
> listings.

The ID that counts is the first one. I think the second is some kind of vendor code.

My other RTL8188CE gives the following output:

0e:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 
802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi 
Adapter [10ec:8176]
         Flags: bus master, fast devsel, latency 0, IRQ 20
         I/O ports at 4000 [size=256]
         Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [70] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
         Kernel driver in use: rtl8192ce

Other than the MAC address, and the bus number, they have the same output.

Note, the RTL8188CE-VL does not work with wireless-next, but does with 
wireless-testing with some patches applied. I will contact the Realtek software 
team to ask questions about your card. I added my contact as a Cc here. In the 
meantime, could you try the wireless-testing tree? If your card still does not 
work, I will send you some patches to see what it takes.

Larry


