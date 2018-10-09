Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D3EECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 197E7213A2
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eNBqJZql"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 197E7213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbeJJCbV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:31:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46683 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeJJCbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 22:31:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id n11-v6so2930618wru.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 12:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=bMTdBFo8J38VHZPRPcajIt+3bcuve/xBzOLN44PkFiI=;
        b=eNBqJZqlRkguoW//2S5jpioRlYDOvswRKGmGSCuR2i0OyequJW6rbjCdamA5INK+Jr
         gxs2fXn1Upc0hbCPjkgxeQsdvNa2c9bfRCo8Dz3aoIY9VSmc232oLFUGbRERWn3nIMok
         2oIYoTvO0jbNBJ5SHwVAbwWwBRwLgiTxLzKnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=bMTdBFo8J38VHZPRPcajIt+3bcuve/xBzOLN44PkFiI=;
        b=WZpvdTFPUjz9nwXUIBPkuPVhA6zQJuC9c+tuyD7bfW9RlGQJUo+lSCdf++OJaq4kKS
         r5dbU+l8YKnAxFZwnNBI/nBfHt79HS5CKRuOR2L6zoXD2Fj+UFBA9CRs8FFVU+MBtWwc
         P7WBBL+atAHs5c9b5anuOV3fZLq34mJxcREJrVuecwM8L19SPgDq9PrvbDiFJFHwwDYR
         coWobucBBzmAQoQZPgjts5qL9poah+cbSaXCjyCUbzj0dHLoK8a7uS+ryr25Bgqh72gc
         qXOelzVlRUy75KclBWW4DHew5/KTLQqFO+E+TsU4DA7zh1ixcHzJa5XWmLv637y1H0on
         oaAg==
X-Gm-Message-State: ABuFfogLEYy+oXjoi2tQ12JiYldcqSCQGMAAe8IgjPQncWa4t2BQ4C8o
        6Uvm+fubcWm4br09HPEdTr6W+A==
X-Google-Smtp-Source: ACcGV62rR5tK9mjc2lA6A6lvREU9YXGG3eIVJAHe01ekrCiqNWjbjPYMhK1KKfvl0strU3Fja3gIbw==
X-Received: by 2002:adf:9464:: with SMTP id 91-v6mr21475429wrq.200.1539112374176;
        Tue, 09 Oct 2018 12:12:54 -0700 (PDT)
Received: from [10.177.251.77] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id e14-v6sm18096040wrs.69.2018.10.09.12.12.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Oct 2018 12:12:53 -0700 (PDT)
Subject: Re: brcmfmac with BCM4359 on arm64 (RK3399) and SDIO
To:     =?UTF-8?Q?Christoph_M=c3=bcllner?= 
        <christoph.muellner@theobroma-systems.com>
References: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0f42282d-c579-bb4f-8931-87bb91c904e2@broadcom.com>
Date:   Tue, 9 Oct 2018 21:12:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <5C44048D-0676-48E6-9AA3-F327839F13E5@theobroma-systems.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 8:10 PM, Christoph Müllner wrote:
> Hi Arend,
>
> recently I got an SDIO module, which includes a BCM4359.
> I tried to get it up and running via the SD card interface
> on a RK3399 SoC and succeeded in doing so with
> bcmdhd.1.579.77.41.x and a vendor kernel (based on Linux 4.4).
> All that was necessary was configure BCMDHD to run with
> in-band IRQs and use a GPIO as gpio_wl_reg_on.
>
> Since I can run a mainline kernel as well, I gave it a try and
> tried brcmfmac on Linux 4.19-rc7. As the BCM4359 is not in
> the list of supported SDIO devices, but is supported USB device,
> I've created a patch (attached), which adds the support for that device.

Okay. However, I should say that there is no BCM4359 USB device. 
Regardless the patch looks okay.

> Additionally I've patched my DTS to include the WL_REG_ON
> pin as part of mmc-pwrseq-simple's reset-gpios and added
> a bcm4329-fmac node in the mmc node.
>
> During bootup I see messages from brcmfmac, which indicate
> that the BCM4359 has been found, but loading the nvram file
> continuously fails:
>
>> [    5.993741] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4359-sdio for chip BCM4359/9
>> [...]
>> [    7.987167] brcmfmac: brcmf_sdiod_ramrw: membytes transfer failed
>> [    8.008715] brcmfmac: brcmf_sdio_verifymemory: error -84 on reading 2048 membytes at 0x0025f1f0
>> [    8.021182] brcmfmac: brcmf_sdio_download_firmware: dongle nvram file download failed
>
> That -84 means EILSEQ, which is the error value, which represents
> a CRC error during SDIO data exchange (returned by the function dw_mci_data_complete()
> in the MMC driver).

Whenever I see -84 my suspicion are about power-supply for the chip. 
However, it may also be the mmc host driver not adhering to so-called 
"card busy" indication, which is in the SDIO spec.

> To address this, I've reduced the clock speed (in several steps) to 400 kHz
> (and verified the clock signal on an oscilloscope), but the issue persists.
> I've also tried to use Linux 4.14.74, where I see the same issue.
>
> I can confirm that the MMC interface works in general (I can use an SD card
> to host my rootfs).

SD and SDIO are not the same thing. More importantly you have it working 
with bcmdhd on a vendor kernel. So start from there.

> FWIW I'm using the same exact same firmware and nvram file for the DHD driver
> and the brcmfmac.

Noted.

> Do you have any ideas how to debug this issue?

Would focus on getting logs from bcmdhd.

Regards,
Arend

> Thanks,
> Christoph
>
>
>
>
>

