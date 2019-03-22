Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81334C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 15:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 598E22183E
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 15:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfCVPnP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:43:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45527 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfCVPnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 11:43:15 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1h7MK8-0007b4-9J
        for linux-wireless@vger.kernel.org; Fri, 22 Mar 2019 15:43:12 +0000
Received: by mail-pf1-f197.google.com with SMTP id b11so2685311pfo.15
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 08:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=ZT95ejpZB/nAzLIsHEY8bJSSlmRzLglcfI9XeGhvcBs=;
        b=crGKRoIm93e7KtVrHXhAscQ89N+qi2Ou6vIpqaat82Q5IUehIDZfggrWPbTGu3qT9u
         o8yqdg3f15Q9xx0FCHdml8OMMVjA1w5kJ8ilLqZp3Dq1tCoeDYKvEQntcJOoyk4UUt1G
         PA0EqOEmW5xyfauDbrJvzLO54BXRLz6LdbPZ70VoSGJITZDnHo/0O5Dct87yeT+dxeRT
         RUPGOOX8VkEnw4iIQzF650XWg+ePbStWZBOdQWWJe/9t4za3ddLVbXxswQjEQ/qq8oHo
         ltybCphl1fV9Qr/E2xRoqVVDNOC+dPyxwSCXnRo/LODO8wq3daiXsaDOIDGcF/0wfR+J
         8HBA==
X-Gm-Message-State: APjAAAWfq42kJJ+jfALnoCRsldvvUMJMtcUo1Gat0UmTCtY81hSAhSMI
        DqV4r9uORaPm7aAd4GxJujWCxC2t+7bppGEuPBnrG9Df3B4nqS7jSbmJuG/n7I/O+fl6MnBhzcK
        nOuQ/JjU0shRunwHjh9ros5/DwiOcj2DBm49Z4e1bT4H7
X-Received: by 2002:a63:c06:: with SMTP id b6mr9603998pgl.440.1553269391029;
        Fri, 22 Mar 2019 08:43:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyBTn3uXuCiGycQO0qUVFXAffWyOfFAxnVsyVm+XrH3icalSPJL5hvBYbOiNRDkMQp4JZlK2w==
X-Received: by 2002:a63:c06:: with SMTP id b6mr9603983pgl.440.1553269390766;
        Fri, 22 Mar 2019 08:43:10 -0700 (PDT)
Received: from 2001-b011-380f-14b9-3482-cd23-7832-626c.dynamic-ip6.hinet.net (2001-b011-380f-14b9-3482-cd23-7832-626c.dynamic-ip6.hinet.net. [2001:b011:380f:14b9:3482:cd23:7832:626c])
        by smtp.gmail.com with ESMTPSA id k22sm10563131pfa.84.2019.03.22.08.43.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Mar 2019 08:43:10 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: Ath10k on XPS 9380 regularly disconnects
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87pnqknonc.fsf@codeaurora.org>
Date:   Fri, 22 Mar 2019 23:43:07 +0800
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        Stephan Fabel <stephan.fabel@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Transfer-Encoding: 8bit
Message-Id: <8ACA9157-127E-43B8-ADD0-28D9EBBCEEB0@canonical.com>
References: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
 <87pnqknonc.fsf@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

at 01:05, Kalle Valo <kvalo@codeaurora.org> wrote:

> + ath10k list
> - netdev & linux-kernel
>
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
>> There’s an issue that ath10k disconnects at regular basis [1], on
>> Linux kernel 4.18.
>>
>> Unfortunately I can’t reproduce the issue on XPS 9380 at my hand.
>>
>> Is there already a fix in upstream kernel?
>
> I'm not aware of any fixes related to this. Is this a regression? In
> other words, is there a known version of ath10k or firmware which didn't
> have this problem?

We know this issue happen on kernel v4.15 and v4.18, but kernels before  
v4.15 were not tested.

The issue happens with Google Mesh, which has 802.11ac capability.

I haven’t been able to reproduce the issue with an 802.11n router (yet).

Kai-Heng

>
>> [1] https://bugs.launchpad.net/bugs/1818881
>
> Relevant information from dmesg:
>
> [   19.346810] ath10k_pci 0000:02:00.0: qca6174 hw3.2 target 0x05030000  
> chip_id 0x00340aff sub 1a56:143a
> [   19.346812] ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1 tracing  
> 1 dfs 0 testmode 0
> [   19.347136] ath10k_pci 0000:02:00.0: firmware ver  
> WLAN.RM.4.4.1-00132-QCARMSWP-1 api 6 features wowlan,ignore-otp,mfp crc32  
> 79f4db86
>
> [...]
>
> [77451.338339] WARNING: CPU: 4 PID: 0 at  
> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>
> [...]
>
> [81254.857667] WARNING: CPU: 1 PID: 0 at  
> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>
> [...]
>
> [81390.186167] WARNING: CPU: 2 PID: 0 at  
> /build/linux-hwe-9KJ07q/linux-hwe-4.18.0/drivers/net/wireless/ath/ath10k/htt_rx.c:46  
> ath10k_htt_rx_pop_paddr.isra.29+0xd9/0xf0 [ath10k_core]
>
> -- 
> Kalle Valo


