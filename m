Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCD7C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25172208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:58:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xKmN9m2c"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25172208AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbeJAUgq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbeJAUgp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:36:45 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B181213A2
        for <linux-wireless@vger.kernel.org>; Mon,  1 Oct 2018 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1538402329;
        bh=Sp8mSpPDs0AFBacr55xCiahuVUgEPiZKFCGgRo7s5UY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=xKmN9m2cFKIMIjew7n7LpYti6cFBe3SJtMZ0PAMt4tzxveOWkYTjxB8ogmFl8FwWj
         PfUfmbejY00s2jLQIC3acQVKCqLe2R752iAuqoGtOxQmAR7ooeH6509cxjCYPBYmsI
         zeh/TvXuef4ql8dVboB39GIk6u+pnFL351gKYjX0=
Received: by mail-qt1-f178.google.com with SMTP id c56-v6so9108222qtd.11
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 06:58:49 -0700 (PDT)
X-Gm-Message-State: ABuFfoh9NmgNSExeDhu5T+7TKGL4FioZMd4pK1Y3MNz6IfxF5b2g1YgF
        Qo10CoT9w2tV8YHV40+CraTbgCCti5dwZmJPh84=
X-Google-Smtp-Source: ACcGV637ar6xbYPg7ENMMyB3Kq9aZLJp24DPfXK4lpAgw+xURY4c1KT2B6KI+sysYPjfkaU/i+h3KtswgChAxik0pDs=
X-Received: by 2002:ac8:fa2:: with SMTP id b31-v6mr8706495qtk.2.1538402328662;
 Mon, 01 Oct 2018 06:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <1537977579442.29538@marvell.com>
In-Reply-To: <1537977579442.29538@marvell.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 1 Oct 2018 09:58:37 -0400
X-Gmail-Original-Message-ID: <CA+5PVA696w0JGHb+RHhPC=XipKaTKzJ=i+WBczbTR1Or86gh8w@mail.gmail.com>
Message-ID: <CA+5PVA696w0JGHb+RHhPC=XipKaTKzJ=i+WBczbTR1Or86gh8w@mail.gmail.com>
Subject: Re: pull-request mwifiex-firmware 2018-09-26
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>, rakeshp@marvell.com,
        spatki@marvell.com, laksnr@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 26, 2018 at 12:07 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit 0ced724f6ed564a5e1602808163db7cfa4697f39:
>
>   linux-firmware: update Marvell USB8801 B0 firmware image (2018-07-20 11:00:29 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to 52b23a9326fd8bb468b1b9e4c1816bf08bc2bc3c:
>
>   linux-firmware: add Marvell SD8997 firmware image (2018-09-26 21:25:40 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: add Marvell SD8997 firmware image
>
>  WHENCE                     |   3 +++
>  mrvl/sdsd8997_combo_v4.bin | Bin 0 -> 621896 bytes
>  2 files changed, 3 insertions(+)
>  create mode 100644 mrvl/sdsd8997_combo_v4.bin

Pulled and pushed out.  Thanks.

josh
