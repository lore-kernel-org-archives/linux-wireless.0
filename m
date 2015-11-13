Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47929 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbbKMJ3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 04:29:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 6/9] brcmfmac: Add RSDB support.
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
	<1446147199-21671-7-git-send-email-arend@broadcom.com>
	<87io57576r.fsf@kamboji.qca.qualcomm.com>
	<5645A944.3080105@broadcom.com>
Date: Fri, 13 Nov 2015 11:29:44 +0200
In-Reply-To: <5645A944.3080105@broadcom.com> (Arend van Spriel's message of
	"Fri, 13 Nov 2015 10:11:32 +0100")
Message-ID: <87y4e22qnr.fsf@kamboji.qca.qualcomm.com> (sfid-20151113_103000_279141_BF04CC3C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> On 11/12/2015 08:49 PM, Kalle Valo wrote:
>> Arend van Spriel <arend@broadcom.com> writes:
>>
>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>
>>> RSDB works almost autonomously in firmware except for AP config.
>>> When device supports RSDB then the interface should not be
>>> brought down when configuring it, otherwise the link (if
>>> configured) on the other interface will be lost.
>>>
>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>
>> I have never heard of acronym RSDB before and after some googling I
>> think it might mean Real Simultaneous Dual Band. But please try to avoid
>> using acronyms and clearly spell it out in the commit log what the
>> feature is about.
>
> Google is correct and the acronym is cooked up by Broadcom ;-) In the
> cover letter I mentioned:
>
> * support bcm4359 which can operate in two bands concurrently.
>
> which is a device with two 802.11 cores and hence supports RSDB.

Yeah, but the problem is that the cover letter contents are not stored
to git. Johannes once suggested that maybe I should do the same as Dave
does, he adds an extra merge with the cover letter (see below). Hmm..

commit e18f6ac30d31433d8cd9ccf693d3cdd5d2e66ef9
Merge: e407f39afdc0 c02b05011fad
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Oct 27 20:27:45 2015 -0700

    Merge branch 'mlx4-fixes'
    
    Or Gerlitz says:
    
    ====================
    Mellanox mlx4 driver fixes for 4.3-rc7
    
    Jack's fix is for a regression introduced in 4.3-rc1
    
    Carol's fix addresses an issue which exists for while and
    turns to beat us hard on PPC, please queue for -stable.
    ====================
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

>> If you send me suggestions what to add I can edit the commit log before
>> I apply this patch.
>
> If needed I can resubmit the patch. This would be the proposed commit log:
>
> Broadcom devices with a single 802.11 core can work on two band
> concurrently using VSDB feature, ie. Virtual Simultaneous Dual-Band.
> For devices that are fitted with two 802.11 cores and RF paths the
> driver should support a firmware feature called RSDB, which stands
> for Real Simultaneous Dual-Band. RSDB works almost autonomously in
> firmware except for AP config. When the device supports RSDB then
> the interface should not be brought down when configuring it,
> otherwise the link (if configured) on the other interface will be
> lost.
>
> Hope this helps and let me know if other actions are required from us.

Thanks, this is perfect. I'll update the commit log once I open
wireless-drivers-next and apply this patch.

-- 
Kalle Valo
