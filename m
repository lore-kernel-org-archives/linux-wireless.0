Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26695C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 10:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00AEB20844
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 10:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfBKKeC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 05:34:02 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:42745 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfBKKeB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 05:34:01 -0500
Received: from [192.168.178.52] ([109.104.49.86]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MA7b8-1gn7Iq4BPG-00Bbof; Mon, 11 Feb 2019 11:33:51 +0100
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
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
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
Date:   Mon, 11 Feb 2019 11:33:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211100405.GD3467@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:TDFbrG3N0FAhSLoWfJ6dUZIq2dYs144RrrpuDDzGmQGGA0/Rz82
 Bvp9p+sip8l8iEpu0osStQ41RIaOpRVV74HLReHkRGoRXNFv2QWB6ivoox26oognShDKO9F
 vkQmXwqaGKc9zGZ77O4iowu5+KfvB1+htcs8zmrsUZNXmED3/x7DfPYL997+hgHGL0Dtrnx
 ITBhgJ0Nyb6uYg+/SpOog==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6ZAeCemlduU=:Lpfcy5tIRKJZ/3Ofx3gVbm
 oFWjBNGV8xaC1uV7Z4AN+JlL4dxH/BFO9DTjPtKiYAs7ofTdo5C9ZoEqYVT50lNJObMwfgJEV
 Sudh1w8Fm72UUdCegL4tWt8cr+YaObkvduuUS5e9Wvv+lf4JMMR345VOhqYuvkD0fUllTtFX5
 t1uKaBbf2Mkjb42zC6MiEMtjCa/ER1a+GR1zcbooruy6FrlwMauXPl2xxu/b6GA7py3hpJ12N
 nYi10TFTLJkMjhhaoFo3op3XvxMH9BMOCkVEeg48x04kN6XNg168r8nfQmX04UbQVXrgUlnBa
 fsZEuq4gc5m90ig6loxZIfJltJ/VgjBChE7bWm1n6eLM73o5RHM/73wy585oiTV6duoZ35AJ1
 rz/NnIcXj4Xc5pFDT4x7Rjdi5hQaylnX12EZftIMqFNSTEYRiYrACBRthasUM63sfJc6CEb+G
 mVfOcTHamVA75hxGSNbporjGOY1DXFcxLEaODl5fuQdPnTJjegel0QyvleOCoeSFTLAORu6ut
 g0GtOqAr3xLPISX9aUUIUFTuU9HSIcUgRly74g9k+5x/MvVJMkh1tqfD4PJST/wkwVKoI3GYt
 kfcdYScQDlHSLRqtBIZoAF9dPzFHYBwm1NzIgqlK3wnynq/ao6xnb9izeo1H3pwbTlvItsoeb
 YiB4pTqVtqr7+yvimNNERjr1NNbI96a9PMOyh3JvHRf1nSOPIoeVFnuYFuaK2REAtnB7P3/QP
 UdZeGJHeGgWw7OctFivEFvbfQ+CK68t5idfrTAHY4WAokwDJlthQm1t0ORM=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Am 11.02.19 um 11:04 schrieb Lorenzo Bianconi:
>> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
>>>> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
>>>>>> could you please test the following series:
>>>>>> https://patchwork.kernel.org/cover/10764453/
>>>>> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
>>>> So this is either dwc2 scatter-gather problem which should be addressed in
>>>> this driver or mt76x0u does something wrong when configuring SG.
>>>>
>>>> Disabling SG is just workaround, which do not address actual problem.
>>>>
>>>> I think I found mt76x0u issue that could cause this USB probe error
>>>> (and possibly also address AMD IOMMU issue). We seems do not correctly
>>>> set URB transfer length smaller than sg buffer length. Attached  patch
>>>> should correct that.
>>> Hi Stanislaw,
>>>
>>> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
>> It is, buf->len and sg[0].length are initialized to the same value for 1
>> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
>> to smaller value , but sg[0].length stay the same. What I think can be
>> problem for usb host driver.
>>
>>> Moreover applying this patch I got the following crash (rpi-5.0.y):
>> Ok, so with patch probe fail instantly and trigger yet another bug(s)
>> on error path. You seems to address that already. 
>>
>>> Moreover for mt76x0u SG is 'already' disabled since we use just one
>>> buffer so from performance point of view I do not see any difference
>>> of using a standard usb buffer.
>>> This patch has been tested in multiple scenarios and seems to fix
>>> reported issues (for usb2.0).
>> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
>> does not work for 1 segment ?
> Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
> does not implement SG I/O so probing fails. I guess it is still useful to
> implement a 'legacy' mode that enable mt76 on host controllers that do not implement
> SG I/O (rpi is a very common device so it will be cool to have mt76 working on
> it). Moreover we are not removing functionalities, user experience will remain
> the same
>
i'm not sure that you understand my mail [1] with the summary of my test
results.

In case of using the arm/multi_v7_defconfig (32 bit) the mt76 works like
a charm without your sg avoid patch series, but the arm64/defconfig (64
bit) requires the series to probe at least. So i wouldn't conclude from
the fact that dwc2 doesn't support SG any probing issues on arm64. So we
need to investigate which config option triggers the problem.

Stefan

[1] - https://marc.info/?l=linux-usb&m=154981675724078

