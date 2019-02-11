Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5BCC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48616222B4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 14:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbfBKOEe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 09:04:34 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:33229 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfBKOEe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 09:04:34 -0500
Received: from [192.168.178.52] ([109.104.49.86]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N9d91-1h7Ctv46GT-015W78; Mon, 11 Feb 2019 15:04:23 +0100
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
Message-ID: <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
Date:   Mon, 11 Feb 2019 15:04:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211110635.GD2293@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:3Dtfg1RobswGJ8nFFYaO+n5PH0PrzHMzaScFXVjk9/YULR/ZRM8
 Y41oGaUzYbPwt0fb2NWWhNj+Mswhca+vTWY2neGYExyJjilg5ruGFNv7iYVavXhsl5eSolN
 bTBiE9OkYg3GVaCg0Y+4Ht0OSdaq2towMrad731/K6qt8twQCC7zVgU8DryovvmpPbp15Ym
 bN2XfGA9BI5c63haDQM3w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gYPtX4WLR28=:re800GoKnGAwIH7hwGYyOC
 hbieveALwPHZgoWFUsf1aWDWpBbtxCWXAymcQDChxX4dTkL+5a8Ku5BCYN4I9gNxcLr2ZVEp5
 ceus+lQYt9LgFawqwY5eosIWNDDX9WrZATva357rHf7hbfh91U498fSTVnBbo5j442Mv403He
 H4FtzGVaxbUrG6xtbz8BEs8ADFkALRb41GX/jmhMhvIuR8UhsQhBRfSQZ10YvlnpDTZWAsr+F
 HZfMjVUyCwUElt/6E/s2LMtz3O+c+bwqxmoY7EnbbQL6xgtDk9aIXz+efArJ48t3LeOHK0X1a
 JAVl138GIj4uEnkHkkTLArApl5/scDxYMCRHhTHZi7OVgn9PRnCcnNwzXBEas2/sb+JpcFY7R
 6//57NvNT0rJEGf8dZuz4BxdXh9Rk0vyDMdsZTa2DaiyKVuaMuGQfQflKRXjzp3gK92r+FcSp
 23kbsRcn5neU4sOQR4fLdKFK3br3vdP5TCMrV8sD1prz6yf4uSbotTgVaNaj6GaIDyEQwKuL6
 LBilPpue5T+kSQdgrUQcDtdaUp2nfHy4D0sK3Kq530z219yK5jbM7cf+rPAc7Mq8LR8ZLvyzk
 NBQ676SEW9qstDcmfrNer7EzqqHBpjiQ1s7+LRTq9qxc5rxlbsBhnez/hzvNGeLG6HDa/DiEX
 Y+MVTg3bWLbQFe9nMVmq06UAbkJXWzRBOkeXMtXGMFsXSEXDtaVaOv1m6Dxh7FOJKABOzQYPf
 dm1kNK7Eseo4MAM9k69OunbZ2qfTRS+DQPLnYahS56T/uS/Gpj6uRpdkz18=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Lorenzo,

Am 11.02.19 um 12:06 schrieb Lorenzo Bianconi:
>> Hi,
>>
>> Am 11.02.19 um 11:04 schrieb Lorenzo Bianconi:
>>>> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
>>>>>> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
>>>>>>>> could you please test the following series:
>>>>>>>> https://patchwork.kernel.org/cover/10764453/
>>>>>>> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
>>>>>> So this is either dwc2 scatter-gather problem which should be addressed in
>>>>>> this driver or mt76x0u does something wrong when configuring SG.
>>>>>>
>>>>>> Disabling SG is just workaround, which do not address actual problem.
>>>>>>
>>>>>> I think I found mt76x0u issue that could cause this USB probe error
>>>>>> (and possibly also address AMD IOMMU issue). We seems do not correctly
>>>>>> set URB transfer length smaller than sg buffer length. Attached  patch
>>>>>> should correct that.
>>>>> Hi Stanislaw,
>>>>>
>>>>> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
>>>> It is, buf->len and sg[0].length are initialized to the same value for 1
>>>> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
>>>> to smaller value , but sg[0].length stay the same. What I think can be
>>>> problem for usb host driver.
>>>>
>>>>> Moreover applying this patch I got the following crash (rpi-5.0.y):
>>>> Ok, so with patch probe fail instantly and trigger yet another bug(s)
>>>> on error path. You seems to address that already. 
>>>>
>>>>> Moreover for mt76x0u SG is 'already' disabled since we use just one
>>>>> buffer so from performance point of view I do not see any difference
>>>>> of using a standard usb buffer.
>>>>> This patch has been tested in multiple scenarios and seems to fix
>>>>> reported issues (for usb2.0).
>>>> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
>>>> does not work for 1 segment ?
>>> Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
>>> does not implement SG I/O so probing fails. I guess it is still useful to
>>> implement a 'legacy' mode that enable mt76 on host controllers that do not implement
>>> SG I/O (rpi is a very common device so it will be cool to have mt76 working on
>>> it). Moreover we are not removing functionalities, user experience will remain
>>> the same
>>>
>> i'm not sure that you understand my mail [1] with the summary of my test
>> results.
>>
> Yes right, I did not get it sorry :)
> as indicated here https://www.raspberrypi.org/documentation/linux/kernel/building.md
> I am using bcm2709_defconfig config (using it I spotted the mt76 crashes and
> probe failure)

no problem, at the beginning this could be very confusing. I only want
to clarify that this documentation refers to the vendor kernel (with a
different USB host driver) of the Raspberry Pi Foundation.

All my results refers to the mainline kernel we all should talk about. I
started a gist which try to describe the mainline variant:
https://gist.github.com/lategoodbye/c7317a42bf7f9c07f5a91baed8c68f75

Maybe this could be helpful.

Stefan

> Regards,
> Lorenzo
>
>> In case of using the arm/multi_v7_defconfig (32 bit) the mt76 works like
>> a charm without your sg avoid patch series, but the arm64/defconfig (64
>> bit) requires the series to probe at least. So i wouldn't conclude from
>> the fact that dwc2 doesn't support SG any probing issues on arm64. So we
>> need to investigate which config option triggers the problem.
>>
>> Stefan
>>
>> [1] - https://marc.info/?l=linux-usb&m=154981675724078
>>
