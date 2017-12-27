Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46039 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdL0T0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 14:26:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id 9so40819625wme.4
        for <linux-wireless@vger.kernel.org>; Wed, 27 Dec 2017 11:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A43EB27.9040100@broadcom.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-4-git-send-email-alagusankar@silex-india.com>
 <87lghu9247.fsf@kamboji.qca.qualcomm.com> <5281f48b04f8f593ec06e72a041ec021@silex-india.com>
 <5A43EB27.9040100@broadcom.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Wed, 27 Dec 2017 11:26:14 -0800
Message-ID: <CAJ-Vmokao1LqY6rPVn-WKAJwrN3hmEKN+da1Jp53FHvpe1bWiA@mail.gmail.com> (sfid-20171227_202620_629046_E464E180)
Subject: Re: [PATCH 03/11] ath10k_sdio: DMA bounce buffers for read write
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Alagu Sankar <alagusankar@silex-india.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>, silexcommon@gmail.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[top post for emphasis]

Arend is right. You won't be the only driver which has issues with a
controller that doesn't handle non-aligned data payloads. Please push
it into the stack or the controller side, but not in the driver side.
That'll be a forever game of whack-a-mole.


-adrian

(I'm living this dream right now and it's unfun)



On 27 December 2017 at 10:49, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 12/25/2017 1:26 PM, Alagu Sankar wrote:
>>
>> On 2017-12-22 21:38, Kalle Valo wrote:
>>>
>>> silexcommon@gmail.com writes:
>>>
>>>> From: Alagu Sankar <alagusankar@silex-india.com>
>>>>
>>>> Some SD host controllers still need bounce buffers for SDIO data
>>>> transfers. While the transfers worked fine on x86 platforms,
>>>> this is found to be required for i.MX6 based systems.
>>>>
>>>> Changes are similar to and derived from the ath6kl sdio driver.
>>>>
>>>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
>>>
>>>
>>> Why is the bounce buffer needed exactly, what are the symptoms etc? To
>>> me this sounds like an ugly workaround for a SDIO controller driver bug.
>>
>>
>> We faced problems with i.MX6. The authentication frame sent by the
>> driver never reached the air. The host driver accepted the buffer, but
>> did not send out the packet to the sdio module. No errors reported
>> anywhere, but the buffer is not accepted due to alignment. The same
>> driver however works fine without bounce buffer on x86 platform with
>> stdhci drivers. To make it compliant with all host controllers, we
>> introduced the bounce buffers, similar to what was done in ath6kl_sdio
>> drivers.
>
>
> As mentioned by Adrian the comment from Kalle is that you are solving an
> issue caused by the sdio host controller. Although strictly speaking it may
> not be a driver bug, but a requirement of the host controller hardware.
> Either way it seems the obvious place to solve this is in the sdio host
> controller driver to which the issue applies. Or make it a generic quirk
> which can be enabled for sdio host controller drivers that need it. However,
> there may reasons to do it in the networking driver. For instance, the
> buffer you want to transfer might be the data buffer of an sk_buff you got
> from the networking stack and you want to have a zero-copy solution towards
> the wireless device.
>
> Your solution checks for 4-byte alignment which is a requirement for ADMA as
> per SDIO spec. However, I have come across host controllers which have
> different alignment requirements. Also when CONFIG_ARCH_DMA_ADDR_T_64BIT is
> enabled the alignment changes from 4 to 8 bytes. So it seems you are solving
> a specific case you have come across, but you may want to design for more
> flexibility.
>
> Hope this helps.
>
> Regards,
> Arend
