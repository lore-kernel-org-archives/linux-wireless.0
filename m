Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12851C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEEB220880
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:31:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YjBahqov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfBUKbB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 05:31:01 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34909 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfBUKbA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 05:31:00 -0500
Received: by mail-yb1-f195.google.com with SMTP id n84so6982768yba.2
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 02:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gFY671WqJZVp7oRwSiO8pbWq2UGsLwDdtMRJL6V6TQk=;
        b=YjBahqovSudlW9E2st9CXfpjtaD5vhrorpKvcxzlSSO2gyS3B5tqi2jKRhMgZQ0ALO
         EUGgW1kjlwlyDAPwWaNpMjFCtMY7WsVs4N7yKKHCiYiJULrsz0sEKOWDjMo0uFH2I4Zk
         Cj0ZVw5BVZ1O8Ek7Dj2b1HsgVH2NFA4kFhmpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gFY671WqJZVp7oRwSiO8pbWq2UGsLwDdtMRJL6V6TQk=;
        b=q9fOBx1Mog5ceLdb6Hbwmw3A0bY8qWv1J6h+oL+EuUkc2XLD6WQ24hSebcyK/DLpQQ
         MZUgxxznfUYN9dWobx+qrIhp7vcrv8/Pz9uYb2NuLqvBJmd0kumn6KkuaerQCX6tbwNj
         IW/xcFXBSptUlUi9i+NLJVnxAZQdi/Qkq8HPPFyl6Ry6PG0p+gmYJAO0gAwLDm8uu3nT
         V/j7/3jco8+J57DjeCb7ylIT4Rwqse2WySsQn0XRDSeiyfCFVjiN9IwoOwi906wescZM
         N7bm1YgLtuQVhddBd/dAcu2tWifkD1FLhNFydEbJmxlEJ/jGztL+O4Ok9Sdi2YRta1He
         7H1A==
X-Gm-Message-State: AHQUAuYq2MMxbys/XfRzeg22O6tOFu/PsI4Jpr0LKK1it+v4OPoWjtAv
        xlJAHXakoDzws+OIkHWnpfr3pg==
X-Google-Smtp-Source: AHgI3IbRK33gsYP7TZw+NDCrHNL8eZUuj1mIDb7knMYNthCyi1kaFVH1SSEwJegW3MdYcrpPDGzE5w==
X-Received: by 2002:a25:582:: with SMTP id 124mr25043952ybf.118.1550745059233;
        Thu, 21 Feb 2019 02:30:59 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id z186sm2706740ywf.17.2019.02.21.02.30.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 02:30:58 -0800 (PST)
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190220103047.8960-1-zajec5@gmail.com>
 <CACna6rwwDN6svzWMGbxYXDp5CN8C=A=fV224QcfoLcACQQgLDA@mail.gmail.com>
 <92e8bf1e-3be9-96f2-93e9-ac504a609929@broadcom.com>
 <CACna6rxXJWwysJTauSKAb6rLeaXi1CBZSGcFNA5Nxn0ncQnG4Q@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <48bb6db6-31c0-65e6-551f-69bbd056df93@broadcom.com>
Date:   Thu, 21 Feb 2019 11:30:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CACna6rxXJWwysJTauSKAb6rLeaXi1CBZSGcFNA5Nxn0ncQnG4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/21/2019 10:27 AM, Rafał Miłecki wrote:
> On Thu, 21 Feb 2019 at 09:59, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 2/21/2019 9:01 AM, Rafał Miłecki wrote:
>>> On Wed, 20 Feb 2019 at 11:31, Rafał Miłecki <zajec5@gmail.com> wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> While experimenting with firmware loading I ended up in a state of
>>>> firmware reporting shared RAM address 0x04000001. It was causing:
>>>> [   94.448015] Unable to handle kernel paging request at virtual address cd680001
>>>> due to reading out of the mapped memory.
>>>>
>>>> This patch adds some basic validation to avoid kernel crashes due to the
>>>> unexpected firmware behavior.
>>>
>>> For a reference for the further hackers. That has been caused by a
>>> BCMA_CORE_SYS_MEM core on my BCM4366/4 not being up.
>>
>> Thanks, Rafał
>>
>> Does that happen all the time or in some specific scenario. Anyway, it
>> seems like we need to add a check in brcmf_chip_sysmem_ramsize() and
>> bringup the core if needed. Although, I am curious in what the state the
>> other cores are at that time. Might need a chip-wide reset.
> 
> It happens after brcmf_pcie_reset_device() which is probably a 100%
> expected case ;)

Did not check what that function exactly does, but could be expected.

> Normally brcmfmac does not call brcmf_pcie_reset_device() between
> brcmf_chip_sysmem_ramsize() and the brcmf_pcie_download_fw_nvram() so
> it was only my hacking that caused that issue for me.

Ah. Can only wish you happy hacking then ;-)

Gr. AvS
