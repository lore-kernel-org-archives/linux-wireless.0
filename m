Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651A3C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 09:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DFF020896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 09:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbfDAJKp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 05:10:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53548 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfDAJKo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 05:10:44 -0400
Received: from mail-pg1-f198.google.com ([209.85.215.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hAsxm-000479-Se
        for linux-wireless@vger.kernel.org; Mon, 01 Apr 2019 09:10:43 +0000
Received: by mail-pg1-f198.google.com with SMTP id h15so6991822pgi.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2019 02:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/JzSCMvmiL+kBWxi1Lm3yRodlhHf7IFU9b0+sbPGsp4=;
        b=TKfA3NeD3SknKmzs2VPAlc0ylneU4FlFUYk0Un3MWirDbkggUKWpv0c9Cwt5Fz9g8+
         +FkLutIUKXPpcHnVw0+XpQ+2NHSnOzAzFVMB/qsPWnA/PQBP9vdHIk9nMnYWRy6n73cz
         BbOvg/xiHume/yCP5zD3fvOfrWJhqJ6QO/WXkmnFw9lhjLug8jttdJZqfPmPaFMaole4
         H0ml30KPJOttxigOI5/kCLYNEs3JVgtGgbK1cNZO03w1nd7Fa/iPKLmZsGXN543NFtxp
         J9SH/2xGItIsBdz5cuO97Z15ZFVmBsswFzBxUY8EK/OMHCRpvjTShEFkAFZPIutLqV6z
         U9wQ==
X-Gm-Message-State: APjAAAU2rMyXZqe5AHOzggVJCRq7pu8bLCQtXeWisqweGoyTtgj/JrdF
        TqTyzBsQ1N4t8d7nl7meUZ3e1NNrA/DYUoR/A5BStezBBwR/V3ljcjeY7uULSJCfhWZXbGSAVAX
        2SO3qvMz93V/5HmlrVHjvV7JjHb2M6VY2S0I/iQX6qw7c
X-Received: by 2002:a63:c34c:: with SMTP id e12mr5315292pgd.279.1554109841607;
        Mon, 01 Apr 2019 02:10:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwlnTZq6JLIqBu4VZxAdgP9MDBXFVBi+p5XTqfzpNaL+bdtKjgmAgxQMvbfZiu3Cil9eemNKw==
X-Received: by 2002:a63:c34c:: with SMTP id e12mr5315271pgd.279.1554109841330;
        Mon, 01 Apr 2019 02:10:41 -0700 (PDT)
Received: from 2001-b011-380f-14b9-7d2a-691a-27a5-ff10.dynamic-ip6.hinet.net (2001-b011-380f-14b9-7d2a-691a-27a5-ff10.dynamic-ip6.hinet.net. [2001:b011:380f:14b9:7d2a:691a:27a5:ff10])
        by smtp.gmail.com with ESMTPSA id n82sm15824287pfi.63.2019.04.01.02.10.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 02:10:40 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: Ath10k on XPS 9380 regularly disconnects
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <877ece2kaq.fsf@kamboji.qca.qualcomm.com>
Date:   Mon, 1 Apr 2019 17:10:38 +0800
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        Stephan Fabel <stephan.fabel@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Content-Transfer-Encoding: 8bit
Message-Id: <30006E79-02AE-40E7-9F55-5F5C29068E0D@canonical.com>
References: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
 <87pnqknonc.fsf@codeaurora.org>
 <8ACA9157-127E-43B8-ADD0-28D9EBBCEEB0@canonical.com>
 <BD07B681-0083-4537-87D2-099F7152C51F@canonical.com>
 <877ece2kaq.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

at 16:37, Kalle Valo <kvalo@codeaurora.org> wrote:

> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>
>> at 23:43, Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:
>>
>>> at 01:05, Kalle Valo <kvalo@codeaurora.org> wrote:
>>>
>>>> + ath10k list
>>>> - netdev & linux-kernel
>>>>
>>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>>
>>>>> There’s an issue that ath10k disconnects at regular basis [1], on
>>>>> Linux kernel 4.18.
>>>>>
>>>>> Unfortunately I can’t reproduce the issue on XPS 9380 at my hand.
>>>>>
>>>>> Is there already a fix in upstream kernel?
>>>>
>>>> I'm not aware of any fixes related to this. Is this a regression? In
>>>> other words, is there a known version of ath10k or firmware which didn't
>>>> have this problem?
>>>
>>> We know this issue happen on kernel v4.15 and v4.18, but kernels
>>> before v4.15 were not tested.
>>>
>>> The issue happens with Google Mesh, which has 802.11ac capability.
>>>
>>> I haven’t been able to reproduce the issue with an 802.11n router (yet).
>>
>> Do I need a special WiFi router which support RX reorder to reproduce
>> the issue?
>>
>> It's introduced by commit c545070e404b (“ath10k: implement rx reorder
>> support”).
>
> I don't understand your question at all.

As far as I understand, the issue "failed to pop paddr list: -2” happens  
because ath10k_htt_rx_pop_paddr() fails to find skb in skb_table, hence  
trigger the warning.

Those function are introduced by commit "ath10k: implement rx reorder  
support”.

Since I’ve never seen such issue on my WiFi routers, while it happens to  
Stephan frequently, so I want to know if the “RX reorder support” is a  
feature that’s only supported by certain WiFi routers.

Kai-Heng

>
> -- 
> Kalle Valo


