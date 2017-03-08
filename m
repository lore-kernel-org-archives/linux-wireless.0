Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43116 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751755AbdCHLQZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 06:16:25 -0500
Subject: Re: [PATCH v2 2/4] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <20170227214539.16422-2-hdegoede@redhat.com>
 <33689f32-1bf8-98f8-df65-278de097e435@broadcom.com>
 <738d049d-4e90-8a5d-e5c0-d037085a064c@redhat.com>
 <d0bec61e-4481-42b9-fcdd-d6a8f8f3524e@broadcom.com>
 <edc0f67d-59d7-437c-2588-e895217577cd@broadcom.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <d6e96a5e-863b-5054-f370-117c10c7ce2b@redhat.com> (sfid-20170308_121756_183988_844E8A26)
Date: Wed, 8 Mar 2017 12:16:20 +0100
MIME-Version: 1.0
In-Reply-To: <edc0f67d-59d7-437c-2588-e895217577cd@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 08-03-17 11:15, Arend Van Spriel wrote:
> On 8-3-2017 10:26, Arend Van Spriel wrote:
>> On 8-3-2017 9:24, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 07-03-17 11:03, Arend Van Spriel wrote:
>>>>
>>>>
>>>> On 27-2-2017 22:45, Hans de Goede wrote:
>>>>> The firmware responding with -EBUSY when trying to add an extra
>>>>> virtual-if
>>>>> is a normal thing, do not print an error for this.
>>>>
>>>> This may be something we need to look into. It seems to me the interface
>>>> combinations needs to be fixed so we do not try to provision firmware.
>>>> Can you explain the scenario here?
>>>
>>> I'm not doing anything special just connecting to my isp provided
>>> accesspoint
>>> using NetworkManager.
>>
>> Ok. So it is probably the P2P_DEVICE interface as that is the only
>> interface being created in that scenario. Can you provide a log with
>> brcmfmac driver debug=0x1416.
>
> I guess you are seeing this with 43362. Is that correct?

Maybe, it is with the same card as this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=185661

Regards,

Hans
