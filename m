Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36482 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdE3M0I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 May 2017 08:26:08 -0400
Received: by mail-wm0-f54.google.com with SMTP id 7so90017035wmo.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 May 2017 05:26:07 -0700 (PDT)
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then
 hardcoded "4" for bus:txglomalign
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526110255.21342-1-hdegoede@redhat.com>
 <87d1avrhrg.fsf@kamboji.qca.qualcomm.com>
 <619191d3-8ed3-b2a5-e8db-330d7b610b2d@redhat.com>
 <a3926467-4991-dba0-46e9-8397f25ff92d@broadcom.com>
 <874lw7r7nw.fsf@kamboji.qca.qualcomm.com>
 <af46856e-e1b4-4fad-c4b3-2c462549f9ee@broadcom.com>
Message-ID: <e4894759-b675-6222-3bd9-efcf9395279c@broadcom.com> (sfid-20170530_142610_797077_2B9549C1)
Date: Tue, 30 May 2017 14:26:07 +0200
MIME-Version: 1.0
In-Reply-To: <af46856e-e1b4-4fad-c4b3-2c462549f9ee@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-05-17 19:11, Arend van Spriel wrote:
> On 26-05-17 16:53, Kalle Valo wrote:
>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>>>>> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
>>>>>> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>>
>>>>> I'll queue this to 4.12.
>>>>
>>>> Thank you, given that Arend is set as the Author you can add my:
>>>>
>>>> Tested-by: Hans de Goede <hdegoede@redhat.com>
>>>>
>>>> And maybe drop the Suggested-by: Arend van Spriel ?
>>
>> Sure, I can add that.
>>
>>> Seems to me you need my Signed-off-by: as I do not see that in this patch.
>>
>> Yes, that is needed if you are the author. If you reply to this message
>> I can add that.
> 
> Ok. Here it is. Please feel free to add Signed-off-by tag for me
> authoring this change. The Signed-off-by tag for Hans can stay as well
> as this patch went through his hands (and he came up with the commit
> message ;-) ).

Hi Kalle,

Here is the commit message I came up with which may explain the issue
better:

"""
brcmfmac: fix alignment configuration on host using 64-bit DMA

For SDIO the alignment requirement for transfers from device to host
is configured in firmware. This configuration is limited to minimum
of 4-byte alignment. However, this is not correct for platforms using
64-bit DMA when the minimum alignment should be 8 bytes. This issue
appeared when the ALIGNMENT definition was set according the DMA
configuration. The configuration in firmware was not using that macro
defintion, but a hardcoded value of 4. Hence the driver reported
alignment failures for data coming from the device and causing
transfers to fail.

Fixes: 6e84ab604bde ("brcmfmac: properly align buffers on certain platforms
Reported-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
"""

I leave it at your discretion how to deal with this. If needed I can
submit the complete patch.

Regards,
Arend
