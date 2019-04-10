Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0228EC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B88512133D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:36:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ND0xdpHw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbfDJGgF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:36:05 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:45780 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbfDJGgE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 02:36:04 -0400
Received: by mail-vs1-f67.google.com with SMTP id o10so688777vsp.12;
        Tue, 09 Apr 2019 23:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AuWGolAMMAZafL8RYnlrJF+xQWZaarabExLsJCo3JUg=;
        b=ND0xdpHwHqHKk44vDk4ZIa/qzLgbvvwwrvgPEwRCttRGpOMvj+UECCEy21ZgxFWby6
         YlJ1fiQzIHgttmkHMCJbiY61o8f4098HzNg32V8Me/6WFCgJOsTA0D5ABzKv/vo6egmr
         AgVxNVhHSBEB1dhRqpqI37UrNWmShKfrb+OKxSFrL7Qcnb3/TP+O0rs2i/cLxwE4gAGi
         HsvAnxiNfsJQZWtyDbMBVPk+Y4zFMUT/GnOfKw+7fsh7I/ULgKgLgfDXeuNQUe9g9vYM
         D06TCVZ+L8HiLgZrvRS1f8VmNwUoAbA29CSFHcUkLj8IS9Vxcv+CcTszfihV2f8EYCr1
         PR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AuWGolAMMAZafL8RYnlrJF+xQWZaarabExLsJCo3JUg=;
        b=XMiS1iICE5xaUb6Y0EthP/icOOavUatifjxJtzVnKAY7Nh/ePIqujQfW9lo2frcxbw
         g2FfFIWdq1BNJ4Bq40vM/V6plbCqVcTNDqmkS0+cBOVgH9uvTvmHf/w+uQrHmyrAsJRL
         7eBsGt5omx7iwaxvG75xG/NaiSBgu+oqJpvJLxm2mStHO97eSbXM+quP+QocfW4YAY5K
         kvWtK7HZkRhLtiVWNU8ss5f3BnGroPyNWtA0zkY5t0gm+w30HuzGCMN1dxG4CxvuIezN
         07L8bm3+JDYKsgwDus2Hx58HVw2gpGDwyc8x0LcASjqVAPNy9idFIPuwhnQWssCDEfwv
         nY9w==
X-Gm-Message-State: APjAAAWyMXMsSbLC7/hi3NIX1lj5wfWZQOuPLp8f5kxC8knQ9DTeGSS9
        y4olTRGSsVyIpS/++B/Ba/WC38rittMfthf3b4g=
X-Google-Smtp-Source: APXvYqzoRWlgb+bMhAnsSniabx8ZtGJGadp4l4EPJ8sSIeJ+wm7QZzg/oIKrYZ9Phf6EN3oto7qkeErmN3H/iWMcUko=
X-Received: by 2002:a67:e20c:: with SMTP id g12mr24312796vsa.188.1554878163686;
 Tue, 09 Apr 2019 23:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
In-Reply-To: <cf07ae24c436f92769f9289d208f01846ebe8826.camel@sipsolutions.net>
From:   Vadim Yanitskiy <axilirator@gmail.com>
Date:   Wed, 10 Apr 2019 13:35:52 +0700
Message-ID: <CAPEnp=bHTVARr7WA9Qkq4=y7kk8_FLWhrkqKOEXubMO4X=BHCw@mail.gmail.com>
Subject: Re: gsmtap design/extensions?
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Harald Welte <laforge@gnumonks.org>,
        OpenBSC Mailing List <openbsc@lists.osmocom.org>,
        Sean Tranchetti <stranche@codeaurora.org>, radiotap@netbsd.org,
        Dan Williams <dcbw@redhat.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Johannes,

FYI, there already was a discussion about GSMTAPv3:

https://www.youtube.com/watch?v=vum9jzavZi0&list=PL07C78AF831FFE8F9&index=10

but unfortunately, nobody has invested time into this (yet?).

> 1) Why the design with encapsulating it in UDP?

This gives us a possibility to "demux" multiple GSMTAP streams on the
receiving side, e.g. if you are running multiple processes.

> 2) The format of gsmtap doesn't seem very extensible [...]

ACK. I definitely support the idea of using TLVs.

With best regards,
Vadim Yanitskiy.
