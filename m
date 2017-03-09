Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:26272
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754280AbdCIJ6n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 04:58:43 -0500
Subject: Re: [PATCH v4] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1483952830-3967-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <af3dbd89-d9e8-7f6a-d48a-ebe430671963@gmail.com>
 <87d1dt6w9m.fsf@purkki.adurom.net>
 <ca350f9b-55de-8903-b213-c041f8b569e3@broadcom.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        <btherthala@quantenna.com>, <hwang@quantenna.com>,
        <smaksimenko@quantenna.com>, <dlebed@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <6be6c73d-381b-6579-8b57-2a836973b446@quantenna.com> (sfid-20170309_105939_543316_B86EC88B)
Date: Thu, 9 Mar 2017 12:58:03 +0300
MIME-Version: 1.0
In-Reply-To: <ca350f9b-55de-8903-b213-c041f8b569e3@broadcom.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2017 12:10 PM, Arend Van Spriel wrote:
> On 7-3-2017 14:39, Kalle Valo wrote:
>> Rafał Miłecki <zajec5@gmail.com> writes:
>>
>>> On 01/09/2017 10:07 AM, igor.mitsyanko.os@quantenna.com wrote:
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
>>> Hi, what's the state of this patch?
>>
>> I haven't had a chance to look at the latest review comments yet, but
>> this is starting to look good, I think.
>
> So what is the status for the firmware patch. It was submitted as RFC a
> while ago [1].

 From Quantenna side the plan to move forward is:
1. Modify cfg80211 driver patch to introduce ability to boot from card's 
internal flash rather then over PCIe only. This will hopefully unblock 
driver itself.
2. Work internally to provide access to SDK used to build firmware on a 
public server, that has to be accessible for two years. Then submit 
firmware to linux-firmware again.

>
> Regards,
> Arend
>
> [1] https://patchwork.kernel.org/patch/9487515/
>
