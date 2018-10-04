Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C4C5C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 23:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2557420645
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 23:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p1eq6gDY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2557420645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbeJEGro (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 02:47:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35060 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbeJEGro (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 02:47:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id w5-v6so11700009wrt.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 16:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ov8zJcIKjYSgobL+Z+SbfiUp9GE/rSOO9O6m++fQAhA=;
        b=p1eq6gDY0A/NkDL5ksq/v7MasXCdZhvudosoY+dtL7LBi4SzPmXpef6I19w+5zPoSo
         +5czdrYKwkvuCdiqFuQHpvFoT1q9FOI/OR5kMEk6zQiF+8c3DFvTKzj8HmXxhOj6GQGk
         Hz81xPipzsgQ4LLph9pZJV4beBQ373mifW9/UwXTC5HQA+uj0DsDKH5bR+W8tBH34XvY
         1amUNNgf3baIRWXGvN/vaaMLPmFOpq/BYw3fDov3V9NhVJAaf5exZQDYQ9mUnaxV4Ojd
         adBtDxvV6zEdJV4wWITViJ0OPcFT172HukHBBdoQVeTHNvJ30uPMI8VkHk/o1TQuX3xm
         Qx+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ov8zJcIKjYSgobL+Z+SbfiUp9GE/rSOO9O6m++fQAhA=;
        b=TzmjnYcQpJUMyowH5819VqJcMVxcI8/fhzadEl4vsrJJe+dfuxknqfNm5aDb5VbCai
         UsEcLOBbZJs+Cm66q/YPaEpBbd7MppVVv61G3nPuD+dk6MOWHF0dxOohUtdBr5Hupr5h
         HCPNdaZnfn1+Moxk/c840WKDk1ohkxunjBrZtFybz6dC4kc4MNB65SFnewzNkK7gVXV/
         9FRfwzewvgGIb01yGTxsLhXBR8Xej4SyppFgmXKeBMXRggHWUnmMNaAhHVgCLDVKJ/mH
         8qrMMGHXRtpRHqy2grZuzrJ3cNrbF5GTAWn94dItq5PrFgNd/KSx3jdViuwOUcsAFRT7
         miTQ==
X-Gm-Message-State: ABuFfoh70dl0Qda9DFaw4vg7Tmc5St72BUgcAIRNHH/QO3ijIV5+nmwD
        FnhTzMgZoDFc36TwevyBNhI=
X-Google-Smtp-Source: ACcGV615SIYtWivJQ6GFIn5CQGjS9stDWyVrv7e0DIrhPrGD8njGk1cgaZzBFrNtZEDrJ1ITlRLLpw==
X-Received: by 2002:adf:e58e:: with SMTP id l14-v6mr6416328wrm.321.1538697108916;
        Thu, 04 Oct 2018 16:51:48 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id a105-v6sm12071029wrc.23.2018.10.04.16.51.48
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 04 Oct 2018 16:51:48 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     sgruszka@redhat.com
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
Date:   Fri,  5 Oct 2018 01:51:42 +0200
Message-Id: <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

As suspected this changeset causes throughput regression.

Below screenshots show iperf test from MS150N (RF5370) device connected to RT3070 adapter running AP mode:

This is with standard openwrt build without any rt2x00 changes:

[url=https://postimg.cc/BtYQLf6r][img]https://i.postimg.cc/BtYQLf6r/shot-2018-10-04_17-23-56.jpg[/img][/url]

And this printscreen show iperf test with your changes:

[url=https://postimg.cc/D8Sf1p48][img]https://i.postimg.cc/D8Sf1p48/shot-2018-10-04_17-42-09.jpg[/img][/url]

Atheros card connected to RT3070 iperf test difference was negligible (1Mbps or less) on bodhi system, but
it started to throw out reorder messages on my standard ubuntu after your changes:

[url=https://postimg.cc/SjJbP2SP][img]https://i.postimg.cc/SjJbP2SP/Screenshot.png[/img][/url]

My advice: stop sending low-quality patches and do some testing before submission.
