Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53002 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754166AbeCSOKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 10:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <5AAF838D.2030105@broadcom.com>
References: <20180319014032.9394-1-alexey.roslyakov@gmail.com>
 <20180319014032.9394-3-alexey.roslyakov@gmail.com> <5AAF838D.2030105@broadcom.com>
From: Alexey Roslyakov <alexey.roslyakov@gmail.com>
Date: Mon, 19 Mar 2018 21:10:21 +0700
Message-ID: <CALFoz4YMKJr40fefczrbjXBROtZxnGikv0Jze-BnefofCB3dyg@mail.gmail.com> (sfid-20180319_151048_184221_47892B55)
Subject: Re: [PATCH net-next v2 2/2] dt: bindings: add new dt entries for brcmfmac
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Andrew Lunn <andrew@lunn.ch>, kvalo@codeaurora.org,
        robh+dt@kernel.org, mark.rutland@arm.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,
I appreciate your response. In my opinion, it has nothing to do with
SDIO host, because it defines "quirks" in the driver itself.
If I get it right, you mean something like this:

mmc3: mmc@1c12000 {
...
        broken-sg-support;
        sd-head-align = 4;
        sd-sgentry-align = 512;

        brcmf: wifi@1 {
                ...
        };
};

Where dt: bindings documentation for these entries should reside?
In generic MMC bindings? Well, this is the very special case and
mmc-linux maintainer will unlikely to accept these changes.
Also, extra kernel code modification might be required. It could make
quite trivial change much more complex.

>Also I am not sure if the broken-sg-support is still needed. We added that for omap_hsmmc, but that has since changed to scatter-gather emulation so it might not be needed anymore.

I've experienced the problem with rk3288 (dw-mmc host) and sdio
settings like above solved it.
Frankly, I haven't investigated any deeper which one of the settings
helped in my case yet...
I will try to get rid of broken-sg-support first and let you know if
it does make any difference.

All the best,
  Alex.

On 19 March 2018 at 16:31, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3/19/2018 2:40 AM, Alexey Roslyakov wrote:
>>
>> In case if the host has higher align requirements for SG items, allow
>> setting device-specific aligns for scatterlist items.
>>
>> Signed-off-by: Alexey Roslyakov <alexey.roslyakov@gmail.com>
>> ---
>>   Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 5
>> +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git
>> a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> index 86602f264dce..187b8c1b52a7 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> @@ -17,6 +17,11 @@ Optional properties:
>>         When not specified the device will use in-band SDIO interrupts.
>>    - interrupt-names : name of the out-of-band interrupt, which must be
>> set
>>         to "host-wake".
>> + - brcm,broken-sg-support : boolean flag to indicate that the SDIO host
>> +       controller has higher align requirement than 32 bytes for each
>> +       scatterlist item.
>> + - brcm,sd-head-align : alignment requirement for start of data buffer.
>> + - brcm,sd-sgentry-align : length alignment requirement for each sg
>> entry.
>
>
> Hi Alexey,
>
> Thanks for the patch. However, the problem with these is that they are
> characterizing the host controller and not the wireless device. So from
> device tree perspective , which is to describe the hardware, these
> properties should be SDIO host controller properties. Also I am not sure if
> the broken-sg-support is still needed. We added that for omap_hsmmc, but
> that has since changed to scatter-gather emulation so it might not be needed
> anymore.
>
> Regards,
> Arend



-- 
With best regards,
  Alexey Roslyakov
Email: alexey.roslyakov@gmail.com
