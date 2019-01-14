Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3F2C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:30:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C157D2087E
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547479808;
	bh=3uFiGbxCbvO4lB2m4xIQ9WjRes3SjfKPaQ4AxsnxeS0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=z1XUOyUJkkKgCLYlA/ctMiwZwCHGpVrsXx9FM53VEwk0E0NCHaNPOyhc2wPmR4L4B
	 9KhAtY9HScUhHwnQnisDHRPTGeWu2warVlXS34Y7MAPKVj4QLpM1gvoE6LIs/MaW94
	 FyNVC+7//wDgdaLIqBlpJtcHoVgP9leqNcPwxD6o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfANPaI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 10:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbfANPaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 10:30:08 -0500
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B580C2087E
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 15:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547479807;
        bh=3uFiGbxCbvO4lB2m4xIQ9WjRes3SjfKPaQ4AxsnxeS0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BwJms62W9gD3hmnfQzCcbSGW66txuBqUoyFYJldT1k6D97VSgS2BhzIVpfI/3lA64
         eZ1GaSGd0rq99EwkSWIvynMP3cglqnA8lCP1DYJHkidCuuD/PhJBApRxPoeaF3FMl9
         YHCVLhppy5ZW/jE57HLPeiSu6l0pwGBJEzMriQUg=
Received: by mail-qt1-f173.google.com with SMTP id i7so26894271qtj.10
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 07:30:07 -0800 (PST)
X-Gm-Message-State: AJcUukejmuYxQ+jWsaDFDOT8NadAE6XGXlvk6MW5gzvl+oc7oPfARxjz
        UD5dQ36cmtVvSlnX1Gr4aTzpjVqXtjQHFnbEYVM=
X-Google-Smtp-Source: ALg8bN6pj5QK/hBZ+qC0H2FvS5n8r1sNWqvtOswTJ7Baliu25E0ACDxBkxZkNrSVdJH0GS95Pblqv8/sBosN7ONGyzQ=
X-Received: by 2002:ac8:68d:: with SMTP id f13mr25064507qth.166.1547479806971;
 Mon, 14 Jan 2019 07:30:06 -0800 (PST)
MIME-Version: 1.0
References: <CY4PR18MB1237DC08CFA9B2B0A0368AEAA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
In-Reply-To: <CY4PR18MB1237DC08CFA9B2B0A0368AEAA08B0@CY4PR18MB1237.namprd18.prod.outlook.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 14 Jan 2019 10:29:56 -0500
X-Gmail-Original-Message-ID: <CA+5PVA7Miknp+K2wCNwKZU9xCCHmVOxCQDmHrCuC91j3Ti=pbg@mail.gmail.com>
Message-ID: <CA+5PVA7Miknp+K2wCNwKZU9xCCHmVOxCQDmHrCuC91j3Ti=pbg@mail.gmail.com>
Subject: Re: pull-request mwifiex-firmware 2019-01-09
To:     Ganapathi Bhat <gbhat@marvell.com>
Cc:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Prashanth Ranganathan <rprashk@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 9, 2019 at 1:26 AM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit 52b23a9326fd8bb468b1b9e4c1816bf08bc2bc3c:
>
>   linux-firmware: add Marvell SD8997 firmware image (2018-09-26 21:25:40 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to 63ca64a73c05fa5bcceb687422cbc28185bb6355:
>
>   linux-firmware: update Marvell USB8801 B0 firmware image (2019-01-09 11:24:42 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell USB8801 B0 firmware image
>
>  WHENCE                  |   2 +-
>  mrvl/usb8801_uapsta.bin | Bin 250940 -> 252260 bytes
>  2 files changed, 1 insertion(+), 1 deletion(-)

Pulled and pushed out.

josh
