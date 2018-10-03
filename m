Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3571C65BA7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5461820835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 09:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5461820835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbeJCQPX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 12:15:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57948 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbeJCQPX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 12:15:23 -0400
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1g7dRc-0006IG-HT
        for linux-wireless@vger.kernel.org; Wed, 03 Oct 2018 09:27:48 +0000
Received: by mail-pg1-f200.google.com with SMTP id d132-v6so1767100pgc.22
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 02:27:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=tpPdh9ymhW8iJ3OfqQ/rs1B/QW0LKc+XaWgjFG6bRR0=;
        b=Tpv6vLoGEgw9Ap4+lEndaY4f7WRPKnjmS2eNzW8+jLf6Dm7snBc20gRySZ7HRNVm1E
         AM1z4RriFVgncXiy1bQ8vlyQfa7sQYa2bwv1Wu1tZMu5lyqgWL+mPaCTSVLVKaoz9yq8
         TkjLR2/am6ppL3EHuVEs6L/CXaYhee4vpN71oLtgOwxNoJCQrDkYmnXKymHsdW5Hc4ny
         irIwW3KUvtQ/KiunBYXh59EGbcsqoZHGbWh5/F8kgncHSzoIJ42g+BBBCuQG8UctTTdA
         n0WuQi4NNR4Au62DYaTcXrSUWrHNRF5eRmkvBoZUyZdqkCzMcwk58T7GfjqCIJAiDNAA
         jSGQ==
X-Gm-Message-State: ABuFfojTfx8rKz0zx2n8qiF74t5SWonTuOpxss/RXwE7KHErHP8ZghDl
        Bx/qsdxtKftEKuEgVcNI1Z9wzMCrzwVlb8quLBdgERur2nDxggKE+KP14dwT8UzTpk3eq5REt0E
        5S2jNky7LJqOxmmwSy+KMgSAdY84XSY1DzPFvVkuw4Ln4
X-Received: by 2002:a63:ce14:: with SMTP id y20-v6mr585595pgf.248.1538558867214;
        Wed, 03 Oct 2018 02:27:47 -0700 (PDT)
X-Google-Smtp-Source: ACcGV63JZICns5VLK6ijq9VCJNR0WSzXkr+mi0TDCUK6fn1s7P5yaFtvwzZJEK3CxkXJ+UXLLN0vhg==
X-Received: by 2002:a63:ce14:: with SMTP id y20-v6mr585584pgf.248.1538558866976;
        Wed, 03 Oct 2018 02:27:46 -0700 (PDT)
Received: from [10.101.46.95] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id s23-v6sm1264065pgg.67.2018.10.03.02.27.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 02:27:46 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [RESEND] [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel
 WiFi
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
Date:   Wed, 3 Oct 2018 17:27:41 +0800
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <265BAF93-4BFF-4850-92F7-80AC39496473@canonical.com>
References: <20181003073556.28154-1-kai.heng.feng@canonical.com>
 <20181003073556.28154-3-kai.heng.feng@canonical.com>
 <87y3bfiees.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> On Oct 3, 2018, at 5:10 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>> To avoid the firmware loading race between Bluetooth and WiFi on Intel
>> 8260, load firmware exclusively when BT_INTEL is enabled.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> Still the commit log tells nothing about the actual problem which makes
> review impossible.

Sorry for that. The first two patches [1] only sends to linux-bluetooth and LMKL.

I don’t know what really happened at hardware/firmware level, but making btusb and iwlwifi load firmware sequentially can workaround the issue.

Matt Chen may be able to explain this issue with more detail.

[1] https://lkml.org/lkml/2018/10/3/322

> 
> -- 
> Kalle Valo

