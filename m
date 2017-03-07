Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35933 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755104AbdCGKyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 05:54:10 -0500
Received: by mail-oi0-f66.google.com with SMTP id a144so7571147oib.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 02:54:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2cf744b3-60f9-fa38-658d-fe06e878f548@quantenna.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com> <2cf744b3-60f9-fa38-658d-fe06e878f548@quantenna.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 7 Mar 2017 11:45:13 +0100
Message-ID: <CACna6rywOG+x7eEaj3-hfUrm8rYdLV38xGFO_JeV0GzvjU6Tvw@mail.gmail.com> (sfid-20170307_115421_161598_A373B8A1)
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        btherthala@quantenna.com, hwang@quantenna.com,
        smaksimenko@quantenna.com, dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 March 2017 at 11:07, Igor Mitsyanko
<igor.mitsyanko.os@quantenna.com> wrote:
> On 03/07/2017 12:19 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
>>>
>>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>>>
>>> This patch adds support for new FullMAC WiFi driver for Quantenna
>>> QSR10G chipsets.
>>>
>>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>>> up to 8 concurrent virtual interfaces on each WMAC.
>>>
>>> Patch introduces 2 new drivers:
>>> - qtnfmac.ko for interfacing with kernel wireless core
>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interfa=
ce
>>
>>
>> Hi, what's the state of this patch? Kalle I see it in your pending branc=
h,
>> could you give me/us a hint what does it mean, please?
>
>
> Hi Rafal, we will be submitting V5 soon addressing your comments and addi=
ng
> option to "boot from internal flash" rather then from PCIe.
>
>>
>> I've also one not-strictly-related question. What about other chipsets
>> support?
>> I'm mostly interested in QT3840BC which can be found in few home routers
>> that
>> OpenWrt/LEDE could support.
>> Can they be supported with submitted core code and just an additional bu=
s
>> driver?
>
>
> Yes, this is a previous generation SoC, we already have support for those
> with additional bus driver which we plan to submit as a followup patch,
> after first one is accepted.
> But support is only for SoCs' connected with host system over PCIe bus, I=
'm
> not sure which product you're interested in exactly: if it uses RGMII
> interface to interface QT3840BC with host CPU then it basically looks lik=
e a
> simple ETH to host. Not much we can do to support FullMAC driver in this
> case.

I was interested in supporting ASUS RT-AC87U and maybe Netgear R7500.

According to the https://wikidevi.com/wiki/ASUS_RT-AC87U ASUS indeed
uses some RGMII interface, I'll need to look for more details first.
Thanks for looking at this.
