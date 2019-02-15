Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B54C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 09:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0520320675
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 09:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iq5B+3HG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391501AbfBOJsJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 04:48:09 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:36452 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389612AbfBOJsI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 04:48:08 -0500
Received: by mail-yw1-f66.google.com with SMTP id 189so3482528ywi.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 01:48:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rmq7e03D4bqZLHGnduXIdqLfTzpXEhzaULYSwIPJpOg=;
        b=Iq5B+3HGryBkbPxdgKFoQdkY+g0aHjY4wlyzf3HhHVZFu9PAvZzvnrB30z2JOSYJDJ
         pxmr/rRs+Rsg06VGU2h27UW93kZ2T4INcMLCmyL7JvIrz6zU0QpTLdt7BXNCUj9l9phU
         XZxrapOyJVSvrf/Y84S8zpf6r04+2e7EbvfAJVlbDGFVJQvhiVHB70TDkt/3sTkRZmhL
         FAkNe15XjZvZip+OSuLTLwuJx7R26HGHhnSKQfaQsudAIfSonroy9ZTOC/u+vYm7IfMk
         NqcDyfsgDnx4BZexTI1hPdrGOTQD+kyR2L94KNJDzC2WeEclM68JEzMTIxGk+LZDsTX6
         5CFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rmq7e03D4bqZLHGnduXIdqLfTzpXEhzaULYSwIPJpOg=;
        b=rabQfczKk8Dewum3vDh0Rm7W82xmFHUBH79HM0/ufm+Iw9Je62m8LkmGyXfRsBNgYP
         3S4WH7BcaNnzA2yi3d9hw1sWBYkO9lHiQ0CfxJaoUKP07A3Sf5zB4TxKlWecqY5QwDvO
         yKdBJQvtuKF0q3yNCEn+UaI84xE/TDIMfh9+oc4vh2rAuvD4i/qQvT+GEKJS5+wlkQXF
         KpFXcsfybdGejJaoNSsPx4HiYIUahys7gqOmnqt6CxEIDr0DC5m2W1BuM3WMu69kmkNp
         L0SEhVkuz9In1NhnFyFXSegAOO3g1mMrGdVGFEP7kJ7tnDCn2Dq0n4yNiZXdHFMZUsOC
         6djg==
X-Gm-Message-State: AHQUAuZ3fu73y823h2PSR69JsuYsTSNEZMVLRzQV891jjOeqBha5JnAo
        CX/hYkxonlDNVZw6WpPwzYyNONe5O7/Mr23Uo60=
X-Google-Smtp-Source: AHgI3IYFd70j/Y0yLpFm6YjjjYTS7rz/MWa9JGf42EN0rCM5XPHQ+EbWjKUur+eP1QBll8NSZrkRfMkMsGU+DYICJgU=
X-Received: by 2002:a81:25d7:: with SMTP id l206mr7185113ywl.253.1550224087250;
 Fri, 15 Feb 2019 01:48:07 -0800 (PST)
MIME-Version: 1.0
References: <20190214125758.11943-1-zajec5@gmail.com> <20190215064345.11946-1-zajec5@gmail.com>
 <CACna6rwiz=Q=ZYj-q69Ak+VAaJhJmtPhnVB_KQvZc0+NZJoCKQ@mail.gmail.com> <5cb6383e-2e4c-8586-61a2-3f47de2743dd@broadcom.com>
In-Reply-To: <5cb6383e-2e4c-8586-61a2-3f47de2743dd@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 15 Feb 2019 10:47:56 +0100
Message-ID: <CACna6rxT2hQSYNsGKP20t41mCOzE4ZHtqfh42-XGysXisPb_-g@mail.gmail.com>
Subject: Re: [PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 15 Feb 2019 at 10:40, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/15/2019 9:37 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > On Fri, 15 Feb 2019 at 07:43, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com=
> wrote:
> >> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >>
> >> This recently added macro provides more meaningful error messages than=
ks
> >> to identifying a specific wiphy. It's especially important on systems
> >> with few cards supported by the same (brcmfmac) driver.
> >>
> >> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> >
> > Arend, let me ask one more question before getting this patch pushed.
> > It's quite late (I spent quite some time on this), but maybe still
> > better than fixing it later.
> >
> > It seems the most common struct that is:
> > 1) Often passed as argument
> > 2) Often having it's own variable in functions
> > 3) Used when calling functions from different file
> > is struct brcmf_pub.
>
> That is true for the function above the bus layer. In sdio/usb/pcie we
> can probably get it, but it is less straight forward. Maybe there we
> just want to use dev_err() as the struct device is short at hand there.

Correct. For the bus level I mean to continue using dev_err() just
like started with the commits:
5cc898fbcb35 ("brcmfmac: modify __brcmf_err() to take bus as a parameter")
8602e62441ab ("brcmfmac: pass bus to the __brcmf_err() in pcie.c")


> > Now I started wondering if we really want to have bphy_err() accept
> > wiphy. Maybe it would match brcmfmac's design better to have
> > bphy_err(struct brcmf_pub, fmt, ...)?
>
> Just might, but you still want to expand that to wiphy_err() right?

Correct!

--=20
Rafa=C5=82
