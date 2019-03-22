Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD46C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B851C218D3
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 14:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="trzRBHQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfCVOVC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:21:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33450 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfCVOVC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 10:21:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id k14so2707458qtb.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 07:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ENprK18xRtJX3XAIJr6i8kyq6dyBqXCzAC3KK5K0I1k=;
        b=trzRBHQAkhSf89klE1YFw3dHmhDIbDgDY3FTv7txU24xvMwMmYfiOr/SHCXo8lzH+2
         KTM6JuDANdBA/TdjDNgvranFKKBSzwV9UPmCY2hWo+ajYAEtdmU8R99dj3nHZDxyv6Al
         H5oYAG7xIR8uB/Drs/MlsPILLoFLu4vkTz+TFganeTe3Dqkq16o6U8OM8xxgvUpNoT7N
         QyocmL/Y7nR3iKNUhRnQa9kX7VTWKvHUMgB4ba3SGpz4JNmNCooLeLVs3mKYxlduQQLl
         LMtgipM3td/j3WY/4Bsa9XwySZ0R9NPlUqiGW6871Aarhvpd4W0PAo8LVvapAIIfLeBG
         Q8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ENprK18xRtJX3XAIJr6i8kyq6dyBqXCzAC3KK5K0I1k=;
        b=am9ZirYHZKncwYyWzn+7meHQlHnmDanNcp/qVDx9p/BKwmJ+btP7e1bnMUCMHBobNn
         gcxx1AbnsxPlKVgrFuKS2+uR9sP0l6Yg7XDPq7gK30bxW8+EfehqP4XIhmBs1jdKjZNV
         Q5D36netnNyXDCger18Rd2lemFcUA/D6b3inXJdOcw2JU+iNPSzUqk1vhg9zeL8tgi44
         qEjalr4q13H7nZVjBfmnzCfRZLRgGt3EgRjFKcIbBDjdqchCJjhsBWT8cIKbkSIxM/Ew
         W0qCXccTjpG75GEsLotv4R0y9rLBtreBIXI9UEx2fLYr/15nOTskVnr1INV3hyeriX6V
         QDrg==
X-Gm-Message-State: APjAAAUxhTtTNCWO7sSATPgj1Ks1T1O+69ylcM4yZ/WdQ5ziy18mfVSm
        wieulvfuyeRsImdULg5CVtRY83p3k+ufeefxoyE=
X-Google-Smtp-Source: APXvYqyBDe511SLsFTCM/KcHnBpfiMMZjfnC7QlxdWGgsYexcRCz2Sixdh+EoWm9E/+zzX3QRe5dCUFVRcgsJaE/iuY=
X-Received: by 2002:ac8:2392:: with SMTP id q18mr8272238qtq.11.1553264461596;
 Fri, 22 Mar 2019 07:21:01 -0700 (PDT)
MIME-Version: 1.0
References: <CANP28d09JUQRB-iCBAGgkzv3zZ6k+irNB3uMYW3teN5xLX-eWw@mail.gmail.com>
 <CAKxU2N87ghf5kFoUN1Ru57SNoyV=S=-NUpaPP6LTSgvAu_nscA@mail.gmail.com>
 <CANP28d25-VKjsxtd423JQJqdYiyPs9WUU6AKc6qeLsO=02CJCQ@mail.gmail.com> <5e04d03f8f7cd65073215f395e40fdc2af0a7704.camel@sipsolutions.net>
In-Reply-To: <5e04d03f8f7cd65073215f395e40fdc2af0a7704.camel@sipsolutions.net>
From:   Raul Siles <raul.siles@gmail.com>
Date:   Fri, 22 Mar 2019 15:20:50 +0100
Message-ID: <CANP28d0o+s1mpuU0y-BWfU33m_M6dptcqc3UDQ7UfEeWqHqF0w@mail.gmail.com>
Subject: Re: Wi-Fi drivers/chipsets supporting 802.11w / PMF / MFP
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Rosen Penev <rosenp@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Trying to sum up what has been shared (a few weeks ago) in both the
linux-wireless kernel mailing-list and the hostapd mailing-list, a way
to find Linux drivers with support for 802.11w / PMF / MFP (required
for WPA3), including both mac80211-based drivers and cfg80211-based,
aka fullmac, drivers, is:

https://elixir.bootlin.com/linux/latest/ident/MFP_CAPABLE
https://elixir.bootlin.com/linux/latest/ident/WLAN_CIPHER_SUITE_AES_CMAC

Cheers,
--
Raul Siles

On Thu, Jan 31, 2019 at 8:29 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2019-01-29 at 18:31 +0100, Raul Siles wrote:
> > Hi Rosen,
> > Thanks for the reference! It is, indeed, a great and accurate way of
> > keeping track of Linux drivers that are MFP_CAPABLE (Wi-Fi PMF, MFP,
> > 802.11w).
>
> Note that this is only true for mac80211-based drivers.
>
> For the others, you'll want to check if their cipher list mentions
> WLAN_CIPHER_SUITE_AES_CMAC.
>
> johannes
>
