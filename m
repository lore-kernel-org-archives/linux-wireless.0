Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C06CC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E0B20823
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549975633;
	bh=V+UeM8ADHzD6Ey7KUTJrcLGUDt/D65LeuiSOHNMMDuM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=RGf/8fE5XcGx8nLl+EsAdL4LWd0RFNz8rk5P6xTavg/adSg7n/uAIfn8Na1vGBBcd
	 Lb6mUew43G7W9uY6hiq0c7T3/fp7wVd/AoRayLcoG3PEUjZ9K2b05T367lXWjzTgcc
	 d4vYU/9IIQ4G4lSKw1DWrKyI4Yf/qJqLR6Mxhj7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfBLMrM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbfBLMrM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 07:47:12 -0500
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3510820823
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 12:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549975631;
        bh=V+UeM8ADHzD6Ey7KUTJrcLGUDt/D65LeuiSOHNMMDuM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KB+W+/j4EXANbUEa9nqSixnTIlWmC6iTEa7YNXzADIDawi6PvuKoYu7ys9k6Pib3w
         xWGspAAuK/cqvoKwHX4PYNQVX4SSyS/16kiPU6iv33m+7VU6mQd+77gd5GsGBRBo5S
         7tCGrw6JTHUCXfpNE/F9n3lOu/wBy0OsfrsindaU=
Received: by mail-qt1-f182.google.com with SMTP id b8so2694629qtr.9
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 04:47:11 -0800 (PST)
X-Gm-Message-State: AHQUAuY8lISVq/gH6MZWkuaXYfdRH+V4vfMYurHGEYoqkxJqselAlKdD
        LqJJlbxhrslcHRrW0zXx5yW+yw5vsT8QeYRL2LA=
X-Google-Smtp-Source: AHgI3IYJR7HBd/Plv89mA/66ri9b0RMPxDf5hBC1abGjG52BMyalvUOLhTnbXF/3+FrDUAnv16F/IrfVJhKiPOZOOag=
X-Received: by 2002:a0c:a5a2:: with SMTP id z31mr2533807qvz.108.1549975630455;
 Tue, 12 Feb 2019 04:47:10 -0800 (PST)
MIME-Version: 1.0
References: <DM5PR18MB12412307A7C6EDD99B522785A0650@DM5PR18MB1241.namprd18.prod.outlook.com>
In-Reply-To: <DM5PR18MB12412307A7C6EDD99B522785A0650@DM5PR18MB1241.namprd18.prod.outlook.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 12 Feb 2019 07:46:59 -0500
X-Gmail-Original-Message-ID: <CA+5PVA5yQbjg3vaT7F8120B6ngLn7+sZC0OWt0KoUiQR9hS4FA@mail.gmail.com>
Message-ID: <CA+5PVA5yQbjg3vaT7F8120B6ngLn7+sZC0OWt0KoUiQR9hS4FA@mail.gmail.com>
Subject: Re: pull-request mwifiex-firmware 2019-02-12
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Prashanth Ranganathan <rprashk@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Feb 12, 2019 at 1:17 AM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit 63ca64a73c05fa5bcceb687422cbc28185bb6355:
>
>   linux-firmware: update Marvell USB8801 B0 firmware image (2019-01-09 11:24:42 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to bd72387b8e49b1b7268ee60c97a131419284fb39:
>
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2019-02-12 11:42:24 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (3):
>       linux-firmware: add Marvell SD8977 firmware image
>       linux-firmware: update Marvell SD8897-B0 firmware image
>       linux-firmware: update Marvell PCIe-USB8997 firmware image
>
>  WHENCE                        |   7 +++++--
>  mrvl/pcieusb8997_combo_v4.bin | Bin 631012 -> 634228 bytes
>  mrvl/sd8897_uapsta.bin        | Bin 821024 -> 701072 bytes
>  mrvl/sdsd8977_combo_v2.bin    | Bin 0 -> 587052 bytes
>  4 files changed, 5 insertions(+), 2 deletions(-)
>  create mode 100755 mrvl/sdsd8977_combo_v2.bin

Pulled and pushed out.  Thanks.

josh
