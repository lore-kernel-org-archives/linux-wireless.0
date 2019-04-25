Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49480C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DCDC206C1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:01:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMx5zOQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731380AbfDYWBf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 18:01:35 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:34320 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730893AbfDYWBf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 18:01:35 -0400
Received: by mail-oi1-f177.google.com with SMTP id v10so1374842oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2019 15:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3TGPbTAaOeH9M4LcKcUiOGT5PEfFbSRGZ7jWA7Ib02c=;
        b=YMx5zOQrOnzKl9Ngel97sgNRj1o8Gadvj/u11vm5mTy61cnJNraYCzdmFYzewyMVuU
         umQT+raWM8uhxoI28MmdxWPqO2IrFziW4gDnacNumTB0ZW6tsxo4+MIZC3nLcCJcyvfi
         StWnjfZNVFHyL7XUeXqm1w+sM7Bcz435HgPlQEeRn286sVO38KLWflDn/YKCbDIloxP/
         TUOKdPUSz4MLx8cf8UxKmLgzPpZ4TZK5/XefgYC0yCHyGwDmj6JmePwBOojjsjQdPJUd
         VaU1hIj+R9GKMSnDW2wcmgUwYHVsYMH4YEsKEVyQjFLcptzG0hwXMpdFKPBoUul06r7G
         xcng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3TGPbTAaOeH9M4LcKcUiOGT5PEfFbSRGZ7jWA7Ib02c=;
        b=GvCGIu+/CRTxzu6ucNT2qlXoOeeNjJBo9k5n/r32Vx+Z3CXrhJ9IJmMh61+S47WP8u
         Uh93VIqyajCY1MLbwTkYvgFTzPXXKok/rbyTYsKVxn1qxZ0531L60JG253toWyEan+J7
         ykiq2VJCh0GjTJPw4Woic8xbJm4Rr8qo0hMtvmvjIA7m12U5EoDXj27rZfkX3yVXAfVX
         UO1FsVQke7HdFG4AglseThx1AyB95ocYox+AO7MNLVkyhIsv9dSi9HwiO1RZn0g78RSj
         /ppGXJIn0Qi9u8ZGrLIl3JbDwjlPwL5HKPTzWDDxLCU3348F3tqr7UC+e/TXMmCQ6k2o
         N0ng==
X-Gm-Message-State: APjAAAWXB6Ya/QdoowDqPeNBMvmZu8qDHbR/fqeM/pRuioXGBDbtjKq3
        WXDpa3J4tkF3Y8ZUcPYBQopGBS3ZkehvXqPfeZg=
X-Google-Smtp-Source: APXvYqxsP4oK6olhlLIc27aYe+J2mLbQlywXVxTe07Pv2ckbeyXGrVUiOTo7IgDIEOA8JjCHpwNhxXZEdRK7TtpNUCI=
X-Received: by 2002:aca:43d5:: with SMTP id q204mr5029647oia.13.1556229694246;
 Thu, 25 Apr 2019 15:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <2019040118074276659215@jaguarwave.com> <20190408124829.GD15126@ubuntu-xps13>
 <CAPuHQ=EvWzXtxk0fLOT6PyeYkcNOOXmw0ck-yT-JsqhhDmu2gA@mail.gmail.com>
In-Reply-To: <CAPuHQ=EvWzXtxk0fLOT6PyeYkcNOOXmw0ck-yT-JsqhhDmu2gA@mail.gmail.com>
From:   b.K.il.h.u+tigbuh@gmail.com
Date:   Fri, 26 Apr 2019 00:01:22 +0200
Message-ID: <CAPuHQ=Hhy8xushtttbD24aGHfiFV8tfrX7WFevzr+PjEnvMwEg@mail.gmail.com>
Subject: Re: [wireless-regdb] wireless-regdb: Please update regulatory rules
 for Japan (JP) on 60GHz
To:     "seth.forshee" <seth.forshee@canonical.com>
Cc:     "junping.xu@jaguarwave.com" <junping.xu@jaguarwave.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        wireless-regdb <wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

P.S.: last link should have been
https://www.tuv.com/content-media-files/japan/pdfs/1190-telecom-and-radio-f=
or-japan/1190-letter/60ghz2_1_19_4_2_1.pdf

On Fri, Apr 26, 2019 at 12:00 AM <b.K.il.h.u+tigbuh@gmail.com> wrote:
>
> This seems to be the page for the previous standard:
> https://www.arib.or.jp/english/std_tr/telecommunications/std-t74.html
>
> And the following should be the new standard, but I don't know where
> to obtain it:
> https://www.arib.or.jp/english/std_tr/telecommunications/std-t117.html
>
> The description fields here do note the range of 57-66GHz, though:
> https://www.arib.or.jp/kikaku/kikaku_tushin/desc/std-t117.html
> https://webstore.arib.or.jp/en/products/detail.php?product_id=3D288
>
> Similar mentions in the news (search for T117):
> https://www.arib.or.jp/image/osirase/news/1044.pdf
> https://www.arib.or.jp/image/iinkai/kikaku-kaigi/rireki/101.pdf
>
> Testing procedure is described here, not sure if it's considered useful:
> file:///home/bkil/chrome.root/Downloads/60ghz2_1_19_4_2_1.pdf
>
> On Mon, Apr 8, 2019 at 2:48 PM seth.forshee <seth.forshee@canonical.com> =
wrote:
> >
> > On Mon, Apr 01, 2019 at 06:07:44PM +0800, junping.xu@jaguarwave.com wro=
te:
> > > Hi Forsheee,
> > >       The 60GHz band defined for Japan was between 59-66GHz, but is h=
as been Updated to support 57-66Ghz about 2 years ago=E3=80=82
> > > However, the latest wireless-regdb still containning the original reg=
ulatory information  as below. Please help to check the infomation
> > > and update the regulatory.bin.
> > >
> > > db.txt:
> > > ......
> > > country JP: DFS-JP
> > > (2402 - 2482 @ 40), (20)
> > > (2474 - 2494 @ 20), (20), NO-OFDM
> > > (4910 - 4990 @ 40), (23)
> > > (5030 - 5090 @ 40), (23)
> > > (5170 - 5250 @ 80), (20), AUTO-BW
> > > (5250 - 5330 @ 80), (20), DFS, AUTO-BW
> > > (5490 - 5710 @ 160), (23), DFS
> > > # 60 GHz band channels 2-4 at 10mW,
> > > # ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.=
pdf
> >
> > The only change which is required to change:
> >
> > > (59000 - 66000 @ 2160), (10 mW)
> >
> > to:
> >
> >  (57000 - 66000 @ 2160), (10 mW)
> >
> > Is that right? Can you provide a link to the documentation which
> > supports this change? The current link above this rule appears to be
> > broken.
> >
> > Thanks,
> > Seth
> >
> > _______________________________________________
> > wireless-regdb mailing list
> > wireless-regdb@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/wireless-regdb
