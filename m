Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07937C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 08:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D387320643
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 08:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbfDAID3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 04:03:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51895 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfDAID2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 04:03:28 -0400
Received: from mail-pg1-f199.google.com ([209.85.215.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hArug-00066h-Qr
        for linux-wireless@vger.kernel.org; Mon, 01 Apr 2019 08:03:27 +0000
Received: by mail-pg1-f199.google.com with SMTP id l13so3433390pgp.3
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2019 01:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=+EoXHLaMdUe5GfFwr3n9pGwo/n1WA/wn+ZuMrfgekbE=;
        b=oy6+QXdMsKbjrYwGMgobvbYzoXx6HOJZ0Oso7PKd8OmjNRHl6NB/2WPvw8xegKJOhC
         kIb5oco9Z+87qq9UnJeUn7EkxIOfl1Ixfn7VX6HZkzyhgIxRsO9EzKUi3h6pjFujmmuD
         1CiaJ8QX6s05L7MWlI6Sz1maEl2kmw3BE6v5gqFRltjZHWlckmz52JggG1y6xv6dDC5X
         feTzF3eGwEMTV3F6XOc3fs/p/ChHKFoWLLVnkJpPkJfVhuIpXxwcDjXqZ+HgyPHjlA+u
         jxAvOFDySCcNZ3AKjqBlysCszejosKwyMKdLOkHREHjXS3rYwz1W5iovueovbfFFW7Ug
         wmJQ==
X-Gm-Message-State: APjAAAXxKRhgorqLWfcF6f97WKr61jhF4T0ijlFuhAv8qRfeKUK64e5h
        44EfIlP7KDCoM+11D8bhcQc5H8Us++cvxAjPnHK5KMXesTEvrrXyAxaZlw6B07C9p9AWxBYtUJW
        9aXe/eTY9shOY056PyWQLGus7ghUyWib2SJx9zalfjONQ
X-Received: by 2002:a62:bd09:: with SMTP id a9mr60463487pff.61.1554105805443;
        Mon, 01 Apr 2019 01:03:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwPp0fl1Az6tR1MLQKKz1EjT1qt3Mep6kwmMevgxVkl04F1Q4l4q0vmGQ/wD9PHpRMF9OoeXQ==
X-Received: by 2002:a62:bd09:: with SMTP id a9mr60463463pff.61.1554105805188;
        Mon, 01 Apr 2019 01:03:25 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id n5sm12236350pgp.80.2019.04.01.01.03.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 01:03:24 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: Ath10k on XPS 9380 regularly disconnects
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <8ACA9157-127E-43B8-ADD0-28D9EBBCEEB0@canonical.com>
Date:   Mon, 1 Apr 2019 16:03:21 +0800
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        Stephan Fabel <stephan.fabel@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Transfer-Encoding: 8bit
Message-Id: <BD07B681-0083-4537-87D2-099F7152C51F@canonical.com>
References: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
 <87pnqknonc.fsf@codeaurora.org>
 <8ACA9157-127E-43B8-ADD0-28D9EBBCEEB0@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

at 23:43, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> at 01:05, Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> + ath10k list
>> - netdev & linux-kernel
>>
>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>
>>> There’s an issue that ath10k disconnects at regular basis [1], on
>>> Linux kernel 4.18.
>>>
>>> Unfortunately I can’t reproduce the issue on XPS 9380 at my hand.
>>>
>>> Is there already a fix in upstream kernel?
>>
>> I'm not aware of any fixes related to this. Is this a regression? In
>> other words, is there a known version of ath10k or firmware which didn't
>> have this problem?
>
> We know this issue happen on kernel v4.15 and v4.18, but kernels before  
> v4.15 were not tested.
>
> The issue happens with Google Mesh, which has 802.11ac capability.
>
> I haven’t been able to reproduce the issue with an 802.11n router (yet).

Do I need a special WiFi router which support RX reorder to reproduce the  
issue?

It's introduced by commit c545070e404b (“ath10k: implement rx reorder  
support”).

Kai-Heng

>
> Kai-Heng
>
>>> [1] https://bugs.launchpad.net/bugs/1818881
>>
>> Relevant information from dmesg:
>>
>> [   19.346810] ath10k_pci 0000:02:00.0: qca6174 hw3.2 target 0x05030000  
>> chip_id 0x00340aff sub 1a56:143a
>> [   19.346812] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1  
>> tracing 1 dfs 0 testmode 0
>> [   19.347136] ath10k_pci 0000:02:00.0: firmware ver  
>> WLAN.RM.4.4.1-00132-QCARMSWP-1 api 6 features wowlan,ignore-otp,mfp  
>> crc32 79f4db86
>>
>> [...]
>>
>> [77451.338339] WARNING: CPU: 4 PID: 0 at  
>> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
>> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>>
>> [...]
>>
>> [81254.857667] WARNING: CPU: 1 PID: 0 at  
>> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
>> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>>
>> [...]
>>
>> [81390.186167] WARNING: CPU: 2 PID: 0 at  
>> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
>> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>>
>> -- 
>> Kalle Valo


