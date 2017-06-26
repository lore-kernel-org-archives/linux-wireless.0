Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:35928 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751308AbdFZSQl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 14:16:41 -0400
Received: by mail-ot0-f194.google.com with SMTP id r67so871212ota.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jun 2017 11:16:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
References: <09063fc2-af77-ced6-ed90-ab20e2884969@redhat.com>
 <577dc508-07ff-c74f-5c90-b6baf4e7694a@broadcom.com> <e6ef170b-2ec7-e364-5097-6e0daf5b8f0d@redhat.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Mon, 26 Jun 2017 20:16:40 +0200
Message-ID: <CACna6ry-5LMni26wBeO+66S0Usaq0_tBYh-V6Ef3ihx+ejCW0Q@mail.gmail.com> (sfid-20170626_201645_061101_7EDC40CD)
Subject: Re: brcmfmac: don't warn user if requested nvram fails
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2017 at 11:53, Hans de Goede <hdegoede@redhat.com> wrote:
> On 07-04-17 23:43, Arend Van Spriel wrote:
>> On 6-4-2017 14:14, Hans de Goede wrote:
>>> I noticed your patch-series on the lwn.net kernel page,
>>> and I took a peek :)
>>>
>>> I don't think that this patch:
>>>
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/commit/?h=20170329-driver-data-v2-try3&id=3968dd3031d1ff7e7be4acfb810948c70c2d4490
>>>
>>>
>>> Is a good idea, specifically the "do not warn" part,
>>> although the brcmfmac driver will indeed try to continue
>>> without a nvram file, in my experience it almost all
>>> the time will not work properly without the nvram file.
>>
>>
>> Actually, brcmfmac will only continue without nvram for PCIe devices.
>> For SDIO it is a different story, which may be the kind of devices you
>> have experienced.
>
>
> Ah, no I've experience with both now, and the device I've
> with a PCIE which needs nvram:
>
> http://www.gpd.hk/gpdwin.asp
>
> Will not work without the nvram file, so I really think
> we should at least keep a warning msg here.

This is a late reply, I know...

I think you misunderstood my patch. It didn't completely remove the
warning. It just removed first try warning, where there is still a
chance of getting NVRAM from the platform data (special partition used
by bootloader & accessible by the operating system).

When both methods would fail, the warning would still appear.
