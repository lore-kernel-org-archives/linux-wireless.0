Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0080.outbound.protection.outlook.com ([104.47.32.80]:22688
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753543AbdCGLeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 06:34:17 -0500
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
 <2cf744b3-60f9-fa38-658d-fe06e878f548@quantenna.com>
 <CACna6rywOG+x7eEaj3-hfUrm8rYdLV38xGFO_JeV0GzvjU6Tvw@mail.gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        <btherthala@quantenna.com>, <hwang@quantenna.com>,
        <smaksimenko@quantenna.com>, <dlebed@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <e5b07c06-740c-cb41-8b92-c4077390ab4c@quantenna.com> (sfid-20170307_123457_695167_42427573)
Date: Tue, 7 Mar 2017 14:00:38 +0300
MIME-Version: 1.0
In-Reply-To: <CACna6rywOG+x7eEaj3-hfUrm8rYdLV38xGFO_JeV0GzvjU6Tvw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2017 01:45 PM, Rafał Miłecki wrote:
>
> External Email
>
>
> On 7 March 2017 at 11:07, Igor Mitsyanko
> <igor.mitsyanko.os@quantenna.com> wrote:
>> On 03/07/2017 12:19 AM, Rafał Miłecki wrote:
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
>>>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface
>>>
>>>
>>> Hi, what's the state of this patch? Kalle I see it in your pending branch,
>>> could you give me/us a hint what does it mean, please?
>>
>>
>> Hi Rafal, we will be submitting V5 soon addressing your comments and adding
>> option to "boot from internal flash" rather then from PCIe.
>>
>>>
>>> I've also one not-strictly-related question. What about other chipsets
>>> support?
>>> I'm mostly interested in QT3840BC which can be found in few home routers
>>> that
>>> OpenWrt/LEDE could support.
>>> Can they be supported with submitted core code and just an additional bus
>>> driver?
>>
>>
>> Yes, this is a previous generation SoC, we already have support for those
>> with additional bus driver which we plan to submit as a followup patch,
>> after first one is accepted.
>> But support is only for SoCs' connected with host system over PCIe bus, I'm
>> not sure which product you're interested in exactly: if it uses RGMII
>> interface to interface QT3840BC with host CPU then it basically looks like a
>> simple ETH to host. Not much we can do to support FullMAC driver in this
>> case.
>
> I was interested in supporting ASUS RT-AC87U and maybe Netgear R7500.
>
> According to the https://wikidevi.com/wiki/ASUS_RT-AC87U ASUS indeed
> uses some RGMII interface, I'll need to look for more details first.
> Thanks for looking at this.
>

Yes, looks like it uses RGMII for Quantenna SoC. In theory I think even 
in this case it should be relatively easy to support FullMAC driver by 
implementing one more bus driver that has to use special types of 
ETHERNET frames to implement communication between host CPU and 
Quantenna CPU over RGMII link (using RAW sockets). In this case it will 
look like proxying of cfg80211 requests from host system to any other 
system in the same network L2 domain (addressable by MAC).
But I don't think this approach can ever be upstreamed.
