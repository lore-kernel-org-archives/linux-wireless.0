Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLACK autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B11DC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 312B820841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="zqNywHKC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 312B820841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbeJHUfX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbeJHUfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:35:23 -0400
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5829720C0A;
        Mon,  8 Oct 2018 13:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539005020;
        bh=ziCjjyLZEW4j7nWfPmXGsvT91OEiceK/JbbaxF4NG64=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=zqNywHKC6eJFrpBVfykPXy6sxVjA4JP8UuRSywXkzI0Fj1K24+9cb5KkIjY1GHvcV
         PuHHhw4fQSaFzazn0aU95pXW9UgHedRsKfcQxXoHnDd0O3EUx7jcyKq885qe5rYMSz
         rlXRNSSJJ8UDeQ0TgakZcUEwb6uAyuv8HGJy64tg=
Received: by mail-qk1-f182.google.com with SMTP id 84-v6so12051559qkf.0;
        Mon, 08 Oct 2018 06:23:40 -0700 (PDT)
X-Gm-Message-State: ABuFfohzc7ofJqFsuWtoDJPy4JjccJEznA3rfOrVgMGRsjSokew4nsdy
        a6Smfbbj2OXD6BgylSYvdtz6d3T1l0wdczQWHKU=
X-Google-Smtp-Source: ACcGV63SnAd58tie9Y3zbDAwlEwSscC2fywM1oVZfamcgOqFFOxck1mtskMcyxwY+jeeG3bLk8b4h9IRtHWjmrduarE=
X-Received: by 2002:a37:542:: with SMTP id 63-v6mr18675888qkf.281.1539005019562;
 Mon, 08 Oct 2018 06:23:39 -0700 (PDT)
MIME-Version: 1.0
References: <20181004193155.22669-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20181004193155.22669-1-Larry.Finger@lwfinger.net>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Mon, 8 Oct 2018 09:23:28 -0400
X-Gmail-Original-Message-ID: <CA+5PVA59DKnuPHsCCPmdD_sXzP+16Vmz43BcZo09L=yT-3POXQ@mail.gmail.com>
Message-ID: <CA+5PVA59DKnuPHsCCPmdD_sXzP+16Vmz43BcZo09L=yT-3POXQ@mail.gmail.com>
Subject: Re: [PATCH v3] rtw88: Add firmware file for driver rtw88
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, yhchuang@realtek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 4, 2018 at 3:32 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> This file contains the firmware for the new driver rtw88 for Realtek
> RTL8822BE and RTL8822CE devices. It was provided by the Realtek
> developer.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> v2 - removed redundant information from subject
> v3 - drivers are for 802.11ac, not 802.11n
>      added firmware for RL8822CE
> ---
>  WHENCE                |  10 ++++++++++
>  rtw88/rtw8822b_fw.bin | Bin 0 -> 150984 bytes
>  rtw88/rtw8822c_fw.bin | Bin 0 -> 162064 bytes
>  3 files changed, 10 insertions(+)
>  create mode 100644 rtw88/rtw8822b_fw.bin
>  create mode 100644 rtw88/rtw8822c_fw.bin

Applied and pushed out.

josh
