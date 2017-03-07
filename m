Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:35781 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdCGPNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 10:13:38 -0500
Received: by mail-qk0-f181.google.com with SMTP id v125so8235517qkh.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 07:13:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rywOG+x7eEaj3-hfUrm8rYdLV38xGFO_JeV0GzvjU6Tvw@mail.gmail.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com> <2cf744b3-60f9-fa38-658d-fe06e878f548@quantenna.com>
 <CACna6rywOG+x7eEaj3-hfUrm8rYdLV38xGFO_JeV0GzvjU6Tvw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Mar 2017 00:03:48 +1100
Message-ID: <CAGRGNgUc09UkT6pbBfeWuQ7FXeN8UWjZ3UThW3mJPQ-6pog9nA@mail.gmail.com> (sfid-20170307_161405_481025_761283DD)
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        btherthala@quantenna.com, hwang@quantenna.com,
        smaksimenko@quantenna.com, dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rafa=C5=82,

On Tue, Mar 7, 2017 at 9:45 PM, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
> On 7 March 2017 at 11:07, Igor Mitsyanko
> <igor.mitsyanko.os@quantenna.com> wrote:
>> On 03/07/2017 12:19 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
>>>>
>>>> From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>>>>
>>>> This patch adds support for new FullMAC WiFi driver for Quantenna
>>>> QSR10G chipsets.
>>>>
>>>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>>>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>>>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>>>> up to 8 concurrent virtual interfaces on each WMAC.
>>>>
>>>> Patch introduces 2 new drivers:
>>>> - qtnfmac.ko for interfacing with kernel wireless core
>>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interf=
ace
>>>
>>>
>>> Hi, what's the state of this patch? Kalle I see it in your pending bran=
ch,
>>> could you give me/us a hint what does it mean, please?
>>
>>
>> Hi Rafal, we will be submitting V5 soon addressing your comments and add=
ing
>> option to "boot from internal flash" rather then from PCIe.
>>
>>>
>>> I've also one not-strictly-related question. What about other chipsets
>>> support?
>>> I'm mostly interested in QT3840BC which can be found in few home router=
s
>>> that
>>> OpenWrt/LEDE could support.
>>> Can they be supported with submitted core code and just an additional b=
us
>>> driver?
>>
>>
>> Yes, this is a previous generation SoC, we already have support for thos=
e
>> with additional bus driver which we plan to submit as a followup patch,
>> after first one is accepted.
>> But support is only for SoCs' connected with host system over PCIe bus, =
I'm
>> not sure which product you're interested in exactly: if it uses RGMII
>> interface to interface QT3840BC with host CPU then it basically looks li=
ke a
>> simple ETH to host. Not much we can do to support FullMAC driver in this
>> case.
>
> I was interested in supporting ASUS RT-AC87U and maybe Netgear R7500.
>
> According to the https://wikidevi.com/wiki/ASUS_RT-AC87U ASUS indeed
> uses some RGMII interface, I'll need to look for more details first.
> Thanks for looking at this.

There's a number of "qtn" strings in the Broadcom boot log listed at
that URL, so it looks like there's some non-network communication
between the "main" SoC and the Quantenna one.

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
