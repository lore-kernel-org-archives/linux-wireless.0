Return-Path: <SRS0=M3au=QJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530FCC282D7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 17:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2271320856
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Feb 2019 17:06:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZW2U3Wja"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfBBRGa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Feb 2019 12:06:30 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42511 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfBBRGa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Feb 2019 12:06:30 -0500
Received: by mail-oi1-f196.google.com with SMTP id w13so8397195oiw.9
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2019 09:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xo8sbkSUeyP3AMS+TeN6fz+rcqQQZNi2Rd9uU80iW3E=;
        b=ZW2U3WjaQoLWSSs24lM2cdJGUpUjkXJZutZcXPaNQPPkha8Kc2AvEGULPkZWU/JmFH
         4gVuLTqNt2LPh7VI5e0ZH3iYSsYZt6DeP5u5KW/TzyvJq23HJ2zXsSam5lAgmqN0D/TS
         8q4ThThepLRNTND/oXx/9LskqIQbl3c1qkXcwpz/jehYDNTtBMdjyKIeXmfZK+0pZSTO
         P9rTOM3ZXGAQ0VKFWPFVsFWGoJ2djkpK8uNgsBDVf2nV5A768BsvZ9Q3r3VPBEX+s9X4
         WnQOgtzogHIPjmRsPnhk8vM22AEsVEeQSnepHOBqiEn+qKubtxy+ZHgQNTW5YxoQ24NB
         r78A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:cc:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xo8sbkSUeyP3AMS+TeN6fz+rcqQQZNi2Rd9uU80iW3E=;
        b=oebU/IDKV1TrR4GdS3ZTZAE/ST7EDpv90CFb3lPR9bBsWSukgRNSKatuRpHe5qUF8I
         OzfPYPMbppp6YQFwGM/Xb/TNogt8Ar8a3HQQnnNdatrw65vMBnSoquzRfzdvj5Pwtsd3
         mKwjd792GeBpxVIadYekz/AK8f/kZvVQ6nw9xhB/gp3upWcDwLu7oO0FomOjl41+YBGh
         Bcl+mIMI/yrTb6YZBmsTQ7wMy0swIskVjEVQ9iEt5cOKLytqfbR6ykYqCLZwNg1D++Rt
         HzQH4nTsG91gV/egbSGAurf5T9+y6pXtkYJYoDoAIWZoTqHu1ukhdmwP2osipaBdQUmw
         Njwg==
X-Gm-Message-State: AHQUAuavSBUNBRNPHZLfhBdQ6Ew058EAvzySeADuR3r+T1WczWsyCi66
        4OMxD0fS6xoLnWZ8leT9URiKkyzr
X-Google-Smtp-Source: AHgI3IaPeIk850IeytjeQnOItjdagsbbFukT+K+40POJuInZiQK7weSWyYztS4Cq40oJnklz7VtIyg==
X-Received: by 2002:aca:4506:: with SMTP id s6mr20737943oia.115.1549127189539;
        Sat, 02 Feb 2019 09:06:29 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h64sm4635590otb.45.2019.02.02.09.06.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 02 Feb 2019 09:06:27 -0800 (PST)
Subject: Re: Compilation error in rtl8821ce driver and possible fix
To:     Francesco Napoleoni <fnapoleoni@mclink.it>
References: <4491429.ZAENLmHWg6@afrodite.mst.cosmic-odyssey.net>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <f9ac33af-0052-cf42-99b5-58212f703d44@lwfinger.net>
Date:   Sat, 2 Feb 2019 11:06:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4491429.ZAENLmHWg6@afrodite.mst.cosmic-odyssey.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/1/19 7:02 PM, Francesco Napoleoni wrote:
> Hi
> 
> A few days ago I downloaded rtl8821ce wireless network driver from endlessm/
> linux repository (master branch), and I managed to build module for kernel
> 4.19.16 on my Linux laptop, a HP 15-DB0035NL with an AMD Ryzen 5 2500U CPU.
> 
> When upgrading to kernel 4.20.5 I could not build the module anymore, the
> compilation stopped with an error about the use of get_monotonic_boottime()
> function, which apparently was deprecated and has been removed.
> 
> I’m no expert in kernel development, however I discovered that such function
> has been superseded by ktime_get_boottime_ts64(), and so I tried to use it in
> place of get_monotonic_boottime(). The resulting code compiled correctly, and
> the module seems to load and work without problem.
> 
> The code I changed is in the rtl8821ce/os_dep/linux/ioctl_cfg80211.c (lines
> 338-339), you can find a patchfile attached here.
> 
> Sorry for any mistake I may have done in this report, this is the first time I
> do such a thing.

When you use an out-of-kernel driver, then you are responsible for making the 
changes that result from kernel API changes. For the in-kernel drivers, the 
person changing the API is responsible for all the fixes. For that reason, I'm 
not sure that the linux-wireless mailing list was appropriate for your "fix", 
but I am replying to it just in case someone else needs to fix one of Realtek's 
drivers.

By the way, your fix will break the driver for anyone trying to go back to 
kernel 4.19, or for anyone running a 32-bit system. My fix for this problem with 
Realtek drivers is to make rtw_get_systime_us() to look like this:

static u64 rtw_get_systime_us(void)
{
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(4, 20, 0))
         u64 ts;
         ts = ktime_get_boottime();
         return do_div(ts, 1000);
#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 39))
         struct timespec ts;
         get_monotonic_boottime(&ts);
         return ((u64)ts.tv_sec * 1000000) + ts.tv_nsec / 1000;
#else
         struct timeval tv;
         do_gettimeofday(&tv);
         return ((u64)tv.tv_sec * 1000000) + tv.tv_usec;
#endif
}

The above version will build on all kernel versions. The use of do_div() is to 
prevent a missing divide routine in 32-bit systems.

Larry



