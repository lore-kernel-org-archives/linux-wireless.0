Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397ADC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8637213A2
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 20:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbUOLyto"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8637213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbeJDDTr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 23:19:47 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:35002 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbeJDDTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 23:19:46 -0400
Received: by mail-qt1-f174.google.com with SMTP id v19-v6so7502704qtg.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 13:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uGMX4mI6M3baQOKjpu7jmhBKkfp4YnnxYaauwIsgZ3w=;
        b=CbUOLytoWrhXfamw0nILJiBbXbH3rUvj7dXZt4y3i4S7RgzgJFaJt6lU7xSaY6T9dU
         2uOqT/x2dyAtKxuny1qJO6TIN6EIO+vTknmrgGLr6YX8DAHhcz/upuoIyWsURHYWQ3tU
         SR3l2d28yZO4rZf1q67KDakMliF2uB2ZUryOSdzYPgNUbLEOAiNIfoUJZbXfz6Txhb2a
         fSnf3LvjZeQSdUIu0wPsEBOa14+UJ9g2WWF8efwgdfAcR6s++aKmbcfStJUAGBpuCd2z
         NGGG7rn1+BrzzIYguj6xSZf6SEto8aY0paeunJ8EzJl5WKBiRb3ImGLr0FSgwZv1bmRP
         cdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uGMX4mI6M3baQOKjpu7jmhBKkfp4YnnxYaauwIsgZ3w=;
        b=d6BhLf75md3hjpGCnvZVEmOIWnmf5xd+J2OItyg9rSfCBFH0vMz72c0xY+Nx1tc8qj
         DQOCDVJJJu1ZnvwULrV/umOOoZE5u/QuP6BFM9R2Rh8p7O/jUJzv4YvgQshCh3a6XWuC
         tYKEaF20504qDGLV5bXhHp2IOawliUkWnK2hdlqnZvU/AsGQ1pU7M6+0lUiqGAc7nyhT
         dHgNDy9O1zbinCyZ2QzsNrVR7YJynUHmJVIQvnacDo0LzeL6e4AxXk5+LlCmvT5rFfDD
         JHc13iVAB0sIDAh7WrOciihtSHpQz7nksNgjFHOV1DzKV/mC09CjoeGfdk+mlK02B3IB
         tFsA==
X-Gm-Message-State: ABuFfoi/WOHNw7hxI1SnM2bjFphqivQapM7UkzgTiUCb5skuyrI2GkLA
        fZ/kz7Cor2hfIQyl6pJR1A160sr1ivy5qvuciq3+OZyZ
X-Google-Smtp-Source: ACcGV61JoT37cHSRZjujjyQQBUdh3qbW47IedEEeSVUnsjHxXbb21QulbYlwm71SAzJ/GajgVa7aagHaoXTQebxaJg0=
X-Received: by 2002:a0c:962e:: with SMTP id 43-v6mr2763759qvx.129.1538598589448;
 Wed, 03 Oct 2018 13:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com> <87pnwqaiso.fsf@toke.dk>
In-Reply-To: <87pnwqaiso.fsf@toke.dk>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 3 Oct 2018 13:29:37 -0700
Message-ID: <CAA93jw768_OOUB1w81_9Ck_XgSbDG4P2nBfuptT+SLXCf3voTA@mail.gmail.com>
Subject: Re: Tool to debug wifi pkt sniffs?
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 3, 2018 at 1:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> Ben Greear <greearb@candelatech.com> writes:
>
> > Hello,
> >
> > I often find myself wanting to figure out what equipment is to blame (a=
nd why)
> > in a wifi environment.
> >
> > I am thinking writing a tool that would parse a pcap file and look at f=
rames
> > in enough detail to flag block-ack bugs, rate-ctrl bugs, guess at the s=
niffer's
> > capture ability, etc.
> >
> > Does anyone have anything already written that they would like to share=
, or know
> > of projects that might already do some of this?
>
> Not sure if this fits your criteria, but Sven's tool to create airtime
> charts from packet sniffing data immediately came to mind:
>
> https://github.com/cloudtrax/airtime-pie-chart

I have used that. Oy, it's a PITA. Some of kathie's code over here
(example: https://github.com/pollere/pping ) uses the slightly less
painful http://libtins.github.io/ library for parsing packets.


>
> -Toke



--=20

Dave T=C3=A4ht
CEO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-669-226-2619
