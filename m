Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33144 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbHLOHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 10:07:39 -0400
Received: by iods203 with SMTP id s203so20717414iod.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 07:07:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CB0ACA.3000109@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<CACna6rwJwjiNKnfjV8cH9_fvE38SWLf5ng8ap15OktUZQhOedg@mail.gmail.com>
	<55AD2C8F.9010509@broadcom.com>
	<CACna6rzdE1GubDquszC3jqJjf_UbfPVNrt=oNKSrqj=t9HPBHg@mail.gmail.com>
	<55CB0ACA.3000109@broadcom.com>
Date: Wed, 12 Aug 2015 16:07:38 +0200
Message-ID: <CACna6rz0g8_F8VziRZXaPq-D0_zEmpiZkD6Xo0jwr8M6Nq+Q3A@mail.gmail.com> (sfid-20150812_160742_698944_67FBC493)
Subject: Re: [PATCH 0/7] brcmfmac: nvram loading and code rework
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2015 at 10:58, Arend van Spriel <arend@broadcom.com> wrote:
> On 07/26/2015 05:40 PM, Rafał Miłecki wrote:
>>
>> On 20 July 2015 at 19:14, Arend van Spriel <arend@broadcom.com> wrote:
>>>
>>> On 07/19/2015 05:05 PM, Rafał Miłecki wrote:
>>>>
>>>>
>>>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>>>
>>>>>
>>>>> This series comprises of following changes:
>>>>> - support NVRAM loading for bcm47xx platform.
>>>>> - revise announced interface combinations and validate against it.
>>>>> - new debugfs entry for msgbuf protocol layer used with PCIe devices.
>>>>> - couple of PCIe fixes.
>>>>> - rework dealing with interface instances.
>>>>
>>>>
>>>>
>>>> I'm not sure which patch has caused this (I applied all of them except
>>>> for the 1st one) but now brcmfmac fails totally:
>>>>>
>>>>>
>>>>> Unable to handle kernel NULL pointer dereference at virtual address
>>>>> 00000014
>>>>
>>>>
>>>>
>>>> I'm afraid I won't be able to spend any more time of this soon, so can
>>>> you try to reproduce this problem, please?
>
>
> You did a warm reboot of the device, right? There seems to be an issue
> because on OpenWrt the brcmfmac is not unloaded upon warm reboot, which
> makes the device unaccessible. Because on OpenWrt the firmware request is
> synchronous (OpenWrt patch on top of upstream brcmfmac) it results in probe
> failing on invalid access making the issue OpenWrt specific. Hante created a
> fix for the warm reboot issue.

I'm not sure about this, it was too long time ago. I'm coming back
home on next Tuesday, so I should be able to work on this again soon.

-- 
Rafał
