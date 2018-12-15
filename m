Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D51C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77A762084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XFCe4gV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbeLOJLs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:11:48 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:50231 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbeLOJLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:11:48 -0500
Received: by mail-it1-f195.google.com with SMTP id z7so12484824iti.0;
        Sat, 15 Dec 2018 01:11:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwIC/oD048MqZ850x9+8RTF8LoL/W8/w4ryKmWzrwmk=;
        b=XFCe4gV6EXRIsCzefRdQuteB1EnPKlku9UcAg7Z5EcsiP0ivsFDVRARdBUJDH0eCQw
         zbCftZfiGKMotMXG1yaFNiTjvRLeXMJyQh7wUEBqyT9q5iY+kbVAWrIuJ/th/E4UdcSB
         Rb8LbjCbR+I/2KPeezG2erTh2My3GdP9Px1R7zf/O0VqiKmXyrYHWmqjACqbpunZBXQ/
         gNTprOlAnDak78H846DeeoFMzTIROT91m2mME6KDivLVSli/nFfvtYEnAMzy9OzIAaqC
         LWR1WS2AiysbXmoVqUFvDg7FrXIdjCyPh3ock/z/xLN2/l64FYUuUIJhmfdPYlaLAS66
         z30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwIC/oD048MqZ850x9+8RTF8LoL/W8/w4ryKmWzrwmk=;
        b=SrPjUSMtWG6YTXhb/UirtL5H6lDGACXSW2FDB7VHNsz8hadk+LHOg/af0LxCxGrY7x
         ZC+wVZpN/4PqSmskltPNOGrO5GDfLiqx1iiyO+vp/JeiYlWmVuCiw+CNntyY+KRHK5zF
         49av/aB3FVBs27SgARPOq3OSuo2CvAkFv3ub6sGPp2hih00yjVuxu6JXQPTutFQWzaX1
         5l2xwo9fG79qWGYa5C95axn/CBOr3XPiDJTCYeYZjy3pq0VM5XtKb1FUYAAHkRPWG8Tt
         6kb7TYzBk8x2qRX/2AddotoACtgMsh/i0bmkYDpZbsF+rwmCJ3kIHTeXpM51MiUbaWAm
         ZZgA==
X-Gm-Message-State: AA+aEWZqoC1w2cFfrwuLG5lTDYFUO1H33hmg5r1YUaj5OK2YW/G52+iD
        ixIpSYJ5GdntQcVzjBh/Y6ww0tY2PaUAHJZCp1c=
X-Google-Smtp-Source: AFSGD/Xtkh5yrfBuGb8MpXZIZaMTX0fFeNBRTtHQpWyv4oD5su3H4TWEoe2JuL5owZItQnSRLfKZPUcyikBxtc5IahY=
X-Received: by 2002:a02:9d27:: with SMTP id n36mr5319250jak.30.1544865107383;
 Sat, 15 Dec 2018 01:11:47 -0800 (PST)
MIME-Version: 1.0
References: <20181203134028.12645-1-tiny.windzz@gmail.com> <a8daff3575d4682107dede1f07bf98470acb98ff.camel@perches.com>
In-Reply-To: <a8daff3575d4682107dede1f07bf98470acb98ff.camel@perches.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Sat, 15 Dec 2018 17:11:37 +0800
Message-ID: <CAEExFWvtMsYkMR5gzCF6rrRKFX_Z+wuZTO8mXwEodsR8CAAFuw@mail.gmail.com>
Subject: Re: [PATCH] mt76: convert to DEFINE_SHOW_ATTRIBUTE
To:     Joe Perches <joe@perches.com>
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 6, 2018 at 2:09 AM Joe Perches <joe@perches.com> wrote:
>
> On Mon, 2018-12-03 at 08:40 -0500, Yangtao Li wrote:
> > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>
> Thanks.
>
> Are you doing these manually or using some script?
In fact, just use grep.

Yours,
Yangtao
>
>
