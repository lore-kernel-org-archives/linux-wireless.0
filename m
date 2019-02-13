Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6945FC282CA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 07:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD7221904
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 07:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389807AbfBMHFY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 02:05:24 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:37399 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389744AbfBMHFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 02:05:23 -0500
Received: from oxbaltgw08.schlund.de ([172.19.246.14]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N17gy-1h46Rk38WY-012YMH; Wed, 13 Feb 2019 08:05:14 +0100
Date:   Wed, 13 Feb 2019 08:05:13 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Message-ID: <1262387327.433113.1550041513349@email.ionos.de>
In-Reply-To: <20190211155726.GE8128@localhost.localdomain>
References: <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
 <20190211100405.GD3467@localhost.localdomain>
 <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
 <20190211110635.GD2293@localhost.localdomain>
 <8a996497-ed69-4087-2c37-7f73633cbb4e@i2se.com>
 <20190211151055.GC8128@localhost.localdomain>
 <500c0d4a-611a-1b00-5ea4-7368e5e9f1e9@i2se.com>
 <20190211155726.GE8128@localhost.localdomain>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:Is3DFfFL30il0WWcjMRhne/XhTQhOoRftXbbehhsgGGsYbkT1Up
 TDN8MJDPI0PXuwaQhBOacuV0bBjGk2Inu0XAqDlbUeCUT10fEpyBPB/gGUdk7VcCUPThiL+
 YtzbpU+tcAVkrTZqBjwcTaHJYlCIVlxPvPkQRu7EJA0S7pfwqHUOqGLXN4tPi3xXRXvC32u
 N89ALwNvMDIhVwNl9AcEw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:7CWxAfUf0r0=:Z7OdWHy9HapBkrc3sK2zy7
 lZGVslyjNddAanqI3vWhOlojnf5crMsrntLe9mXRPeeJz7aPdVNYYV5fjCMFZMoHpH4XKGP45
 sSDtgHHViHB8I8lrTFAtPOrslyXJDgaZNt0xmHtzKsPyxX3HkQlzoMDAkG0Tb33mAGJ4Tx1vp
 4fRooj+JhrgwOF5qbhKT+dZYpdRbUBhslpySlBIWfiqca2kqyct1e1crq8A+oikhydpbil1g9
 r4PJX467CYiDruAJ2A+WO5J/ExR/MSbXr1e+yjnTfjElO4tT4f8QFnP3JFTpBeMWWiWpVpmo5
 vHlsgDHItcnom+CpjkJbMIwOdqjqX8Rn/QGT7OwfCIsmuJZxs0QUZZvKTUn69fady7d14qtt/
 Lgts0zu70mmLw1/ORLcKtBqmVzgQARay20dcNVVY8unS4ILGXflK+1qPuP7HCngT4NeQLQQuM
 iu68FrJRbxT9hZpluVxzMw+jiGQbEnJjlmFos4ZEBBhbCM5+/XGG3XQc5QXL0PyV0dkMcbZB5
 qXP9cv47ueoAPpD0iDdolRQu5+muOnc1fU6f8LUtWDa1swl9lhENJlpd85w3bZDgxbNdQNrsU
 RY7Ty74KgjkVig6/Rn3IisbBEM5itPpeTj386ek3N58E6RjimUDI5IYRRHExQJxa6cs7fnk0C
 DUA+G6lgtPZRWnAJuBLGfcIhjlJZ6U47IYdYfbH9EiYMbaaMzzcd5NIyDW90GafGqABEyxaQY
 vAYiNUzcG7C562I5gxTlyZYMk2fZDlq9/x/gYGJpZAQcz2LEDcrj/o1faDw=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> hat am 11. Februar 2019 um 16:57 geschrieben:
> 
> 
> > 
> > Compiling the mainline kernel with arm/multi_v7_defconfig it works.
> > Using the same kernel but with arm64/defconfig doesn't work. But i don't
> > think this is a 32/64 bit issue. The arm64 defconfig is much more
> > complex (e.g. enables more IOMMU stuff).
> 
> thx for the clarification :)
> 

i was busy to enable the mt76xx wifi driver in my build system. Usually i handle this via scripts/config but i didn't manage to enable the driver. Finally i gave up and enabled it via defconfig patch.

Here are my test results for Raspberry Pi 3 B+ (without any additional patches):

multi_v7_defconfig 5.0.0-rc6 -> firmware timeout
multi_v7_defconfig next-2019-02-12 -> firmware timeout
arm64_defconfig 5.0.0-rc6 -> vendor request 07: -110 (timeout)
arm64_defconfig next-2019-02-12 -> vendor request 07: -110 (timeout)

Shame on me for the wrong result before (assume to not properly cleanup the kernel modules on sd card). So there is no config option in arm64_defconfig which breaks mt76xx.

I will try the recent patches later.

Thanks
Stefan
