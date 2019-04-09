Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BA6DC282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA452083E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 07:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qiY4oaPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfDIHfQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:35:16 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39217 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbfDIHfQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 03:35:16 -0400
Received: by mail-lj1-f193.google.com with SMTP id l7so13526144ljg.6
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 00:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LwZvRAwjz4v8vPB24QlTXxeUwtfYiSirjEGXsASLuDU=;
        b=qiY4oaPqfTf3/T5SoWvYI3WlshrEYkpjv2JCk0cSXN0x3+9uYxuPhNpoaXzBdP/2pZ
         i3H02EljbkFGq/t3Y8IqsVkruIXLQXBoSVKplchUd8OqnaqZx+aI8/xwceEie3FvBDCD
         94DmzuKY1qVSlkR1Kaj54A2mXNHpuFCrucKGgMAbK1TNPXv/yxqG/mMHGZTDuHTMcyJC
         99ChYKuH6ggalX7x3ORcS6JTSHWq/GYZ9zIHVN2pbKck0INFDIbL6b7rpvNO5nMChIpi
         VFvs6Ia+ky6Rz7Ejuph8IKjM3RzSCE461aU2JnaQqUHopH7nzs2XFYBpFn8IvcGjstkF
         TVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=LwZvRAwjz4v8vPB24QlTXxeUwtfYiSirjEGXsASLuDU=;
        b=VMNWgVTU/NpZISIF+JwPG6EnLFoHhL9BRP+Dr7dIgYFG5+0/x8sMA4+qhoHGeQWcsk
         PWVA/9JQiVYnZ0ChOxQaspltMy0JP9Y/aYpw5oXFPQ5q4A9Ky7ahabSOeUzQlt69aZCX
         RlTYXklqTaAC8akpt/ULzbEBsuumnEQd5tyzDwXyB6ncpyicxMpgVErPh/7wV0PaNG0h
         DY4UkB1u26J5onbW3DWVHlJXJpG8vskKfjD+OyPiVhUSm5laoBc6QS1BG88GA8rXRahj
         0f9QVzEs6ZeyWdOv/ZZFQQzj06afBtZ2FxYPHfMRAqgIe3DblUFAqqyYunm/gXKD5MFL
         YMtQ==
X-Gm-Message-State: APjAAAXkwwjRyCZxviAswlmp1QmIH5M6LJaCbuYEZ5KNZQq8ME3tq125
        F4pj/ilLGeDkEm1mGQyiVa58wRUPOfdiXIddXltSAw==
X-Google-Smtp-Source: APXvYqzfKNqys0GobM4u8jt3J6Oyk6PGtVt93Q142DP3RUNDDo20Kd4Qq4bUK7ups+7NTewIUvriXKCZWEUt9gzGB2A=
X-Received: by 2002:a2e:9a46:: with SMTP id k6mr18301188ljj.119.1554795314005;
 Tue, 09 Apr 2019 00:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190405234514.6183-1-megous@megous.com> <20190405234514.6183-8-megous@megous.com>
 <20190408074042.74s5qckukcpore3e@flea> <20190408232232.fsl2ddthwo2rr4ql@core.my.home>
In-Reply-To: <20190408232232.fsl2ddthwo2rr4ql@core.my.home>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 9 Apr 2019 09:35:02 +0200
Message-ID: <CACRpkdYGdLEeX8aBJfPQg=8OHcQR_uTJoA1FaO5p1od+VX2Nzg@mail.gmail.com>
Subject: Re: [PATCH 07/12] arm64: dts: allwinner: orange-pi-3: Enable ethernet
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 9, 2019 at 1:22 AM Ond=C5=99ej Jirman <megous@megous.com> wrote=
:

> > > +                enable-active-high;
> > > +                gpio =3D <&pio 3 6 GPIO_ACTIVE_HIGH>; /* PD6 */
> >
> > Is enable-active-high still needed? It's redundant with the
> > GPIO_ACTIVE_HIGH flag.
>
> Looking at the code, use/non-use of enable-active-high inhibits
> flags specified in gpio property. So the GPIO_ACTIVE_HIGH flag
> is ignored here (had GPIO_ACTIVE_LOW been used, the kernel would
> ignore it too and print a warning).
>
> So enable-active-high is still necessary here.
>
> See comment in gpiolib-of.c where this is handled:
>
> /*
>  * The regulator GPIO handles are specified such that the
>  * presence or absence of "enable-active-high" solely controls
>  * the polarity of the GPIO line. Any phandle flags must
>  * be actively ignored.
>  */

Yeah this caused me special headache in the current merge
window because of buggy code on my part.

This is an effect of this flag being defined for powerpc
ages before we properly implemented generic GPIO
bindings. We just have to respect it.

See:
https://marc.info/?l=3Dlinux-gpio&m=3D155417774822532&w=3D2

Yours,
Linus Walleij
