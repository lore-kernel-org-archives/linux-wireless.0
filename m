Return-Path: <SRS0=qzVA=X4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B322BC4360C
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Oct 2019 01:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CDF222C3
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Oct 2019 01:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="TtbR+j7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfJCBT2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 21:19:28 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40280 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbfJCBT2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 21:19:28 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so693536qkb.7
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2019 18:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWwUSoBB6gPOq9lnD1cBoM5LQLFJ2M8ddN6o2uZdkWw=;
        b=TtbR+j7bCceltYjMDybfhgl9NBDRpqKI3x9SzVu/Ck1CYDrWFvuQccT0+GXkXC/d3d
         s3pS8/a52lZ8olBRj5vpC7LeStougDvvJUaSvC5JtY2ceNHlQPCSEWme0wVvVSFbTLhb
         1oNkIhnkAb/w46tA+MCBLJXnsRQ5uqRBUzqEe9gmIHcq0yWjZKJTwJgnvpXK5CBUICiC
         84Ayn8J42A8zg63ElSrwspKODJTWwu4/4I4xAuyI+aPJcanmFvcUqKdHkj3zYw2t4EyC
         NNIp2CCXK4jszQ4YYKsAIcNdV43r6aMefhLFxIySOsGm8U1YaVPUmt/cGBGMee0/iwTP
         0kdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWwUSoBB6gPOq9lnD1cBoM5LQLFJ2M8ddN6o2uZdkWw=;
        b=lwiv1+vpZ57CMmc85J+WPjyUX30YJ6uTgrzOmASYEGsv1r/NgzIjSgif+j24sAg9JL
         /vDvHSHXpVUUY2JWnoykoa+ioTEf/sa1u2PUnDbcypmJD0ut0UtXIZ4UqSGRY4H9DthN
         p16uCcNMx+Yf6v8A0vp5GjRh+r4TheOG/mXGOdMFYrq/2rQudEKnG2ONk7pV7QQAo74I
         yTLacIR73TupmXcAhjNBoM5YYhH2X3iHsXKDMqq0vQh07b27tnorpuEMbgn8g1PAGL/S
         2A5/bYXTnWwUvVGvd7lSYVUBDoKmagc1NPpYB1cCw6xMsb6iCNF50SY5qeskkEQCo09K
         BR3Q==
X-Gm-Message-State: APjAAAWNy1B3V+IL33QzA4VCX6mtYvZxfXTdlrT9/oBjLJBM3zNESM4h
        rFLObacVcm2vWRRyf0wsM46oManNetT9QQyc4MSOwb/V2Zs=
X-Google-Smtp-Source: APXvYqz22sL8lrOMniBjvPKW06rVYdNY/jhvEGd6Z/Ys5kj0SD18SNJe3n7BydCu6WyxGhKRdzXC/7sePQYUNSSVqoU=
X-Received: by 2002:a05:620a:5ad:: with SMTP id q13mr1877015qkq.297.1570065566949;
 Wed, 02 Oct 2019 18:19:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190911025045.20918-1-chiu@endlessm.com> <0c049f46-fb15-693e-affe-a84ea759b5d7@gmail.com>
In-Reply-To: <0c049f46-fb15-693e-affe-a84ea759b5d7@gmail.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Thu, 3 Oct 2019 09:19:15 +0800
Message-ID: <CAB4CAweXfhLc8ATWg87ydadCKVqj3SnG37O5Hyz8uP8EkPrg9w@mail.gmail.com>
Subject: Re: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for
 single antenna
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 2, 2019 at 11:04 PM Jes Sorensen <jes.sorensen@gmail.com> wrote:
>
>
> In general I think it looks good! One nit below:
>
> Sorry I have been traveling for the last three weeks, so just catching up.
>
>
> > +void rtl8723bu_set_coex_with_type(struct rtl8xxxu_priv *priv, u8 type)
> > +{
> > +     switch (type) {
> > +     case 0:
> > +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
> > +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
> > +             rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
> > +             rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
> > +             break;
> > +     case 1:
> > +     case 3:
>
> The one item here, I would prefer introducing some defined types to
> avoid the hard coded type numbers. It's much easier to read and debug
> when named.
>
Honestly, I also thought of that but there's no meaningful description for these
numbers in the vendor driver. Even based on where they're invoked, I can merely
give a rough definition on 0. So I left it as it is for the covenience
if I have to do
cross-comparison with vendor driver in the future for some possible
unknown bugs.

> If you shortened the name of the function to rtl8723bu_set_coex() you
> won't have problems with line lengths at the calling point.
>
I think the rtl8723bu_set_ps_tdma() function would cause the line length problem
more than rtl8723bu_set_coex_with_type() at the calling point. But as the same
debug reason as mentioned, I may like to keep it because I don't know how to
categorize the 5 magic parameters. I also reference the latest rtw88
driver code,
it seems no better solution so far. I'll keep watching if there's any
better idea.

Chris
