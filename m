Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37734C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 23:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0574920811
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 23:38:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gxw6ss8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCSXis (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 19:38:48 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35933 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCSXis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 19:38:48 -0400
Received: by mail-oi1-f193.google.com with SMTP id t206so365150oib.3;
        Tue, 19 Mar 2019 16:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=NDRtOZ+acBN+uU5aUd6XsYoQMrcl+FASNQzPXm/qy64=;
        b=Gxw6ss8LRMeQCMgkGbHnbieNAbueSSLHeBHV0Du44tR0jVjoj9Jv6wq0tTyKDEQZxB
         5pqerog3iRna5t/u6dLk7Ro5D9qwpcBVO7YYriCqHVy5IRaayrICSulOcVUCDHIrJUKn
         dv1Ngc7oKivCLU6KjeDxNxpEYW/ySKl3c+kVduCAXPCDdzimfAMNn28EPFuZR2lkMYAO
         aRiabbjUnWKfk1j++CdJ8/WC5QhGqMXl2IaN1afCnVpFS2S8y459MssFjUBBOsAM7FJs
         LF/60Wl5MBpHmVxfEkTbPeAUbMe28Kgp4up28SHVFloNAwq401ye31i709hvr//ptSF/
         27pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=NDRtOZ+acBN+uU5aUd6XsYoQMrcl+FASNQzPXm/qy64=;
        b=iPOvlzvss9QeXq1sj7gOD6KktrfIVSpL5hGaUeMhkedaa+8q6CQbR9pI0/Nla1dFw/
         WADOnhVJFa4AixHy4RiX7+F+3SdYsMh7bg9TEf4BlcQZKoOvRZrYXV7wCW8AtEhf60rF
         QoTjapPTtt5CgfqPllkbPiR2uJ8DTd5knDX/jbE1YpHI26MemS6h18ih0ocRllMrpUg1
         REmM3Zyjp6krrrOgQoWOb1FjaUHgfkG6PDYJnwrxgAC1/wOUuuFPH2tr2HLA+3wXlFR3
         HYeH1/zXhPgMqFd993yhnx7fejypOITbHTn2rxVXsagRxawE+4bB2NcVXwGnVLIWeMAd
         tTHQ==
X-Gm-Message-State: APjAAAV389xOyA5bk6pZ48n+E9QGZViU3NBY9LnH/BXupT6rlDJQmEKX
        f09mS1lVDf/WVj34ReuDQZgjx9TbM4OaWqmfyqc=
X-Google-Smtp-Source: APXvYqxq545xEnWCf/qVTky6QcrEep4O2gGcfBubpdDCiN0zRlSJL4c2TVbjk8MdSNKBRJVR+C1Y97/I5+xjARZaz/8=
X-Received: by 2002:aca:b904:: with SMTP id j4mr3337945oif.128.1553038727308;
 Tue, 19 Mar 2019 16:38:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Tue, 19 Mar 2019 16:38:46
 -0700 (PDT)
In-Reply-To: <57195909-b18b-8490-e1b8-043ff9727e5a@gmx.de>
References: <20190318190557.21599-1-timschumi@gmx.de> <CAKR_QV+wjuOZVfv9awX5bRLYC8xkoAy0h22LSPvL0DX6yg4-yw@mail.gmail.com>
 <57195909-b18b-8490-e1b8-043ff9727e5a@gmx.de>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 20 Mar 2019 00:38:46 +0100
Message-ID: <CAKR_QVKWbrx2EmcaCBhyuaYRd+T3pFW0i2jVcDZG6=wee=DaMA@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
To:     Tim Schumacher <timschumi@gmx.de>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19/03/2019, Tim Schumacher <timschumi@gmx.de> wrote:
>
> The case in where the revision succeeded to read, but it simply
> isn't supported by the driver, is untouched and it still prints
> the original message.
>

In that case this change is fine.

> I don't know why it fails to read the SREV register in my specific
> case (I tracked it down to a WMI command timeout, which seems to
> only happen on a Raspberry Pi 3), but having the SREV error message
> (which points to the actual issue) instead of the false-positive
> "Rev not supported" message would have saved me quite some time that
> I spent with debugging the issue, searching for the source of the
> wrong value.
>

Did you try some other device than RPI3 ? I've noticed that on router
and laptop while doing some htc fw builds.
