Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18CFC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:15:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC70D214DA
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Uyt619YH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733183AbfBOGP2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:15:28 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38175 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfBOGP2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 01:15:28 -0500
Received: by mail-yb1-f196.google.com with SMTP id x9so3382874ybj.5
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 22:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kF9rGyNlOKH/k9DI3bApjqx6Fk6ppHpFEZggz2EgJvw=;
        b=Uyt619YHcVnqjwXEHXIGQiQsYwrdVPw+iPt/ikmIx9ujtgPip5KDql5phsYPUk38NL
         PBqK1XncOjX5Y/sz4qRG0Y3xms5i1FOnTZaxZaJNUmKXwLVQOeNLN+2584E3g4+UJnVp
         SNcHx3xFWVYS9S+OnefB5rb0pfzK6gBIn20KY+vZK5oTrOP84oLKmx5LtampGPhjT7vJ
         S+7CF/fzRGcMuh6MLtHgi2LvjDQJpjYqqUPH0qzWWZ0Dz2be/NePFd2+8AtWnLKwdWQb
         D9I9KsP29gnc2S0hRofF04S5cR+PcnGOthEtMGBgzdYEAwif9bvKIOi3Ki9IvRNQemaH
         p3wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kF9rGyNlOKH/k9DI3bApjqx6Fk6ppHpFEZggz2EgJvw=;
        b=owU6OP8utCiufr/3qq/DTB8z09gQKjSpGRE3g2G8qqicQfM5aV8FlfbahcnDin/6Ar
         AnFFSlVbA9Vw1rgZZhQ0eXJVFtHiCz7s5Q/vw+NkTrETFQunDP+pTmk9SYC7V8n0kJ4R
         H/M7yyRe+wFsn7+ReWg9+ECW/1d001Vw9Jjf2mYV6wXyaBwRju/2fxs46ejEoT3TyVru
         545h6YY51Q5ISpPkDXEdfLrOSV4c2TRJ2QvJ2uqQTK3uj8m52Sw9xSWAxOLs6yXcAuzZ
         ofT1EtKBss2HiN+Fn7OUYh1eI91SNc+Sz8fohjELMY7lb62Sg8SpvuxTZQcAMfeZy9x3
         ncfQ==
X-Gm-Message-State: AHQUAubHZb3wuqfGvLaoOP5pgdje7bs+jHpsK14XbZNnkvaVKscVYUUA
        DVnD8tgc2OpFLiTedHSQy5/bCbFcc9yynHo0yVU=
X-Google-Smtp-Source: AHgI3IbgGeCLNtxnFwTHg3yNdSRRK7rZj4jV4SQPKBJvdv67F6JU2lNt8cb1oddVe3gi5588SWgJdL+ih5r9HIh729o=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr6613248ybe.384.1550211327284;
 Thu, 14 Feb 2019 22:15:27 -0800 (PST)
MIME-Version: 1.0
References: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com> <16ea722f-e08d-044f-216c-4ea745cc6344@broadcom.com>
In-Reply-To: <16ea722f-e08d-044f-216c-4ea745cc6344@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 15 Feb 2019 07:15:15 +0100
Message-ID: <CACna6rxR4t1MpniasnUfyiuBhc9tTkJRx=O7GrMnmVPOXCZ-dQ@mail.gmail.com>
Subject: Re: brcmfmac: NULL pointer dereference during brcmf_detach() after
 firmware crash
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>, Aaron Blair <aaron@aaronpb.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 14 Feb 2019 at 23:37, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 2/14/2019 11:30 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > I've just found a well reproducible brcmfmac crash (NULL pointer
> > dereference).
> >
> > Steps:
> > 1. Wait for or trigger a FullMAC firmware crash
> > 2. Wait for some skb to get queued on a flowring
> > 3. Call rmmod brcmfmac
> >
> > Problem:
> > There is a NULL pointer dereference in one of the brcmf_detach() calls.
> >
> > Explanation:
> > brcmf_detach() first frees all "ifp"s and then deletes flowrings. If an=
y
> > flowring has a skb it results in calling brcmf_txfinalize() which tries
> > to access "ifp" (struct brcmf_if) which is a NULL.
>
> Hi Rafa=C5=82,
>
> Thanks for diving in. That was my suspicion. Does it mean you are
> working on a patch or shall I take care of it.

It would be nice to have someone more experienced with detaching &
rings look at it. Is adding a simple
if (ifp)
enough? Or should that code get redesigned? Should we e.g. reorder detach o=
rder?

--=20
Rafa=C5=82
