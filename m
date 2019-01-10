Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CB1C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A462214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 09:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfAJJHl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 04:07:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37308 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbfAJJHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 04:07:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so10461611wrt.4
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 01:07:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rjxFRNfxwhbsowv9MH5B+JnN1Y9h4zk2bQzmziOrzuA=;
        b=BvEqdcb6ZNfEPpGXyymS8RVz/p5nQV+iutLFWgun9eJk5E5Q3RRU2SgyAkkMQ49ZBo
         zfIPrr1DasO1ek5PScCCdCzFiWYNAyoO5VtbpHUyudOuktbLnHtAQBIo4LSyZENF4uTX
         deLi2lIOOrYxAXOrJvCWMly5Zaz5xAtpKbB4cJRhjEr3AkVjSvRvgQ2ZkGwjMsJJQEuE
         67QeQaQDu3GdqZm1SL/FGXNFykMFH4Dq04QDbevxLFayHcGRLCZm0gwFYTuRKEqlTCOy
         iCfmBQhsotiYe43H5jsBuy4S35j7oiTOHZjGu/fAFcsklTbqahdfCrro1arvMv00HKWX
         Y1Iw==
X-Gm-Message-State: AJcUukd+2aPzvjou/daxZKEiDIXO9t3FPWsTLLshQ/v1hCCjo1mPrgL8
        CxW7CQczry5kb/Cvx3zxCZNjVA==
X-Google-Smtp-Source: ALg8bN5Qt/v4guEzrShqIRzRdhWdlW+o/iQRY0/TbS4d2laaBNxAxOPfvkUp1dquG8CSBqjTHm4qow==
X-Received: by 2002:adf:9c8a:: with SMTP id d10mr7912909wre.244.1547111259326;
        Thu, 10 Jan 2019 01:07:39 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id p10sm5165249wrt.25.2019.01.10.01.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 01:07:38 -0800 (PST)
Subject: Re: [PATCH v2] brcmfmac: Use firmware_request_nowarn for the clm_blob
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <Wright.Feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        John Van Boxtel <John.VanBoxtel@cypress.com>
References: <20190107133327.9297-1-hdegoede@redhat.com>
 <f2d8d0fc-a42a-b760-6361-5fd390f8eda5@cypress.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <98094412-ef5e-a3d7-04f6-8baea394e127@redhat.com>
Date:   Thu, 10 Jan 2019 10:07:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <f2d8d0fc-a42a-b760-6361-5fd390f8eda5@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-01-19 09:18, Chi-Hsien Lin wrote:
> 
> 
> On 01/07/2019 9:33, Hans de Goede wrote:
>> The linux-firmware brcmfmac firmware files contain an embedded table with
>> per country allowed channels and strength info.
>>
>> For recent hardware these versions of the firmware are specially build for
>> linux-firmware, the firmware files directly available from Cypress rely on
>> a separate clm_blob file for this info.
>>
>> For some unknown reason Cypress refuses to provide the standard firmware
>> files + clm_blob files it uses elsewhere for inclusion into linux-firmware,
>> instead relying on these special builds with the clm_blob info embedded.
>> This means that the linux-firmware firmware versions often lag behind,
>> but I digress.
> 
> Hans,
> 
> Historically the wifi firmware bin would contain all individual customer
> board regulatory data which was selected via OTP (or nvram) at firmware
> boot. This eventually became unscalable because the FW would need to be
> updated for any new customer product and/or change.  Also the table used
> more and more critical memory resources. Therefore, the regulatory data
> was separated into a downloadable unit which allowed the FW to remain
> independent and save on critical (FW) memory resources.
> 
> The tricky thing is that clm_blob contains regulatory data that is
> specific to a board, not just the chip.

AFAIK all the important board specific settings like antenna gain are
in the NVRAM, not in the clm_blob and the clm_blob simply contains
per country settings. But you are the expert on this so I believe you when
you say that there may be some board specific stuff in there, but see below.

> Also the regulatory rules often
> require that a product not be able to be misconfigured (intentionally or
> accidentally). To avoid regulatory violations for our customers and
> general confusion, clm_blob files the matches the hardware should be
> delivered by hardware (board) vendors.

Yet it clearly is possible to create a generic distributable clm_blob
as that currently is embedded into the linux-firmware brcmfmac firmware
builds. Why not split that out and add the generic clm_blob version to
linux-firmware ?

These generic clm_blob files could be added to linux-firmware under:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENCE.cypress

And then the firmwares from can be relicensed under that license too:
https://community.cypress.com/docs/DOC-15932

Which is this 1 line change to the license:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/LICENCE.cypress?id=ba51e861f4444f51e7e83f778575a8146dc514d0

This will allow simply reusing the builds from the regular firmware releases
done at https://community.cypress.com/ to be added to linux-firmware
by interested parties like me. Avoiding situations like the
brcmfmac43455-sdio.bin file being _3.5_ years old which is really bad.

This will also mean less work for Cypress since now the same builds
you are already doing regularly can also be used directly in linux-firmware.

Regards,

Hans
