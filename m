Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D571DC5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD9F2098A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rU3vMMPR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DD9F2098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbeJRXxb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 19:53:31 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:43249 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbeJRXxb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 19:53:31 -0400
Received: by mail-ot1-f54.google.com with SMTP id k9so30232976otl.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Oct 2018 08:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=BC1+4eFWbDQr53sr9p3TvosGRin0t7mwDTdRj/fRbPc=;
        b=rU3vMMPRlhTKRHzwYz9gF2dEBPEZBdhp4pEJaY4w284johf80/CrDHrNzbjfaNtOXZ
         GmuSATwmqDq+s4RW5BYAlLtTriE+Zu4PurDmbYBI96t3stOWivj2bZmnKn89zDg0JO9o
         1fHLee4Dhmtf2+bytt6/at1ulaDYbNFaOp7l/UHyTV+voY8hjWtIMJJwZNr3mzQsSBV6
         wu0q1Ful5IekNfZF0QemmNFgmjDAlvrvM6xAQTCHxWeNWyS66mos+KVS6/gBKB2jqM6l
         tacoks16gb99bUjFAeQDHEuoAmheJ6QC1Se/B0Q1ByNj7CMfQMqqrgDlV4PpFpjxNtOA
         XfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=BC1+4eFWbDQr53sr9p3TvosGRin0t7mwDTdRj/fRbPc=;
        b=Mmw9+DgnYGdzY0BxY0UuuhWCH1Henrcxmbj3967LVpz2KYsJWTci41h0cjfwZs6uAk
         Ni0W5J0ZXpLzzRnmR4VKhgxYAOcpuwInyl4OjR5nDW1vFmrfbD9vwGxajhbluNh2RQh5
         0DvTw7mJw3cQby3cPwb5iNGXpaE2ltBXnVzhbn6KBCYOq340HSgfqJ3jCZ9aqq1gD3AC
         MIIVNr6rjol61zVRiFDpwan4LByoWIwH+kjbNCKoZZqeV2+gy1zDO7C4jjjZ/c0BKVy7
         GigQDCkH6YxcHH3h+JMpRlF4EEjhS3taadwVpWhFIOkkeSZut3XrkugFmmtg9xderdd+
         0Xmg==
X-Gm-Message-State: ABuFfoj3qNwbBIqPlDpFxqmCbINFr+JyF+DDJtIFLxNLuU/+qXls4wlr
        gmF8H9hDCXibXKypJbclfvPZlcOJjo8nwy7+JvA=
X-Google-Smtp-Source: ACcGV63go9H+mYJdCCN9WNedY7UDtZURSH6eNFJoLLWzBcT1nUzhgdAXAA/4zTc/3fF4CtmNVYvYsI3byalkvoSoV98=
X-Received: by 2002:a9d:2314:: with SMTP id j20mr18579544otb.296.1539877914502;
 Thu, 18 Oct 2018 08:51:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Thu, 18 Oct 2018 08:51:54
 -0700 (PDT)
In-Reply-To: <20181016154957.GA8730@redhat.com>
References: <1539334591-9965-5-git-send-email-sgruszka@redhat.com>
 <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com> <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com> <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com> <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
 <20181016154957.GA8730@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Thu, 18 Oct 2018 17:51:54 +0200
Message-ID: <CAKR_QVKRX0zLTwb4iyH4JceZz1YKVM0RFcpNfCGSKddZ2z9+FA@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 16/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hello
>
> On Tue, Oct 16, 2018 at 01:32:18PM +0200, Tom Psyborg wrote:
>> I am sending you two builds privately so please check if there are any
>> differences between the two builds and report back. Thanks.
>
> I extracted rt2800lib.ko module from provided images, did disassembly via:
>
> ./staging_dir/toolchain-mipsel_24kc_gcc-7.3.0_musl/bin/mipsel-openwrt-linux-objdump
> \
>  -d -r --prefix-addresses ~/rt2800lib-BUILDn.ko  > ~/BUILDn.dump.txt
>
> command and compered disassembled code. Here is difference:
>
> $ diff -up  BUILD1.dump.txt BUILD2.dump.txt
> --- BUILD1.dump.txt	2018-10-16 16:40:34.834220838 +0200
> +++ BUILD2.dump.txt	2018-10-16 16:40:40.187219211 +0200
> @@ -1,5 +1,5 @@
>
> -/home/stasiu/rt2800lib-BUILD1.ko:     file format elf32-tradlittlemips
> +/home/stasiu/rt2800lib-BUILD2.ko:     file format elf32-tradlittlemips
>
>
>  Disassembly of section .text:
> @@ -9374,7 +9374,7 @@ Disassembly of section .text:
>  00007f80 <rt2800_clear_beacon+0x224> jalr	v0
>  00007f84 <rt2800_clear_beacon+0x228> move	a0,s0
>  00007f88 <rt2800_clear_beacon+0x22c> lhu	v1,732(s0)
> -00007f8c <rt2800_clear_beacon+0x230> li	v0,21392
> +00007f8c <rt2800_clear_beacon+0x230> li	v0,25426
>  00007f90 <rt2800_clear_beacon+0x234> bne	v1,v0,0000810c
> <rt2800_clear_beacon+0x3b0>
>  00007f94 <rt2800_clear_beacon+0x238> li	a2,1025
>  00007f98 <rt2800_clear_beacon+0x23c> lw	v0,4(s0)
>
> There is no difference in init_registers (which is inlined in
> rt2800_enable_radio). The only difference is in some number
> rt2800_clear_beacon() function.
>
> Regards
> Stanislaw
>

hi

i rechecked this and your debug procedure seems to be unreliable.
