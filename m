Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB23C282CE
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9608F21B1A
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 15:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729071AbfBKP1x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 10:27:53 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:40023 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfBKP1w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 10:27:52 -0500
Received: from [192.168.178.52] ([109.104.49.86]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mum2d-1hB1d13XUJ-00rqZK; Mon, 11 Feb 2019 16:27:40 +0100
From:   Stefan Wahren <stefan.wahren@i2se.com>
Subject: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
 <20190211100405.GD3467@localhost.localdomain>
 <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
 <20190211110635.GD2293@localhost.localdomain>
 <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
 <20190211151055.GC8128@localhost.localdomain>
Message-ID: <500c0d4a-611a-1b00-5ea4-7368e5e9f1e9@i2se.com>
Date:   Mon, 11 Feb 2019 16:27:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211151055.GC8128@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:rTuXrylCfHchX1CtYUdZvx6/JNu4bw2yo1YBhViYQ5qQtwk42Sj
 gruNSWn7zV2VP2IqfOYj72viBxQBvNbBTdDlre8mMUpvEeQRb7MQURngfXZz7f7YCBwuXef
 6SbhClX8eEOXXJjceG+isQj6+Mi6jm9cnrOATk8uTa6TsLUZK7SEQU/HmyCC1I+yfmjqMX6
 bEvX/o4itpk18BaoTNrjw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+qmS/CdIWPc=:hhbBF02gUVVP0fItUWgby5
 JQKn24dk6NZt09OQKAYOAo1dL57I9wLT+M0AzhfFXDt8+iG8oi6FNvq8upqjG5v0WcjtITRDl
 FWD6xsLoj2NL0FV1+7khpN8SAA/ZPdf/xXs/pqUFvt5iCosZNuvH9OJIVpQGxMocy/xVhT3s5
 sdlHxm+3FxIsS/dCTnWoAQHkmAv7MoMO0kIjvLAqV2wcEuncFHvlMZnQqtiLm4HeUt59GTu64
 Ztm5Oxmx0HgYqLNvMtS1giaGxrbddhRY+jQSC2juDz+AbJzFcc9bFEBLXe41wpBhoRQpYkPKN
 QEh68f/c7Br+oQg3fndvGunIAgi5FTwsYujeWu6fhmssjus5/z09fX7NCfIq5T91Q2mz47GeM
 0HZs21mJazIpdkreyW8k3MjjrqMHbnv2vVmldVYSi2GrrqPKnnVWkyb8hcep/kL8feV2xVSAg
 GD3Mjaj4kjGg3LpCpqenaMdavVdBhA6dvUO/61O6PQyXcYvlNpFI4vdXt0Us0C45SIVd9jpr9
 VJZX3hGJr/V8Ds/EAaCzWcdWCIB0WUuelHIC8GM8OVPxVMH2OjekAshUhPvYGBb4RgmNtsQB2
 j+Z0ee+13LomjYAlRiE+Av4Pfc2fcFNNkzGcAEoLujdyD9Kx9JUi8IhPJFBKKnxIgx7Gn9mFH
 QomoWebV6J5TxScJ5wqN+QdCCOiYnfsvZXSgjKIDI9woNCafUQhLq2TaPrYvTmdXgDaWJl6gc
 3Hu/uZbhW7Ls7fDpzkVk2F9EyNhRjGd98e4LfbT89YLNEQPgz5TVHH+KLH0=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Am 11.02.19 um 16:10 schrieb Lorenzo Bianconi:
>> Hi Lorenzo,
>>
>> Am 11.02.19 um 12:06 schrieb Lorenzo Bianconi:
>>>> Hi,
>>>>
>>>> Am 11.02.19 um 11:04 schrieb Lorenzo Bianconi:
>>>>>> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
>>>>>>>> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
>>>>>>>>>> could you please test the following series:
>>>>>>>>>> https://patchwork.kernel.org/cover/10764453/
>>>>>>>>> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
>>>>>>>> So this is either dwc2 scatter-gather problem which should be addressed in
>>>>>>>> this driver or mt76x0u does something wrong when configuring SG.
>>>>>>>>
>>>>>>>> Disabling SG is just workaround, which do not address actual problem.
>>>>>>>>
>>>>>>>> I think I found mt76x0u issue that could cause this USB probe error
>>>>>>>> (and possibly also address AMD IOMMU issue). We seems do not correctly
>>>>>>>> set URB transfer length smaller than sg buffer length. Attached  patch
>>>>>>>> should correct that.
>>>>>>> Hi Stanislaw,
>>>>>>>
>>>>>>> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
>>>>>> It is, buf->len and sg[0].length are initialized to the same value for 1
>>>>>> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
>>>>>> to smaller value , but sg[0].length stay the same. What I think can be
>>>>>> problem for usb host driver.
>>>>>>
>>>>>>> Moreover applying this patch I got the following crash (rpi-5.0.y):
>>>>>> Ok, so with patch probe fail instantly and trigger yet another bug(s)
>>>>>> on error path. You seems to address that already. 
>>>>>>
>>>>>>> Moreover for mt76x0u SG is 'already' disabled since we use just one
>>>>>>> buffer so from performance point of view I do not see any difference
>>>>>>> of using a standard usb buffer.
>>>>>>> This patch has been tested in multiple scenarios and seems to fix
>>>>>>> reported issues (for usb2.0).
>>>>>> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
>>>>>> does not work for 1 segment ?
>>>>> Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
>>>>> does not implement SG I/O so probing fails. I guess it is still useful to
>>>>> implement a 'legacy' mode that enable mt76 on host controllers that do not implement
>>>>> SG I/O (rpi is a very common device so it will be cool to have mt76 working on
>>>>> it). Moreover we are not removing functionalities, user experience will remain
>>>>> the same
>>>>>
>>>> i'm not sure that you understand my mail [1] with the summary of my test
>>>> results.
>>>>
>>> Yes right, I did not get it sorry :)
>>> as indicated here https://www.raspberrypi.org/documentation/linux/kernel/building.md
>>> I am using bcm2709_defconfig config (using it I spotted the mt76 crashes and
>>> probe failure)
>> no problem, at the beginning this could be very confusing. I only want
>> to clarify that this documentation refers to the vendor kernel (with a
>> different USB host driver) of the Raspberry Pi Foundation.
>>
>> All my results refers to the mainline kernel we all should talk about. I
>> started a gist which try to describe the mainline variant:
>> https://gist.github.com/lategoodbye/c7317a42bf7f9c07f5a91baed8c68f75
> So to summarize:
> - Raspberry Pi Foundation kernel works just with RFC series
> - mainline kernel works out of the box
>
> is my understanding correct? 

not really.

Compiling the mainline kernel with arm/multi_v7_defconfig it works.
Using the same kernel but with arm64/defconfig doesn't work. But i don't
think this is a 32/64 bit issue. The arm64 defconfig is much more
complex (e.g. enables more IOMMU stuff).

Regards
Stefan

