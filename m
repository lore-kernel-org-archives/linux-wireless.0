Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AF2C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A430E2145D
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 10:11:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=agilox-net.20150623.gappssmtp.com header.i=@agilox-net.20150623.gappssmtp.com header.b="uKZse8qd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A430E2145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=agilox.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbeKNUNi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 15:13:38 -0500
Received: from mail-wm1-f44.google.com ([209.85.128.44]:35654 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbeKNUNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 15:13:38 -0500
Received: by mail-wm1-f44.google.com with SMTP id t15-v6so14223487wmt.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 02:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=agilox-net.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=jaMGT7JjQkZuXc9/7SbszTnHS9ZmTy4mtcgJahS7uIo=;
        b=uKZse8qdurZ6KaFoXEp4ZxNNoC+1Di5Nwuske7cXICOrPKy9UQxsiyV0YMD9xCCI0G
         aM1QtXDR0Us1aP/+y5Hzq2BxipdWUruhURpeYXvjYNsaEexa//pQXLuVWsYKLO9RjgU6
         r2YEothjPa9/3BijwyxPaHGRgSn+dt0UOBbV8wpBn7t2GZC73mo5Qg27UYlRNGvhJoPa
         9Y8cEZf9IZXkhSHck9rTW3PkRC5kQohaAVVEQaRf+PxaWviP/8ON9MmvWpG/w5df/CXg
         PpueQJ49UX/CaohVRBPtsWpy/Dk7+GrzT7qoO2WBdtxcdY84AeEqJrFVi8YCQT2k4YsD
         JvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=jaMGT7JjQkZuXc9/7SbszTnHS9ZmTy4mtcgJahS7uIo=;
        b=YtznBN9qkQceg36dkLKVRreKq3UskIXX4uz/w7X/tWeCbvlrkuuxDRa+JODEN4ZmCb
         aG13/QHiFoxRBb+9gPEu7EmOy2hdaSF4MPeQLLq6VJjXJ4Od/FNeBLC6d8z5ZWbRAeP/
         Z2PbxAqtxuNNHHQ8NVP+eC+4xI1ClsZGf4iRPUEIPEOcdqOieQRGhSxt74RvG+4k4rwH
         6BzLEktlkhqNvddVB1GuwhfYn0WWpbQ82lLOmpkSULPX2+HhZgM2qXBYnvOkKIUIac3b
         3ob1U0MzdCx265kq44E7Fx1D5UknWYnJzkE2qag7aoZG6gdW5F5nJD/EtxZUiEd5HK6S
         l8GA==
X-Gm-Message-State: AGRZ1gLQWVdsRbGTMxlayLkIFYCEI3qWuOZ0ek+KzwK/mOLAYSSr9zJa
        ravqfZyh7Ki0P45pRJ3VkBS+tjmfLhs=
X-Google-Smtp-Source: AJdET5fNhyxwlxtqxhVr3H3cFtTgiF+BaA6fQonl7s5DDtVpzluXWA/e6j468x85MzOmpkGm34uTQw==
X-Received: by 2002:a1c:6555:: with SMTP id z82-v6mr1360074wmb.66.1542190261496;
        Wed, 14 Nov 2018 02:11:01 -0800 (PST)
Received: from [10.10.55.83] ([31.193.161.162])
        by smtp.gmail.com with ESMTPSA id e8-v6sm39196501wmf.22.2018.11.14.02.11.00
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 02:11:00 -0800 (PST)
To:     linux-wireless@vger.kernel.org
From:   Lukas Redlinger <lukas.redlinger@agilox.net>
Subject: intel 9000 wifi cards positive signed signal reading
Message-ID: <fcf8daa4-d1a0-32c6-d048-ae9dd3a04982@agilox.net>
Date:   Wed, 14 Nov 2018 11:10:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: de-AT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I got some Intel 8000 and 9000 wifi cards here to test their roaming 
capabilities. I'm using debian testing (buster) with firmware-iwlwifi 
(20180825+dfsg-1), which includes iwlwifi-9000-pu-b0-jf-b0-38.ucode

The 8000 series cards are working good, but all 9000 series cards give 
signal readings with a positive sign (like +58dBm). If I cover the 
antenna with my hand, it goes to +63dBm. So it seems as if it's just 
wrongly signed. From -58 to -63 would be perfectly plausible...

I cannot use those 9000 cards, as they would never roam with signal 
always being 100%.

Is this a known issue?

Thanks,
Lukas

