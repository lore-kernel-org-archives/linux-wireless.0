Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35247 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752570AbdEPT5F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 15:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <8155d0f1-aed3-fc47-4524-635067f9ee7b@broadcom.com>
References: <20170515201356.26384-1-martin.blumenstingl@googlemail.com>
 <20170515201356.26384-2-martin.blumenstingl@googlemail.com> <8155d0f1-aed3-fc47-4524-635067f9ee7b@broadcom.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Tue, 16 May 2017 21:56:38 +0200
Message-ID: <CAFBinCBeijYMJ+hTajCA-2D7S1aH6E2mc_gm-2cAqKt87XVNkg@mail.gmail.com> (sfid-20170516_215727_297171_4E532931)
Subject: Re: [PATCH 1/1] dt-binding: net: wireless: fix node name in the
 BCM43xx example
To: Arend Van Spriel <arend.vanspriel@broadcom.com>, robh+dt@kernel.org
Cc: kvalo@codeaurora.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Tue, May 16, 2017 at 12:05 AM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 15-5-2017 22:13, Martin Blumenstingl wrote:
>> The example in the BCM43xx documentation uses "brcmf" as node name.
>> However, wireless devices should be named "wifi" instead. Fix this to
>
> Hi Martin,
>
> Since when is that a rule. I never got the memo and the DTC did not ever
> complain to me about the naming. That being said I do not really care
> and I suppose it is for the sake of consistency only.
I'm not sure if it's actually a rule or (as you already noted) just
for consistency. back when I added devicetree support to ath9k Rob
pointed out that the node should be named "wifi" (instead of "ath9k"),
see [0]

>> make sure that .dts authors can simply use the documentation as
>> reference (or simply copy the node from the documentation and then
>> adjust only the board specific bits).
>
> Please feel free to add my...
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
thank you!

@Rob: maybe you can ACK this as well if you're fine with this patch?

>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>>  Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> index 5dbf169cd81c..590f622188de 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
>> @@ -31,7 +31,7 @@ mmc3: mmc@01c12000 {
>>       non-removable;
>>       status = "okay";
>>
>> -     brcmf: bcrmf@1 {
>> +     brcmf: wifi@1 {
>>               reg = <1>;
>>               compatible = "brcm,bcm4329-fmac";
>>               interrupt-parent = <&pio>;
>>

[0] http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg14678.html
