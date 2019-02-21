Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48D5C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83B5D2086C
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:59:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UgX7/LlU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbfBUI7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:59:23 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45982 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbfBUI7X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 03:59:23 -0500
Received: by mail-yw1-f66.google.com with SMTP id d190so10338819ywd.12
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 00:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uS1o8b7rmJDQ0tSv971n154Wq0CFtZqnAM8OAwIPhfA=;
        b=UgX7/LlU80xk0+xxfKc40jZExrbQOsqccnAXd1enJYt6nbokcsm3enlYFf/rKM0huK
         tt3KQs7UYs3+8e22cwjlVXrewvEP12LZZJ9TpZimlH0fe1r8bXHgHfjLeVZcUPsdrB4T
         OvrOCCg0yvnQ58kePgVuLEWhUdW3hUr7ZdKXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uS1o8b7rmJDQ0tSv971n154Wq0CFtZqnAM8OAwIPhfA=;
        b=d2zAlRdD4AmOkFbNptX01157aroUD60yCHAV6IB+SjoFpLUHG9VIgBYa0Blf0Rm+O/
         ptE7TY+wxHNxczH8IH0pQT5PACsFsi9mC1XhAbdkMOZvg2efDlWLGkXoZcOJ/cKz/7/A
         ZNVYEd63NMSojBUBAdMlA8jvrBzlFQWrPlalycNeL6IBpsIkEX4oZTfZzucvfURnrKp6
         SQ9Ex8A3mlLS5ZypctrXHv3m7onzPKpkuUanTpJaZT+2uLYsy6lsTj/2araubeZpLVPC
         /FyJypmRHIH/7wCZx7BJfIgsRmq1tn0lnPuPCMrFvT/+eJH9HX2YD/kllJ+lvf7UAZqv
         4mqw==
X-Gm-Message-State: AHQUAuY8EzbMBQJ8XKz/L4ZMzEWAHtaxD1PC6h1cJMKWmM8aJ59AbBwu
        2QakqXJ/aukWZ1k76KUk9p/1Sw==
X-Google-Smtp-Source: AHgI3IblXoVMW4rbStXGRG2q8ly4+EDfwwUVbNrqP7btFBt18Ij7T31EtXSZKkz18mGfNCzMTeStmw==
X-Received: by 2002:a81:2548:: with SMTP id l69mr31361899ywl.397.1550739562125;
        Thu, 21 Feb 2019 00:59:22 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id b7sm9098344ywa.86.2019.02.21.00.59.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 00:59:21 -0800 (PST)
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20190220103047.8960-1-zajec5@gmail.com>
 <CACna6rwwDN6svzWMGbxYXDp5CN8C=A=fV224QcfoLcACQQgLDA@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <92e8bf1e-3be9-96f2-93e9-ac504a609929@broadcom.com>
Date:   Thu, 21 Feb 2019 09:59:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <CACna6rwwDN6svzWMGbxYXDp5CN8C=A=fV224QcfoLcACQQgLDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/21/2019 9:01 AM, Rafał Miłecki wrote:
> On Wed, 20 Feb 2019 at 11:31, Rafał Miłecki <zajec5@gmail.com> wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> While experimenting with firmware loading I ended up in a state of
>> firmware reporting shared RAM address 0x04000001. It was causing:
>> [   94.448015] Unable to handle kernel paging request at virtual address cd680001
>> due to reading out of the mapped memory.
>>
>> This patch adds some basic validation to avoid kernel crashes due to the
>> unexpected firmware behavior.
> 
> For a reference for the further hackers. That has been caused by a
> BCMA_CORE_SYS_MEM core on my BCM4366/4 not being up.

Thanks, Rafał

Does that happen all the time or in some specific scenario. Anyway, it 
seems like we need to add a check in brcmf_chip_sysmem_ramsize() and 
bringup the core if needed. Although, I am curious in what the state the 
other cores are at that time. Might need a chip-wide reset.

Regards,
Arend
