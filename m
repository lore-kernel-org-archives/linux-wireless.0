Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1592C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEE2C218AC
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 10:25:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aENM7e2Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfBAKZH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 05:25:07 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:40915 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfBAKZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 05:25:07 -0500
Received: by mail-ua1-f67.google.com with SMTP id n7so2036500uao.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 02:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e7n5YspuzjUH40fWV9mr57w05g1TO3vCgQ91vQXy2XM=;
        b=aENM7e2QhSgDulh8l7HLsVFuqL/mZA878aXuA+Jtd9PaPSDa5pK3kGzcztpXOccnji
         519kl/Lyia3GBFU+2dzpkFDV8xkCmGtczwCHCRmayD/ZArm9YpfU0U9AkZxQfW3cjQCt
         xOOT0GNFfKIjNX+om9rX/Au4P6qS3klY+LQaFfa48NYEPyb3+eIf9M9oGQRYM4HNhX6r
         cL7i6c46IeI74aR6o/QW4zDG/1ukAkjBBxVGxtwgcwBN9BCaMXNiE+jylwYHkNQf5MyM
         0qeYb4NaMhFRomS26xn1lO/IOYp98Uf7cwe8mQ85wQMSWfvlBJ2DLQkEcZlXdDTWSAKC
         tTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e7n5YspuzjUH40fWV9mr57w05g1TO3vCgQ91vQXy2XM=;
        b=ZX1FxBjmJTBIu2txOf0wdLus3GnWF2IsS4bC0+i+0E4y08TtESHDs4KJzXo4QFPad9
         Ow+j/sww2RWh+SEN8iQ9XXHqRekNuRTD0l4D5fPXehogcz1dyCAL9T2uPKrsWKzGZKUS
         KHBr9O1RAVDMxaF65LCgi/vgaUhLxxCAo1DenZbRW5hsi5F901pAHYXu5+2b4f/Wt9QT
         ou9h9lkSqwCvXRZ5VV3lAr89SlQ3rnTI5hR3odaPoT86vilfdThGd9/J5W/CMhbS10Wk
         BYDAIrxKihf3v6tonXkq5dPIkxEid4hHC5lXGVBl39A/pb5UqjjNGPKLWPDhtdlTAz03
         R9Fw==
X-Gm-Message-State: AJcUukeXEabxvI77dmepcd7x9xBioii6uyvV2/awrCHND4pH/7M6uf1V
        /bUn0dKW9e+lA8sA+K1cYE3gEmyQayFlRxtxRzU=
X-Google-Smtp-Source: ALg8bN4Th8jju8bu86byayZmF7DXiwxED1TXLQ19da+XCBLe9i4i2pyWiaFRS9/cx+0qY6zkAjZXYKXj65yK9Pf1NlY=
X-Received: by 2002:a9f:2709:: with SMTP id a9mr16046725uaa.10.1549016706400;
 Fri, 01 Feb 2019 02:25:06 -0800 (PST)
MIME-Version: 1.0
References: <1549014070-3930-1-git-send-email-siva8118@gmail.com> <87tvhnhlqn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87tvhnhlqn.fsf@kamboji.qca.qualcomm.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 1 Feb 2019 15:54:54 +0530
Message-ID: <CANGSkXQ5YtmG8uLzsn4J6iOPP=jSdp1Hqsu9vzpbSH2jX8dfAw@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for redpine wireless driver
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        amit karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,
On Fri, Feb 1, 2019 at 3:30 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Siva Rebbagondla <siva8118@gmail.com> writes:
>
> > From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> >
> > Create an entry for Redpine wireless driver and add Amit and myself as
> > maintainers.
> >
> > Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 32d44447..c4e8fb4 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16923,6 +16923,13 @@ L:   linux-mm@kvack.org
> >  S:   Maintained
> >  F:   mm/zswap.c
> >
> > +REDPINE WIRELESS DRIVER
> > +M:   Siva Rebbagondla <siva8118@gmail.com>
> > +M:   Amitkumar Karwar <amitkarwar@gmail.com>
> > +L:   linux-wireless@vger.kernel.org
> > +S:   Maintained
> > +F:   drivers/net/wireless/rsi/
> > +
> >  THE REST
> >  M:   Linus Torvalds <torvalds@linux-foundation.org>
> >  L:   linux-kernel@vger.kernel.org
>
> Like documented in the beginning of the file these should be in
> alphabetical order. Please fix and resend.
Huh. I missed it. I will keep maintainers names in alphabetical order
and send you again.

Thanks,
Siva Rebbagondla
>
> --
> Kalle Valo
