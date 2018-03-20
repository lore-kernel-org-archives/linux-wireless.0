Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36233 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbeCTDgb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 23:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <5AB044C0.9060701@broadcom.com>
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
 <20180319014032.9394-3-alexey.roslyakov@gmail.com> <5AAF838D.2030105@broadcom.com>
 <CALFoz4YMKJr40fefczrbjXBROtZxnGikv0Jze-BnefofCB3dyg@mail.gmail.com>
 <817418fd-6446-57ea-b03d-383b4df9a979@gmail.com> <5AB044C0.9060701@broadcom.com>
From: Alexey Roslyakov <alexey.roslyakov@gmail.com>
Date: Tue, 20 Mar 2018 10:36:28 +0700
Message-ID: <CALFoz4bpJMkCQyC1GrJj5QzAgjxUvMjkC=7SnZZu3s3tyiRLWA@mail.gmail.com> (sfid-20180320_043710_982332_8C43E6E1)
Subject: Re: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for brcmfmac
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kalle Valo <kvalo@codeaurora.org>, robh+dt@kernel.org,
        mark.rutland@arm.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,
I use RK3288-firefly, bcm4339 (ap6335).

Regards,
  Alex

On 20 March 2018 at 06:16, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> + Uffe
>
> On 3/19/2018 6:55 PM, Florian Fainelli wrote:
>>
>> On 03/19/2018 07:10 AM, Alexey Roslyakov wrote:
>>>
>>> Hi Arend,
>>> I appreciate your response. In my opinion, it has nothing to do with
>>> SDIO host, because it defines "quirks" in the driver itself.
>>
>>
>> It is not clear to me from your patch series whether the problem is that:
>>
>> - the SDIO device has a specific alignment requirements, which would be
>> either a SDIO device driver limitation/issue or maybe the underlying
>> hardware device/firmware requiring that
>>
>> - the SDIO host controller used is not capable of coping nicely with
>> these said limitations
>>
>> It seems to me like what you are doing here is a) applicable to possibly
>> more SDIO devices and host combinations, and b) should likely be done at
>> the layer between the host and device, such that it is available to more
>> combinations.
>
>
> Indeed. That was my thought exactly and I can not imagine Uffe would push
> back on that reasoning.
>
>>> If I get it right, you mean something like this:
>>>
>>> mmc3: mmc@1c12000 {
>>> ...
>>>          broken-sg-support;
>>>          sd-head-align = 4;
>>>          sd-sgentry-align = 512;
>>>
>>>          brcmf: wifi@1 {
>>>                  ...
>>>          };
>>> };
>>>
>>> Where dt: bindings documentation for these entries should reside?
>>> In generic MMC bindings? Well, this is the very special case and
>>> mmc-linux maintainer will unlikely to accept these changes.
>>> Also, extra kernel code modification might be required. It could make
>>> quite trivial change much more complex.
>>
>>
>> If the MMC maintainers are not copied on this patch series, it will
>> likely be hard for them to identify this patch series and chime in...
>
>
> The main question is whether this is indeed a "very special case" as Alexey
> claims it to be or that it is likely to be applicable to other device and
> host combinations as you are suggesting.
>
> If these properties are imposed by the host or host controller it would make
> sense to have these in the mmc bindings.
>
>>>
>>>> Also I am not sure if the broken-sg-support is still needed. We added
>>>> that for omap_hsmmc, but that has since changed to scatter-gather emulation
>>>> so it might not be needed anymore.
>>>
>>>
>>> I've experienced the problem with rk3288 (dw-mmc host) and sdio
>>> settings like above solved it.
>>> Frankly, I haven't investigated any deeper which one of the settings
>>> helped in my case yet...
>>> I will try to get rid of broken-sg-support first and let you know if
>>> it does make any difference.
>
>
> Are you using some chromebook. I have some lying around here so I could also
> look into it. What broadcom chipset do you have?
>
> Regards,
> Arend
>
>
>>> All the best,
>>>    Alex.
>>>
>>> On 19 March 2018 at 16:31, Arend van Spriel
>>> <arend.vanspriel@broadcom.com> wrote:
>>>>
>>>> On 3/19/2018 2:40 AM, Alexey Roslyakov wrote:
>>>>>
>>>>>
>>>>> In case if the host has higher align requirements for SG items, allow
>>>>> setting device-specific aligns for scatterlist items.
>>>>>
>>>>> Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>
>>>>> ---
>>>>>    Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>> | 5
>>>>> +++++
>>>>>    1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git
>>>>> a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>> b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>> index 86602f264dce..187b8c1b52a7 100644
>>>>> ---
>>>>> a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>> +++
>>>>> b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>>>>> @@ -17,6 +17,11 @@ Optional properties:
>>>>>          When not specified the device will use in-band SDIO
>>>>> interrupts.
>>>>>     - interrupt-names : name of the out-of-band interrupt, which must
>>>>> be
>>>>> set
>>>>>          to "host-wake".
>>>>> + - brcm,broken-sg-support : boolean flag to indicate that the SDIO
>>>>> host
>>>>> +       controller has higher align requirement than 32 bytes for each
>>>>> +       scatterlist item.
>>>>> + - brcm,sd-head-align : alignment requirement for start of data
>>>>> buffer.
>>>>> + - brcm,sd-sgentry-align : length alignment requirement for each sg
>>>>> entry.
>>>>
>>>>
>>>>
>>>> Hi Alexey,
>>>>
>>>> Thanks for the patch. However, the problem with these is that they are
>>>> characterizing the host controller and not the wireless device. So from
>>>> device tree perspective , which is to describe the hardware, these
>>>> properties should be SDIO host controller properties. Also I am not sure
>>>> if
>>>> the broken-sg-support is still needed. We added that for omap_hsmmc, but
>>>> that has since changed to scatter-gather emulation so it might not be
>>>> needed
>>>> anymore.
>>>>
>>>> Regards,
>>>> Arend
>>>
>>>
>>>
>>>
>>
>>
>



-- 
With best regards,
  Alexey Roslyakov
Email: alexey.roslyakov@gmail.com
