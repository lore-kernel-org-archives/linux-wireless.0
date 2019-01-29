Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8265DC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4940721473
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 17:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pDWw/vXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfA2Rbc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:31:32 -0500
Received: from mail-io1-f42.google.com ([209.85.166.42]:39424 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfA2Rbc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 12:31:32 -0500
Received: by mail-io1-f42.google.com with SMTP id k7so16955566iob.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 09:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=08JUjs9Yd58NLXvkT+U//1fr6V8E6m1nwuq5WsHHID0=;
        b=pDWw/vXtbikDRQpkiXcjrYIAwVEIxJEoPSP2RgS3e8QqmB5vEcNo/79TO4LkZ2Bts6
         t0QOTHZ8Wk5M8VDHLPFWNK73t22LAb60VdCacETbrjBSvE6Y2yokZnmcF/QJBdiw7t8g
         7e9Rwl5IZ4/YsMq+ClxOkX+cdK/Ppxr6fFtNgaVwIQg/a8OQZLFFKaL5QNmDbeuopnS5
         J14HyEIrMadZbct3zFdCvLbTiL64/ggdtP08NUnhrPNFTjCKSUu3dS2rkSejJiDYzi6Y
         eWsU8AkvNIDgBPzhPaDfP8Y7aJ9yMOKkS05Riy8RpJCWH0T18/VtTCj/RpNRfbmm8W8N
         bBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=08JUjs9Yd58NLXvkT+U//1fr6V8E6m1nwuq5WsHHID0=;
        b=O2RM474KtfIGhU2x5AzWbKNsGoxXp74a7eaVrf/8NxIU3ZYUj/BMzlD8o57hL4R+vH
         r9rHnI4nYpTi38JuhhKRRtO4lYHVAs37VrObyUAqgMDXndvK2jYe8H2hEXsYzCHEmvry
         J59zzGK57fXg1gp8DSzqmp+9uBAJgSIyTOkfD12s8WFbz5LPBAiGHTtv+/fctagKbqpP
         BwoR4UHursyEJsQ9jkwPdNedXYy0EDMVRSfVc8/s/ByX+ArdsvRzzFVJfg6SOWOhttgg
         oxYCWbppE36LbE4EM03JQTrV/2qLfLhy4Rg5MbKAbTqB7DEGNgX9IjUuWqeRQGes2UL7
         Ug+w==
X-Gm-Message-State: AJcUukeNy0pmCMy+qNBJG7Nsz+h72CVR/Ps23fR83nJ2zmzKO4vKK7vD
        AOgeZ9kZ3b4qM56HrJfehuk6fMjAtQoqblGWFvg=
X-Google-Smtp-Source: AHgI3IYy/Mush9bM3KTZ77U4buplEmg1XVxw+ZzXESArd1hRDRhO5Dv55ONz4uHc7/7wly5m1qMBuoAmTVWR4vdXCKc=
X-Received: by 2002:a6b:5b12:: with SMTP id v18mr16406920ioh.157.1548783091398;
 Tue, 29 Jan 2019 09:31:31 -0800 (PST)
MIME-Version: 1.0
References: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
 <CAKxU2N87ghf5kFoUN1Ru57SNoyV=S=-NUpaPP6LTSgvAu_nscA@mail.gmail.com>
In-Reply-To: <CAKxU2N87ghf5kFoUN1Ru57SNoyV=S=-NUpaPP6LTSgvAu_nscA@mail.gmail.com>
From:   Raul Siles <raul.siles@gmail.com>
Date:   Tue, 29 Jan 2019 18:31:20 +0100
Message-ID: <CANP28d25-VKjsxtd423JQJqdYiyPs9WUU6AKc6qeLsO=02CJCQ@mail.gmail.com>
Subject: Re: Wi-Fi drivers/chipsets supporting 802.11w / PMF / MFP
To:     Rosen Penev <rosenp@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Rosen,
Thanks for the reference! It is, indeed, a great and accurate way of
keeping track of Linux drivers that are MFP_CAPABLE (Wi-Fi PMF, MFP,
802.11w).

In fact, it is the same driver list as the one in the latest stable
Linux kernel version (v4.20.5):
https://elixir.bootlin.com/linux/latest/ident/MFP_CAPABLE

Cheers,
--
Raul Siles

On Tue, Jan 29, 2019 at 1:21 AM Rosen Penev <rosenp@gmail.com> wrote:
>
> On Mon, Jan 28, 2019 at 3:15 PM Raul Siles <raul.siles@gmail.com> wrote:
> >
> > Hello,
> > I already published the following message in the
> > hostapd/wpa_supplicant mailing list two weeks ago without any success.
> >
> > Is there any resource publicly available with the list of Wi-Fi
> > drivers/chipsets providing support for Protected Management Frames
> > (802.11w / PMF / FMP)?
> >
> > Based on my testing, PMF (a requirement for WPA3) works with the
> > Atheros chipset and the ath9k driver.
> >
> > However, looking around for compatibility with other Wi-Fi cards, I
> > have only been able to find the following references (aside from spare
> > patches for other drivers, sometimes mentioned in this mailing list):
> >
> > https://wireless.wiki.kernel.org/welcome?do=search&id=11w
> >     ath9k: https://wireless.wiki.kernel.org/en/users/drivers/ath9k?s[]=11w
> >     p54: https://wireless.wiki.kernel.org/en/users/drivers/p54?s[]=11w
> >     carl9170: https://wireless.wiki.kernel.org/en/users/drivers/carl9170?s[]=11w
> > https://wireless.wiki.kernel.org/welcome?do=search&id=mfp
> >     ath10k: https://wireless.wiki.kernel.org/en/users/drivers/ath10k/mesh?s[]=mfp
> >
> > What other Wi-Fi drivers/chipsets (or specific Wi-Fi cards) provide
> > support for 802.11w / PMF / MFP?
> https://elixir.bootlin.com/linux/v5.0-rc4/ident/MFP_CAPABLE
> >
> > Thanks!
> > --
> > Raul Siles
