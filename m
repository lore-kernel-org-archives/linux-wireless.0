Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF54C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 11:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0598E2133D
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 11:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554206179;
	bh=OsEYKPWtAdeDzWFRMN7EZmD31frabaWNkT4VLCUyiOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=DMda/A0rK6kZvIW8egQa9mOnqgB8TzYItLjsuurQ1EBiERA1KVlJOE1yPtIYt/qc/
	 dgj0AqBwIhLHM1akgYUHFSCAo1p5Yc/shHgh9cC4zIk/bxg9l7LtpR/ibGdzTP8ksl
	 XaVrEq3oKtu7QGT1nP8T0V3ZYB2XotV6uCIRT6uE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbfDBL4S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 07:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfDBL4R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 07:56:17 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D502133D
        for <linux-wireless@vger.kernel.org>; Tue,  2 Apr 2019 11:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554206177;
        bh=OsEYKPWtAdeDzWFRMN7EZmD31frabaWNkT4VLCUyiOw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Foti/bUXXm63F8x7laQTCVdN3TwI9DlivYypN5OBmljWCST4u2GbxsglVds5msBAD
         S14qJrAFPUu3Jx8PTtrtIek3qVQYbHh24UViqX/6StbzKLHPmN5PrDndWIyht1fBxk
         jKc4T5eRfgrY99ILTxw0TVExEsBX61dOAS7wbn9c=
Received: by mail-qt1-f178.google.com with SMTP id k14so14839127qtb.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2019 04:56:16 -0700 (PDT)
X-Gm-Message-State: APjAAAU8BukcD63o3p5MX7hC930H1/kiEtDIM3cAGDWEigm2oi7iqu5O
        fgkq+qx3vB/Ov6WwNn+6KJfbqKvBFM0akiE9hw0=
X-Google-Smtp-Source: APXvYqwByDAlwy1b8OBEtH704gpwWY/PG+xDkIoSbnqQS0Imzvl79HcvmMcFNSDxmvkdJDsK9tAVeoHHLmIYCgf94QM=
X-Received: by 2002:a0c:b050:: with SMTP id l16mr49340115qvc.82.1554206176304;
 Tue, 02 Apr 2019 04:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <CY4PR18MB1237CD0037B7ED3C3C11A5B5A0440@CY4PR18MB1237.namprd18.prod.outlook.com>
In-Reply-To: <CY4PR18MB1237CD0037B7ED3C3C11A5B5A0440@CY4PR18MB1237.namprd18.prod.outlook.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 2 Apr 2019 07:56:05 -0400
X-Gmail-Original-Message-ID: <CA+5PVA7Pdjr=fQC4ysQdigfc-EGsKHk20QXQ-m-ffv6qtutYPg@mail.gmail.com>
Message-ID: <CA+5PVA7Pdjr=fQC4ysQdigfc-EGsKHk20QXQ-m-ffv6qtutYPg@mail.gmail.com>
Subject: Re: pull-request mwifiex-firmware 2019-03-15
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Cathy Luo <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Mayur Arakere <mayur@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 15, 2019 at 1:44 PM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit 78d2b16af093783d40f0b8990d5d9ede8c3281d3:
>
>   linux-firmware: update Marvell 8787/8801/8887 firmware images (2019-02-28 23:35:32 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to d71dee4e5a86075c0ba6f81f00660ff999f171bc:
>
>   linux-firmware: update Marvell 8797/8997 firmware images (2019-03-15 21:02:17 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell 8797/8997 firmware images
>
>  WHENCE                         |   6 +++---
>  mrvl/pcieuart8997_combo_v4.bin | Bin 583628 -> 632240 bytes
>  mrvl/sd8797_uapsta.bin         | Bin 458108 -> 533976 bytes
>  mrvl/usb8797_uapsta.bin        | Bin 553456 -> 553940 bytes
>  4 files changed, 3 insertions(+), 3 deletions(-)

Pulled and pushed out.  Thanks.

josh
