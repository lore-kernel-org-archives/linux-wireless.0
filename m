Return-Path: <SRS0=6+7Q=6W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E36C38A2A
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 20:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 165A020CC7
	for <linux-wireless@archiver.kernel.org>; Fri,  8 May 2020 20:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGND2SCL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgEHUKb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 May 2020 16:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgEHUK3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 May 2020 16:10:29 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982CDC061A0C
        for <linux-wireless@vger.kernel.org>; Fri,  8 May 2020 13:10:29 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t3so2499044otp.3
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2020 13:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=coNQJNrmI2faa834NPS+bmucv8MUdxV8roS0obPmn5k=;
        b=HGND2SCLEm/kyhxGxVG2fPXwLiZBj3DFIBwgghg9Y9curK1CYkPQBEk9+5ESUlwALi
         r0HKZGTItNDrJSCYi4932OeoSJkE4tDbpA0Gtvbw1wgFq5db8CIarLdGEa2RPoPv+3x7
         fN1Y5EQ8SgkVa6v1U+LDBPheqXmNZ3RusGsGQBmzuGJi/2hzcQooDw0tuwuhmzSAv6m6
         cuw5iRHbIn1Q3NSvUL1LQaDHHHTzOOiC4PY+K0ZVrqdOHc7PSV/8Yixt7KJ2LrM/U1i8
         GAFBebJMalGLArxGMRfI2TtJ+SRFnbK9TGHZ8gX9ManNllnWfkTNeWj+kuYWsmhVy1Db
         0C6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=coNQJNrmI2faa834NPS+bmucv8MUdxV8roS0obPmn5k=;
        b=fK/4RXfmhB2qzMeLtAnOiHjvWhtdy/qlA47E1Rkg+QJazhETxpYJsxR4gKFZr7QSiD
         Ggg6CTj2fkUkYiksOP+PJVPDQQUtkRKmp+7h8cCasQPsYVc4OYeWSPlMmtVM5HPvIb20
         c5Bf3EkUC8c9Skq1d/Wf0ibqNHb2fBWJt5dxyDh+Ygpd8+q+mtxgnoDbfObih5HosZ2p
         Ks2BrWmmp+ivcexONDPQ2+HaGaejCB3dw9mtX7uPhw0MxnIxN7E0wxs3v3hASh1rkf1E
         oFkwjc34Axe0lDlsq7K1VufsrH11l1cTu4g1YTEgy5bTR9PRcUkokexCIRJ7wNtiPziX
         Xk4w==
X-Gm-Message-State: AGi0PuZv/VSef2BM1a4uUS8WqnuDsSCDO9HgWrDh3tlb0ehcNXxXhis8
        m0OQp4DoWXpedI0WxOJwuARG2QGSCmEnSXNzsPM=
X-Google-Smtp-Source: APiQypIA49bSl819Kbs0vIPfcPTOb/LIvOzKHQW2eSb1KQJfemSNxF6i0iliEs6HTgJ5pyl6kz3y0WqzBkpgL6mzB1w=
X-Received: by 2002:a9d:3988:: with SMTP id y8mr3416986otb.352.1588968628828;
 Fri, 08 May 2020 13:10:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200508140802.558267-1-luca@coelho.fi> <iwlwifi.20200508170402.c3e50c36c628.I991bfa662c0ef35de5be9eaf5b78ef190b67cb56@changeid>
 <CALYz8ypzgHqn+WY8KG-isYXJfymy4Jh7CSEXsg5KdiGEm+EAVQ@mail.gmail.com> <600179d2c1679b933e5129a3aac6c1f788a1c24f.camel@coelho.fi>
In-Reply-To: <600179d2c1679b933e5129a3aac6c1f788a1c24f.camel@coelho.fi>
From:   =?UTF-8?B?0JrQuNGA0LjQu9C7INCb0YPQutC+0L3QuNC9?= 
        <klukonin@gmail.com>
Date:   Sat, 9 May 2020 01:10:02 +0500
Message-ID: <CALYz8yozMjWmMVy9O277162n58MyD=NTLXAb0dVkLxR4-cnRew@mail.gmail.com>
Subject: Re: [PATCH 01/11] iwlwifi: set NO_HE if the regulatory domain forbids it
To:     Luca Coelho <luca@coelho.fi>
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Channels ON/OFF logic is OK.
But I (and possibly not only me) bought a lot of ax200 cards.
And now they all will work in 802.11ac mode without any reason and
without any chance to avoid such behavior.
That's something new, I think.


Best Regards,
Lukonin Kirill

=D0=BF=D1=82, 8 =D0=BC=D0=B0=D1=8F 2020 =D0=B3. =D0=B2 22:18, Luca Coelho <=
luca@coelho.fi>:
>
> On Fri, 2020-05-08 at 21:41 +0500, =D0=9A=D0=B8=D1=80=D0=B8=D0=BB=D0=BB =
=D0=9B=D1=83=D0=BA=D0=BE=D0=BD=D0=B8=D0=BD wrote:
> > Does it mean that wireless-regdb is not needed anymore and any vendor
> > can configure wireless stack from it's proprietary firmware?
>
> This is not new.  This is part of the self-managed regulatory feature.
>
> --
> Cheers,
> Luca.
>
