Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D74C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:52:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F512086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 09:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BYZhIAgN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61F512086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728011AbeJLRYU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:24:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51542 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeJLRYU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:24:20 -0400
Received: by mail-wm1-f65.google.com with SMTP id 143-v6so11625874wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=RET5V+kXl4vsXgbisfjPMc74In5nUWQoMr+QjpOfILw=;
        b=BYZhIAgNQQEm695XhDpAYxcBCEGqDK4me0ALqt4MU37sYbUZJindkChuLQEPZN1Sko
         VXNiMEzO859jA6ySI58sGzjp5f2XhNg0wTrFplEbK/RRSk5lDWIi0YEjfDe3oH15n7zL
         YS6F2yhvSYN8LmOcQx5aWVLx79mLVRWscKBCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=RET5V+kXl4vsXgbisfjPMc74In5nUWQoMr+QjpOfILw=;
        b=mM9avGrp3vBNTYd3BIOpQAA5aPoRJn/29+elSWuYhXdxolUVKAy4qKc3HSlXvvXlWU
         kw2NHSqaxYJBrQwHH/2d+NwwWClI6ZR2grwLB7lRdtU0Q4RUFQilc1qx/D2Y2uUtYket
         sgxbxne3etR8MS/erySq4dbe618+jwc4k+mPNMqelecCMHZZWHejoPz7xMbZtD4b4vT+
         EofxHHN48EtV9ridzFsK0tYvenACCAEssOT5ca6avdi/xfZz7JFUnfaCGgnIgI+z6fNw
         fNFJgRyfhVEEkgC0xSUuGPTnwn00x11xCdy/aJKkHaZvlbv8PqE7+9edpJJsub5KnY14
         gVVw==
X-Gm-Message-State: ABuFfohDG/hypEl5pSGlojNzQnn/yvgKHzrpeSUZkOrUMERkBbr9T0px
        mnQP/mNn6GcMT0jbA/R0dJLaHA==
X-Google-Smtp-Source: ACcGV63nUHHmmMOPKyQRYHAhpxnvMA5zNKG+wMtujDVogXWAByMcJxLDdMkKpzWJ3yXT3Q2OkWhmvQ==
X-Received: by 2002:a1c:8b94:: with SMTP id n142-v6mr4817012wmd.38.1539337961975;
        Fri, 12 Oct 2018 02:52:41 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id b128-v6sm928256wmh.22.2018.10.12.02.52.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 02:52:40 -0700 (PDT)
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     =?UTF-8?Q?Christoph_M=c3=bcllner?= 
        <christoph.muellner@theobroma-systems.com>,
        Franky Lin <franky.lin@broadcom.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
 <CA+8PC_dkJAPR2C0DsOWRb__RrijbZZ43MM1gtKGjsMxdTGwsZQ@mail.gmail.com>
 <fabdecc1-f032-789e-058f-2c62442b12c0@theobroma-systems.com>
 <C9DFBEBB-4481-4CBA-AE10-92A20C815D4F@theobroma-systems.com>
 <f7645f53-3e63-c888-c4a7-ece11655849d@broadcom.com>
 <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
Cc:     "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e481cbcb-6cfd-b534-eb67-c2e8d0a7761e@broadcom.com>
Date:   Fri, 12 Oct 2018 11:52:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <b97f6b6c-aad9-8008-aab3-bf1ab1c1f2a0@theobroma-systems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/12/2018 10:59 AM, Christoph Müllner wrote:
>
>
> On 10/12/18 10:00 AM, Arend van Spriel wrote:
>> On 10/11/2018 6:04 PM, Christoph Müllner wrote:
>>> Hi Franky and Arend,
>>>
>>> today I could get a SDIO Wifi module, which includes a BCM43455.
>>> I was able to get this up and running without any issues with the
>>> brcmfmac
>>> driver and a 4.19 kernel. For me that's enough evidence to say that
>>> the SDIO
>>> driver works.
>>>
>>> However, the BCM4359 still does not work.
>>> It times out in brcmf_sdio_firmware_callback(), while enabling func2.
>>>
>>> I've inserted tons of debug log outputs in both, the DHD driver and the
>>> brcmfmac driver, and compared them. Differences which I've found so far
>>> are: a) brcmfmac strips out whitespaces from nvram contents and
>>> b) DHD downloads firmware first and brcmfmac downloads nvram first.
>>> I've adapted the DHD driver to behave like brcmfmac in both cases
>>> and it still works.
>>>
>>> I've increased the timeout for enabling func2 from 3 seconds to 10
>>> seconds,
>>> but that did not help.
>>>
>>> Any ideas left?
>>
>> When enabling func2 fails it generally means the firmware crashed. I am
>> not sure if the patch below works to get console information. It might
>> show up empty or simply fail if firmware did not fill shared memory
>> info, but it may be worth a try.
>
> I added the patch and additionally added debug output for all error
> cases in the two called functions. Here's the output:
>
> [   14.746092] brcmfmac: brcmf_sdio_firmware_callback: enable F2: err=-62
> [   14.767523] brcmfmac: brcmf_sdio_checkdied: firmware not built with
> -assert
> [   14.778777] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> [   14.789220] brcmfmac: brcmf_sdio_readconsole: brcmf_sdio_readconsole:
> bus->console_addr == 0!
>
> Do you have an educated guess, what causes the firmware crash, when
> being loaded via the brcmfmac driver?

Let's look at the firmware+nvram you are using. Can you do:

$ strings brcmfmac4359-sdio.bin | tail -3

and send the output and the nvram file.

Regards,
Arend

