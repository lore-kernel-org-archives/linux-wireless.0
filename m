Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0315C10F00
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB00D2183E
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 17:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbfBSRCb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 12:02:31 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:50777 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729528AbfBSRCS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 12:02:18 -0500
Received: from [192.168.178.52] ([109.104.34.73]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1McpW8-1hW1Ur3dGU-00ZxJe; Tue, 19 Feb 2019 18:02:07 +0100
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <1181760295.588129.1550528380134@email.ionos.de>
 <20190219105941.GB22999@redhat.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <8bc117ea-e504-06a6-dca6-6cbf375cf98f@i2se.com>
Date:   Tue, 19 Feb 2019 18:02:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190219105941.GB22999@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:7zjBOuO/SFTcLAmBhEOQt0fcVyhqaJK2EiJPzDBrfXxC5xoyc79
 XxIrF28CApbsesHK7WEfuniodROdCe5yYTr+mzMZ0r9dceuS2ZHhLkESYIjB8ALf2BL7ZBW
 havzKvV7GVHkYnxlOAgnGp5ki72g65pdoMxMpq0qEbDyFhH9II5YsIyqXv71yfZ7K/C1KIe
 tVegk9rZgCIYCv07e+eEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:mXq9NyPuXh0=:3PUtlSfiaRMl5j6BZZaLY9
 y7XLy3oZ3auut64C5Tr0LibhG2sEI2XYy1DCVYU6SVJAR62yQV9U4PaG1XiLM3Q8YcV7zG5Id
 kfBy+MXsaelou+fZnFxPnzFSR/AZx4Z5BFVz1O3BaGp7Lh0pjvFeTT44y4IPYULPbS1wTZBdm
 PDFY11ig7xQ/3b/Govz3Sd9BOzEE3uIHeTRxw4dy4WYJ3eRk1Kzt8QGq8keA1rrdO6rqhPh/c
 LItbgepd8KLFDMQG6abGip6eUeqBXy1mYPokK9lmwtpz0Js1047r9v1hRn0alunyuRJHD5lgK
 +dDdoeidw17qlnWrU1Fgr3wreks9OGO9nRNKTHTpL3a+hgi3S3DqTxLTNRgYOxHA8zwS78zte
 Kyr60Ph2Ow2YFLRzZPN0SJFU+ilutd3hHmJgy5JDg+dsUMVRDHrJfiCZUdhqbgOqeC/zMNZjl
 UdKXn6kzsTHUBZeMlW5S2dXyNkcrzAORXo7XBumqRG20/6bWoMv7oAq7ve7er4b9yjk5EvcEa
 vNysX6fgzQ7Pas2AklNS7ZAe1yAXvzY4ycszSabFDvJps9nP7yT0UGI714aJ8+ghB/GJ+pTKw
 x4Wl+8B4OP2xv+Zn5nBmIOuLtZRgUAA1ELk8e39+xwKpfh5vkJazCSqKEocwY8babfE9Hw1Sr
 EZc1Zcl69BM9TY1IVd3eRzvEBWRc+iHi9djtGHElWr8smpRPg3WDGV1jTpa+Oasw3GuG1n72y
 jR59mSz5Yo3YYChdDRWJ5if0XiFIgYoVBMK7Pt7Q+o9kRtr2z/iRLCx2pOI=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 19.02.19 um 11:59 schrieb Stanislaw Gruszka:
> On Mon, Feb 18, 2019 at 11:19:40PM +0100, Stefan Wahren wrote:
>> Hi,
>>
>>> Stanislaw Gruszka <sgruszka@redhat.com> hat am 18. Februar 2019 um 14:52 geschrieben:
>>>
>>>
>>> On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
>>>
>>> Sorry for being inprecise. I was talking about the branches not the exact tags. I tested 4.19.23 without luck.
> In github link you provided someone report mt76x0u working on 4.19 with
> dwc_otg with disabled FIQ irq, so perhaps this is due to bug in dwc2
> fixed in -next but not backported to 4.19.
>
We need to consider dwc_otg (out of tree) and dwc2 (mainline) as two
different drivers, which has been maintained independent over years.

I think it would be interesting to see how dwc2 behaves on a different
ARM platform. Currently we cannot say this issue is specific to dwc2 or RPi.

Stefan

