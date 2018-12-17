Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F1BC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 12:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6232020672
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 12:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545050363;
	bh=hCFZH6mZGMTKeQzk30dInF+gj7jfRJF+XVHCDeTLCD0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xdRXRpnNpvvnKCY4npNVo9Q/hBB19RqETrcUakXSS+rOprQTItEAjcj8zjtSlUFl2
	 xxb6qdPcIsM3xXB8z/RbMbPT5R2gdK15cFnT0qCgl0753BDDfDXrlHZTPI+WpbwvrE
	 EyITMlFFcshkZXAwLdhKXZtHz1WUXeHEqTgeWsOY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbeLQMjW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 07:39:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbeLQMjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 07:39:22 -0500
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BC020672
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 12:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545050361;
        bh=hCFZH6mZGMTKeQzk30dInF+gj7jfRJF+XVHCDeTLCD0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MkhCPr7ghho7q5AiWWsAs9D/+1e8kOd2NB2TMhnPGW3tM/FTbIagaAHIpqpgo5HvD
         bdElJhDAoxF5ykURI4hZm/tvjVRTDFvXxm8WOk+2hMU/6PrlfjV7Ejul94SfxVnlQq
         KErX8Rbcyp0WsN9Yv7U6d4R1aLdFq0FIUEb7mEmY=
Received: by mail-qt1-f174.google.com with SMTP id d19so13787949qtq.9
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 04:39:21 -0800 (PST)
X-Gm-Message-State: AA+aEWbGM/CrCwA5X1iXcEhCXKOzaiDJpSJGcST4u227Bwc3eO0fd4ER
        rVOdXvAqPKxLDzc4vdBurb9m/Xf7N+gx7e3yxVQ=
X-Google-Smtp-Source: AFSGD/UG7r9+lt1Mwv4ROp/BtN8vGylO+MIbp/jEqvKcIH1ramCGJc0fCwbhfBciUiPReTsmd6v+yJ8GpxIkV1hXdNk=
X-Received: by 2002:a0c:f313:: with SMTP id j19mr12975818qvl.200.1545050360646;
 Mon, 17 Dec 2018 04:39:20 -0800 (PST)
MIME-Version: 1.0
References: <1544950869.7454.5.camel@intel.com>
In-Reply-To: <1544950869.7454.5.camel@intel.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 17 Dec 2018 07:39:09 -0500
X-Gmail-Original-Message-ID: <CA+5PVA67TuNd_UhCzE3v+cQdusCzSwgqj9zyq5Xo+dK0mAohuw@mail.gmail.com>
Message-ID: <CA+5PVA67TuNd_UhCzE3v+cQdusCzSwgqj9zyq5Xo+dK0mAohuw@mail.gmail.com>
Subject: Re: pull-request: iwlwifi firmware updates 2018-12-16
To:     emmanuel.grumbach@intel.com
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        Kyle McMartin <kyle@infradead.org>, jwboyer@kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Dec 16, 2018 at 4:01 AM Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
> Hi,
>
> Quite a few updates here.
> Please pull.
>
> Thank you.
>
> The following changes since commit 211de1679a68b8ab0f841a8058df35e13e3963f0:
>
>   brcm: provide new firmwares for BCM4366 chipset (2018-12-15 20:51:38 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
>
> for you to fetch changes up to 8707ef3313ee0f6737683c93aa2cb1dff6483643:
>
>   iwlwifi: update firmwares for 8000 series (2018-12-16 10:46:40 +0200)
>
> ----------------------------------------------------------------
> Emmanuel Grumbach (3):
>       iwlwifi: update -41.ucode for 9000 series
>       iwlwifi: add -43.ucode for 9000 series
>       iwlwifi: update firmwares for 8000 series
>
>  WHENCE                            |  14 ++++++++++----
>  iwlwifi-8000C-36.ucode            | Bin 2486572 -> 2486572 bytes
>  iwlwifi-8265-36.ucode             | Bin 2498044 -> 2498044 bytes
>  iwlwifi-9000-pu-b0-jf-b0-41.ucode | Bin 2961864 -> 2620464 bytes
>  iwlwifi-9000-pu-b0-jf-b0-43.ucode | Bin 0 -> 2543532 bytes
>  iwlwifi-9260-th-b0-jf-b0-41.ucode | Bin 2620368 -> 2620656 bytes
>  iwlwifi-9260-th-b0-jf-b0-43.ucode | Bin 0 -> 2558172 bytes
>  7 files changed, 10 insertions(+), 4 deletions(-)
>  create mode 100644 iwlwifi-9000-pu-b0-jf-b0-43.ucode
>  create mode 100644 iwlwifi-9260-th-b0-jf-b0-43.ucode

Pulled and pushed out.

josh
