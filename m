Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D25C07E85
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 15:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DA2C20849
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 15:29:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p1J2UUhQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DA2C20849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbeLKP3G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:29:06 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:34047 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbeLKP3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 10:29:05 -0500
Received: by mail-it1-f194.google.com with SMTP id x124so11117604itd.1;
        Tue, 11 Dec 2018 07:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P82AFJBXUJDbfFh2Fk/+3Y8wdZYehvshFT2oSud2Kr0=;
        b=p1J2UUhQJcH5VmeK5yykGw0t+qzgaKrEbS6RS9qP0/LAzSkX9rWl2dP2wCinE6KBe6
         hCVSakRBkcvaxKVpyT9KC/0u2s+EU0UgwAr2VZPXIFqkWeLXUHKdcK0AP9aXtF+9y1iT
         3bNgVw/a67nu4WzQVBoj0Xh8LRp5/7cs0N9AwJPkRFI8s/5UDW1WetYzzTC5DoxU5Q9W
         Zv6qKWrhFIUu9B2r0W4PatsfkrkSGfl1mC3wKO9eig4GKds7hCYB6k60ysuJIabw1ztW
         RBISqEqUJ6RyN5wcAfso+IJdBvFEWmKpY8dXEZ7puQo1VvjhnEVYE22qcpuh5p+m1ZQp
         HO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P82AFJBXUJDbfFh2Fk/+3Y8wdZYehvshFT2oSud2Kr0=;
        b=ZRtOQqpN0ZlOkQPOpcNpTf/B+MY4q+0x7yWJupC/rcwxN55/kse+hHgxnRmWF06mWD
         RmIafxGyElS8ogcFiCjW7QkHOCNdIWU9Z1Hntnpombs3UMR4mNYCwRZJ0sfEo2JeYeMB
         HS2tQQtkVVwTFj6MY9x8ZMrfOzVn1Ew7hAMp6QSEReyPS9rFvZCHUJB4MSQJy0KOgaQ1
         wiPqJRVoHp2kHW0PAADgp9NxKOcJRd8otK00zE+ECagx/7BPd/+G5UUWOqHi8V0WKYkl
         UJPvf/JxLDmA9BIqrK+JWE6WTi1RCX+sUsqa+WqpIQGBd4DXaa1B5GVX7BJswC/iATMm
         Ar4Q==
X-Gm-Message-State: AA+aEWZmyDX8aXxk4PomV5nEHOmeIuSYva2rPrk5wr51B3fstWa9DSQf
        gGpQnGPpRWyHAdjv5eSqhk6CmbNnNzsrMAIrKk0=
X-Google-Smtp-Source: AFSGD/U+vaJ/kJUa/aY6O6tX6SGIxJ+NnHc94HL+EodIb90ovi7n7JGwOiEf2eVAKNg+oadO4KIKoZ0yqoVQnjW3Pig=
X-Received: by 2002:a24:7b90:: with SMTP id q138mr2439323itc.37.1544542143796;
 Tue, 11 Dec 2018 07:29:03 -0800 (PST)
MIME-Version: 1.0
References: <20181203133145.12430-1-tiny.windzz@gmail.com> <87zhtmenno.fsf@codeaurora.org>
 <CAEExFWusB4uNfqvyk-zbQeCJnizgFf73qK3a79NhEMGrTnnfqg@mail.gmail.com>
In-Reply-To: <CAEExFWusB4uNfqvyk-zbQeCJnizgFf73qK3a79NhEMGrTnnfqg@mail.gmail.com>
From:   Frank Lee <tiny.windzz@gmail.com>
Date:   Tue, 11 Dec 2018 23:28:53 +0800
Message-ID: <CAEExFWtNiirPHmtCYv=sPBBjXrAs4JJbDSe3A-SzFZeC=ctgyA@mail.gmail.com>
Subject: Re: [PATCH] wireless/cw1200: convert to DEFINE_SHOW_ATTRIBUTE
To:     kvalo@codeaurora.org
Cc:     Solomon Peachy <pizza@shaftnet.org>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Dec 3, 2018 at 9:43 PM Frank Lee <tiny.windzz@gmail.com> wrote:
>
> On Mon, Dec 3, 2018 at 9:38 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Yangtao Li <tiny.windzz@gmail.com> writes:
> >
> > > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> > >
> > > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> >
> > The prefix should be "cw1200:", I can fix that.
The same.

Thanks,
Yangtao
> >
> > --
> > Kalle Valo
> OK.
>
> Thanks,
> Yangtao
