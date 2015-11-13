Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:2594 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbKMJLf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 04:11:35 -0500
Message-ID: <5645A944.3080105@broadcom.com> (sfid-20151113_101144_729542_DEFFD78D)
Date: Fri, 13 Nov 2015 10:11:32 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 6/9] brcmfmac: Add RSDB support.
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>	<1446147199-21671-7-git-send-email-arend@broadcom.com> <87io57576r.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87io57576r.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2015 08:49 PM, Kalle Valo wrote:
> Arend van Spriel <arend@broadcom.com> writes:
>
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> RSDB works almost autonomously in firmware except for AP config.
>> When device supports RSDB then the interface should not be
>> brought down when configuring it, otherwise the link (if
>> configured) on the other interface will be lost.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> I have never heard of acronym RSDB before and after some googling I
> think it might mean Real Simultaneous Dual Band. But please try to avoid
> using acronyms and clearly spell it out in the commit log what the
> feature is about.

Google is correct and the acronym is cooked up by Broadcom ;-) In the 
cover letter I mentioned:

* support bcm4359 which can operate in two bands concurrently.

which is a device with two 802.11 cores and hence supports RSDB.

> If you send me suggestions what to add I can edit the commit log before
> I apply this patch.

If needed I can resubmit the patch. This would be the proposed commit log:

Broadcom devices with a single 802.11 core can work on two band
concurrently using VSDB feature, ie. Virtual Simultaneous Dual-Band.
For devices that are fitted with two 802.11 cores and RF paths the
driver should support a firmware feature called RSDB, which stands
for Real Simultaneous Dual-Band. RSDB works almost autonomously in 
firmware except for AP config. When the device supports RSDB then
the interface should not be brought down when configuring it,
otherwise the link (if configured) on the other interface will be
lost.

Hope this helps and let me know if other actions are required from us.

Regards,
Arend
