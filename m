Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAD0C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1023E206C1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 22:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfm3gjpX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbfDYWAf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 18:00:35 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:33276 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbfDYWAe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 18:00:34 -0400
Received: by mail-ot1-f43.google.com with SMTP id j10so959184otq.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2019 15:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ujtvJ/9PDIqeiq5UxgJWwwhWv7xUD47/azUxfErybE0=;
        b=mfm3gjpXaBopyN7vUvYPfZ/5KLqhbGEiVHv/NtAEdKYXj91KnaNFknYpIzSwUZneab
         bP3TRPxoWN0X5oSqacDqseAtP2KvUx2jwc813vGYF+2mUpEsgjCg4f/BA6HW0jER97jq
         CiuO4HdAgXpn+0NYqBJXgt4yxixbWj32Fyoh6lrh7fnyF9/6TqiTlv41l3klkR3c+IG8
         Cp0U2Twv0cTkMoQE97E8Vu3vZ9qH8H9Ay+YJEUZ/NHuXJ/GJM0sb7vuClNdnIWQrWydp
         eZ4m7h6A8zKi5lsnqKGP3Lp5uoGddLotN765eWIFPiG7t/ERdoZZ6VdLPUkEozUqy+2C
         3GHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ujtvJ/9PDIqeiq5UxgJWwwhWv7xUD47/azUxfErybE0=;
        b=Xt/Kp62VFE5JHtZYezbHW88ocEpzctwErqkQmXm6hSLQYiLCrsthHj++bxiS+wQKSB
         q2yy6dyPLR02JuDyz18hfseojeTdHGlbZI4OL8bYhTlVyFVjLeicA8TewpDK34ASAfzl
         XMu03MPZGuj1emzSGS74WZOg0AWECLUKLUKYVNbbmw+J+eKOh29wYKQUpzSYHLNpE32S
         k8i7CEGCwOOm0taY3flhI4HERL6OrVZkKY+CoF+kKMwmvFNYwyHH5TE6ldWfk2QhrOfJ
         0o4siUmRoikxeIBppjqJluuI7cE3bDfGfko9h4wak23Epf1TRFw2856141aCczzq318k
         B5nA==
X-Gm-Message-State: APjAAAXiKyeq4FPKf5nNgBNjdGOtOxD3tQTTPFH/NMkepcGuP6o/O+Ag
        9tIMZdshZD7yad5kDqvuwjLXKxvLMgJtEYBaUPQ=
X-Google-Smtp-Source: APXvYqzylk0qEMBuafWGWVBF4ggFpdhE/+WUdHISczneTpUas9nmSsDY+peuJlP4QEB1QU+Uq8Tli20wq0CIr5oPLtc=
X-Received: by 2002:a9d:3de5:: with SMTP id l92mr24765813otc.200.1556229634072;
 Thu, 25 Apr 2019 15:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <2019040118074276659215@jaguarwave.com> <20190408124829.GD15126@ubuntu-xps13>
In-Reply-To: <20190408124829.GD15126@ubuntu-xps13>
From:   b.K.il.h.u+tigbuh@gmail.com
Date:   Fri, 26 Apr 2019 00:00:22 +0200
Message-ID: <CAPuHQ=EvWzXtxk0fLOT6PyeYkcNOOXmw0ck-yT-JsqhhDmu2gA@mail.gmail.com>
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

This seems to be the page for the previous standard:
https://www.arib.or.jp/english/std_tr/telecommunications/std-t74.html

And the following should be the new standard, but I don't know where
to obtain it:
https://www.arib.or.jp/english/std_tr/telecommunications/std-t117.html

The description fields here do note the range of 57-66GHz, though:
https://www.arib.or.jp/kikaku/kikaku_tushin/desc/std-t117.html
https://webstore.arib.or.jp/en/products/detail.php?product_id=3D288

Similar mentions in the news (search for T117):
https://www.arib.or.jp/image/osirase/news/1044.pdf
https://www.arib.or.jp/image/iinkai/kikaku-kaigi/rireki/101.pdf

Testing procedure is described here, not sure if it's considered useful:
file:///home/bkil/chrome.root/Downloads/60ghz2_1_19_4_2_1.pdf

On Mon, Apr 8, 2019 at 2:48 PM seth.forshee <seth.forshee@canonical.com> wr=
ote:
>
> On Mon, Apr 01, 2019 at 06:07:44PM +0800, junping.xu@jaguarwave.com wrote=
:
> > Hi Forsheee,
> >       The 60GHz band defined for Japan was between 59-66GHz, but is has=
 been Updated to support 57-66Ghz about 2 years ago=E3=80=82
> > However, the latest wireless-regdb still containning the original regul=
atory information  as below. Please help to check the infomation
> > and update the regulatory.bin.
> >
> > db.txt:
> > ......
> > country JP: DFS-JP
> > (2402 - 2482 @ 40), (20)
> > (2474 - 2494 @ 20), (20), NO-OFDM
> > (4910 - 4990 @ 40), (23)
> > (5030 - 5090 @ 40), (23)
> > (5170 - 5250 @ 80), (20), AUTO-BW
> > (5250 - 5330 @ 80), (20), DFS, AUTO-BW
> > (5490 - 5710 @ 160), (23), DFS
> > # 60 GHz band channels 2-4 at 10mW,
> > # ref: http://www.arib.or.jp/english/html/overview/doc/1-STD-T74v1_1.pd=
f
>
> The only change which is required to change:
>
> > (59000 - 66000 @ 2160), (10 mW)
>
> to:
>
>  (57000 - 66000 @ 2160), (10 mW)
>
> Is that right? Can you provide a link to the documentation which
> supports this change? The current link above this rule appears to be
> broken.
>
> Thanks,
> Seth
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
