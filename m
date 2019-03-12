Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0739DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B51422084F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552392481;
	bh=1rOLFH96qAvWMqzGewP0P1zey/WrDCnWVaZbCb2num4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=tAOkiI+1e9+j8Lpx/wAQCE3CDZyfww25nXr3jK7DbIlw4JDG8nRq1Q44TNm3FktVn
	 hvxq0hjc/p1mU0AeQ+ydnlZJfs5E7dzbhHGqUqlskk7QB1jeiWrLpl5avM1qIGWQ50
	 uhzOwOZ4ZzpUWW9jO2UUTcJvfafwyyI+nv+3Lyow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfCLMIA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfCLMIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 08:08:00 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDD692084F;
        Tue, 12 Mar 2019 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552392480;
        bh=1rOLFH96qAvWMqzGewP0P1zey/WrDCnWVaZbCb2num4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m/pj6eZW6EgfG6G16J78m6W/PDGJ8wr0jSyzgv/UHcbQXzwX0/bfk8kbZgY+1EAJn
         X6J+GTuSOOF3QdI5e8UNaoQzTT5c032m3Jnk117oGbbkVtewhXvhckAR7px+iyxwx3
         XxQ5yXZ9aQxmHTQiQ3YYJoW9+uTywSKZzxeIPZJA=
Received: by mail-qt1-f180.google.com with SMTP id v20so2114150qtv.12;
        Tue, 12 Mar 2019 05:07:59 -0700 (PDT)
X-Gm-Message-State: APjAAAUgjovsZ4q1WNDNN4V4BctFxvKGXd/g/8DrmdswFpzgaMSbQp3l
        pjmSKMpaDrNzilR4DnJL+HQiIpWsvpt8Y2CIl3M=
X-Google-Smtp-Source: APXvYqx8yndlx89WN/HUJe8SxNtWKwDGzu1Cmq7lHkI0d7TjfnoW36QM4s3t0KCDHUJGqfK+uhqHULIHguA5/VS64YU=
X-Received: by 2002:ac8:682:: with SMTP id f2mr12341456qth.285.1552392479255;
 Tue, 12 Mar 2019 05:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190225011242.14002-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20190225011242.14002-1-Larry.Finger@lwfinger.net>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 12 Mar 2019 08:07:48 -0400
X-Gmail-Original-Message-ID: <CA+5PVA7b1B+5wSRyGorqj5GG1sOiYLjBdjUbbkBx_PT_AKMFfw@mail.gmail.com>
Message-ID: <CA+5PVA7b1B+5wSRyGorqj5GG1sOiYLjBdjUbbkBx_PT_AKMFfw@mail.gmail.com>
Subject: Re: [PATCH] rtl_bt: Update firmware for BT part of RTL8822C
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Max Chou <max.chou@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 24, 2019 at 8:12 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> The file was sent to me by Max Chou <max.chou@realtek.com>.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Max Chou <max.chou@realtek.com>
> ---
>  WHENCE                  |   2 ++
>  rtl_bt/rtl8822cu_fw.bin | Bin 22412 -> 41588 bytes
>  2 files changed, 2 insertions(+)

Applied and pushed out.

josh
