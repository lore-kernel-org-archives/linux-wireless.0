Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE9DC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 16:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 551052084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 16:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SXyz+cp9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfDIQaA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 12:30:00 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39238 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfDIQaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 12:30:00 -0400
Received: by mail-ua1-f68.google.com with SMTP id d5so5723078uan.6
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dqVrkebP9i8uuyqyr4MqTXK9lcw0lbYjOb+pihL7B98=;
        b=SXyz+cp9YUh+SITTF07b/RFtwdxCMRFTVxMVL+Wb7A66MpIeIV6Z63tQCZHdRmQ+3E
         LSwgMFrRHqJnm8xeqh+8fR/pysZYkDi0D9xly4o2p8LJLQj3behuV6hNylzsh8obwydb
         7YCF03C20P2tOm3lVuu4mwZ0acmp8KxzHYJes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dqVrkebP9i8uuyqyr4MqTXK9lcw0lbYjOb+pihL7B98=;
        b=XrI2jR9AJbkFEnEbzLlbvsnliO9puYl77E85EqfuFT1jvTaCBRZIQSOrkIXr7wGBsJ
         kZ1o8TljFMCjhNiqnsZhxuhYF/NrPik3GIJd1aTaKoRlBNnkSgbVnzXDSoniUJ40IfS1
         VaZWsNKsBcxU13jtu+2M2AQNpKD7b/DEcYOPqYg32PlhIMmQjTtPYZ3w9Bgrxi5axBoI
         GQcH+artxxShoDWHfpzGqFDJhDBmR/L+hhXAgRMU0w92HwvBYyJ/axEmwk2gg42mvHJg
         tih0M1MOZJv6h2MTQ1SQwnw28XoeNGvmRJCMyx67UceoaQuqg0AZKzqxqCS9d0ufV+Uf
         1bQg==
X-Gm-Message-State: APjAAAXVpwAffjBKBY5x+Vv40Jb1EAlcBUWdroHP+aMaRXTgV4nsFiYa
        asM2Tjd6zM1ImbNuTbpGZ/WWtI2eKl8=
X-Google-Smtp-Source: APXvYqx40mZnq2pAi+2sxul+G6NeP0mgufnUzGWMMgWthEhvf4m6m4LsrUND9HY0sNgWQu7un4FdJQ==
X-Received: by 2002:ab0:2708:: with SMTP id s8mr14164016uao.37.1554827398376;
        Tue, 09 Apr 2019 09:29:58 -0700 (PDT)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id j11sm9045038vkj.13.2019.04.09.09.29.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 09:29:57 -0700 (PDT)
Received: by mail-vs1-f54.google.com with SMTP id o10so7588776vsp.12
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 09:29:56 -0700 (PDT)
X-Received: by 2002:a67:1345:: with SMTP id 66mr20102814vst.30.1554827395980;
 Tue, 09 Apr 2019 09:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190213185741.GA5047@embeddedor>
In-Reply-To: <20190213185741.GA5047@embeddedor>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 9 Apr 2019 09:29:43 -0700
X-Gmail-Original-Message-ID: <CAGXu5jLaZ3czP9YDJ9R+3UeBxuULubBPcnFNdh+qT_S9D5eZZg@mail.gmail.com>
Message-ID: <CAGXu5jLaZ3czP9YDJ9R+3UeBxuULubBPcnFNdh+qT_S9D5eZZg@mail.gmail.com>
Subject: Re: [PATCH] NFC: pn533: mark expected switch fall-throughs
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 10:57 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> In preparation to enabling -Wimplicit-fallthrough, mark switch
> cases where we are expecting to fall through.
>
> This patch fixes the following warnings:
>
> drivers/nfc/pn533/pn533.c: In function =E2=80=98pn533_transceive=E2=80=99=
:
> drivers/nfc/pn533/pn533.c:2142:6: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]
>    if (dev->tgt_active_prot =3D=3D NFC_PROTO_FELICA) {
>       ^
> drivers/nfc/pn533/pn533.c:2150:2: note: here
>   default:
>   ^~~~~~~
> drivers/nfc/pn533/pn533.c: In function =E2=80=98pn533_wq_mi_recv=E2=80=99=
:
> drivers/nfc/pn533/pn533.c:2267:6: warning: this statement may fall throug=
h [-Wimplicit-fallthrough=3D]
>    if (dev->tgt_active_prot =3D=3D NFC_PROTO_FELICA) {
>       ^
> drivers/nfc/pn533/pn533.c:2276:2: note: here
>   default:
>   ^~~~~~~
>
> Warning level 3 was used: -Wimplicit-fallthrough=3D3
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> Addresses-Coverity-ID: 1230487 ("Missing break in switch")
> Addresses-Coverity-ID: 1230488 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

--=20
Kees Cook
