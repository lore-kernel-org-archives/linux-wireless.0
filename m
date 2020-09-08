Return-Path: <SRS0=ylPz=CR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEF4C2BC11
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 19:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3025720658
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Sep 2020 19:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="Gbr4FBBB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgIHTwc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Sep 2020 15:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730682AbgIHPtf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:35 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28879C061389
        for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2020 05:33:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b17so5820396pji.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2020 05:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=iDh5oerIwDKilwa4JO3Vp5i5/Awtl6AjVqpak4FAWc8=;
        b=Gbr4FBBBQDv9ZAtzDnFOa+KkTbb0lywtPcVM6jMh7dHNvzODW30O5NBlRmaCwFHKyn
         1axKQY2tHW6AeOingHWn2FQmItKgZ4NXXQgRucqrgi3lgZJVlW+4QX9TNlECVeYGwizT
         hmdTDX1yap1u/4k4im5Xpwu7qkVi8ByuDoIFyOV3XWcjKMBHMEb7dRvX+d9pKyujloiL
         W++OjYGQYtoZxvhTlDxmW7iQmuBwI/KtZ9zgL/YFq30w3BTXLmPotQZ9BEx4wzIiL/G9
         sU0VqUXAmWPW3cPtyuvGXd1lQDPTQG4qKzsXp2vxhSIhZXyoHMaeC5h08bjdnzpDGJEC
         MEfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iDh5oerIwDKilwa4JO3Vp5i5/Awtl6AjVqpak4FAWc8=;
        b=Mt94SWjF4BhT0H0m5JBV1jETVk00u6DJaNINHZqwbFVKFPyqfnYJ6iQ0WBg5RwApMN
         KDORCH0GQXpIGj8ztLT3Lh7/OI7cNPIkyePOgWBb62aAD1P3FXcS3YWYMzdRr2sn0efP
         Vmr1ityYNdfUAHYX65Xx+xKDXorVY/YaQfwpFhwf4JVGchvN4FiDu0IPv3hSfjeRM08v
         zWjDJMrh+oux644S0CIFjoJSINpOfLQQrmuLO/RzpKV8aPa+NRts9NuTOicOXsIlVLgn
         fsSwCupbmcHebrjaDsPw4xRLPnUghRHy6V7pmTS12n5QdvNAZY5lfqH1wObRXVX/29O/
         S7Sg==
X-Gm-Message-State: AOAM531JfbF+edLqU10Kex0x7h4reU4D36IG7l9sVzXjzqXHuVuJ1vJ9
        O5kOkpLltG1bx29l8owpNgrSDIp2cgWPkWiOt9ItbA==
X-Google-Smtp-Source: ABdhPJzisWqjC8V6say/8z120ClJ8mNkK3sLAFliQAtEk7eFToZXeLaQo6/FMzQPo0hM+if6DS5Fyz+HqMD0bqPrlrE=
X-Received: by 2002:a17:90a:9292:: with SMTP id n18mr3950216pjo.159.1599568393391;
 Tue, 08 Sep 2020 05:33:13 -0700 (PDT)
MIME-Version: 1.0
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 8 Sep 2020 20:33:02 +0800
Message-ID: <CAB4CAwfqbaR7_ypZDp=hi_3u_F2E5eYv5ExUoSPK97qcTxiWZQ@mail.gmail.com>
Subject: mt7615: Fail to load firmware on AZWAVE-CB434NF module
To:     sean.wang@mediatek.com, ryder.lee@mediatek.com,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        nbd@nbd.name, lorenzo@kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sean, Ryder,
    We have an ASUS laptop X532EQ with the wifi module AZWAVE-CB434NF
which fails to bring up the wifi interface on kernel 5.9.0-rc1. The
dmesg shows the firmware load error.

[   25.630850] mt7615e 0000:2d:00.0: Message -4294967280 (seq 1) timeout
[   25.630851] mt7615e 0000:2d:00.0: Failed to get patch semaphore
[   25.630853] mt7615e 0000:2d:00.0: mediatek/mt7663pr2h.bin not
found, switching to mediatek/mt7663pr2h_rebb.bin
[   46.111154] mt7615e 0000:2d:00.0: Message -4294967280 (seq 2) timeout
[   46.111178] mt7615e 0000:2d:00.0: Failed to get patch semaphore
[   46.111179] mt7615e 0000:2d:00.0: failed to load mediatek/mt7663pr2h_rebb.bin

The lspci information for the device shows as follows
0000:2d:00.0 Network controller [0280]: MEDIATEK Corp. Device [14c3:7663]
        Subsystem: AzureWave Device [1a3b:4341]
        Flags: bus master, fast devsel, latency 0, IRQ 177
        Memory at 6032100000 (64-bit, prefetchable) [size=1M]
        Memory at 6032200000 (64-bit, prefetchable) [size=16K]
        Memory at 6032204000 (64-bit, prefetchable) [size=4K]
        Capabilities: [80] Express Endpoint, MSI 1f
        Capabilities: [e0] MSI: Enable+ Count=1/32 Maskable+ 64bit+
        Capabilities: [f8] Power Management version 3
        Capabilities: [100] Vendor Specific Information: ID=1556 Rev=1
Len=008 <?>
        Capabilities: [108] Latency Tolerance Reporting
        Capabilities: [110] L1 PM Substates
        Capabilities: [200] Advanced Error Reporting
        Kernel driver in use: mt7615e
        Kernel modules: mt7615e

I also tried the latest linux-firmware with the most up to date
mediatek firmware
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=7a237c6ee2c7af48723c356461ef80270a52d2c6.
But still get the same error.

Any suggestions on what I can do here?

Chris
