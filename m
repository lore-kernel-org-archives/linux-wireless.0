Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757357AbcK2OwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 09:52:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFr=TE+EuZ9rZV3ygsjBFN_mRrE2imkFa-wQs_ykM5d+cQ@mail.gmail.com>
References: <1479434109-8745-1-git-send-email-matt@ranostay.consulting>
 <20161128141513.agnkyz6ronigbukn@rob-hp-laptop> <CAPDyKFr=TE+EuZ9rZV3ygsjBFN_mRrE2imkFa-wQs_ykM5d+cQ@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 29 Nov 2016 08:51:22 -0600
Message-ID: <CAL_Jsq+80LAkCGEdP5T0AWFV2nRtZ8nrkBoNRB47CR9JN=9dog@mail.gmail.com> (sfid-20161129_155305_281331_A0DBD693)
Subject: Re: [PATCH] mmc: pwrseq: add support for Marvell SD8787 chip
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Matt Ranostay <matt@ranostay.consulting>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 28, 2016 at 9:54 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> [...]
>
>>> +
>>> +Example:
>>> +
>>> +     wifi_pwrseq: wifi_pwrseq {
>>> +             compatible = "mmc-pwrseq-sd8787";
>>> +             pwrdn-gpio = <&twl_gpio 0 GPIO_ACTIVE_LOW>;
>>> +             reset-gpio = <&twl_gpio 1 GPIO_ACTIVE_LOW>;
>>> +     }
>>> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>> index c421aba0a5bc..08fd65d35725 100644
>>> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>>> @@ -32,6 +32,9 @@ Optional properties:
>>>                so that the wifi chip can wakeup host platform under certain condition.
>>>                during system resume, the irq will be disabled to make sure
>>>                unnecessary interrupt is not received.
>>> +  - vmmc-supply: a phandle of a regulator, supplying VCC to the card
>>
>> This is why pwrseq is wrong. You have some properties in the card node
>> and some in pwrseq node. Everything should be in the card node.
>
> Put "all" in the card node, just doesn't work for MMC. Particular in
> cases when we have removable cards, as then it would be wrong to have
> a card node.

When is there a problem with removable cards? The connector is
standard and everything needed (CD, VMMC, VDDIO, etc.) is defined in
the host controller node. If that isn't sufficient, then we should
start defining a connector node.

> The mmc pwrseq DT bindings just follows the legacy approach for MMC
> and that's why the pwrseq handle is at the controller node. Yes, would
> could have done it differently, but this is the case now, so we will
> have to accept that.

We're stuck with supporting the existing cases. That doesn't mean
we're stuck with the same thing for new cases.

Rob
