Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C279C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550C720840
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:16:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KH84xDKa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbfCFJQt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 04:16:49 -0500
Received: from mail-ot1-f42.google.com ([209.85.210.42]:46364 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbfCFJQt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 04:16:49 -0500
Received: by mail-ot1-f42.google.com with SMTP id c18so10099654otl.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 01:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wBUevalWMqOSAY9zQuva0zJ2CajhjkfN9KLoj9KKIOI=;
        b=KH84xDKaAkFEy+NrXPFFHFgB44RpJIDZviKUwrh8RNCxTdesC4rGQhRoyldmGjZYMQ
         M2+2GlUhYYNdkuou4v22koKZl2PgaybFHoHD/Jr/Gu67PtewrMFmRgvL/97m6KrHfOQy
         tWXC5SSSteF05CrmSttxF8BjMcajUrvR0tRzsGLbGsdZ8+fbW2kK7rONK0P2l/ZTGYoB
         jYUoNyuS4Ph4fAnK/zzMJ9CkS7o9BONaxqi/fwQkGAtu0lawqVlhYsAsc08w7h+q+lnY
         Ai9Jnp+QehfLKI8/2Ot2/U2/550pN/WSbmUNMq0PtDxwiPvUhCvmfYfg7/1FgSNL+DOP
         +fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wBUevalWMqOSAY9zQuva0zJ2CajhjkfN9KLoj9KKIOI=;
        b=cvBQROPCNsrQ6WCl4mY8z/ZoRKsu9e0i1PEe+aXWuwu450wiqgQYk5XIRObnht8xSM
         aNvq+oum8mbzl/pgEm+Dylym2xIE1MoCrqaWV5N/RWVi5BL/V7BLd8NtUtdJwFgvqOvD
         bG3DU66lESJ3DzGgsqFbJpAeB9B5VrRU6z4AmBJ7ccpWun311zffrJiYQWTRsCiXImy9
         2Pjl2u4O2Iq+xvLkfyt1ISnoXfEqA6Lpm+Fz/lXFosn380/xJf7ucQrUP++SYhZMyq7E
         XAhShRdVaVXEBFm1JX5VQiZk7z7RSsDazDXoVwBztz7lOlJB7XiatEr/AeSXnvjCf57L
         WL3Q==
X-Gm-Message-State: APjAAAW2aVh0Pk4cYawRUxmIKaF87mThfVDE0Ow/aEHjes1ygSeAeSwY
        XfLlpj28o2PKVUWIqcfXnSvzHpvibsv1ev4DS84=
X-Google-Smtp-Source: APXvYqz7Rj9nRLZK4gL1vOV4C2OQ1GfOdedrZN3ARIkgwWUSXinxOGZCVH4uUbO8lIZn5S28OCD9lMjYv+NOUKy6jjc=
X-Received: by 2002:a9d:67d3:: with SMTP id c19mr3625073otn.300.1551863808151;
 Wed, 06 Mar 2019 01:16:48 -0800 (PST)
MIME-Version: 1.0
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com> <20190306075053.GA12946@redhat.com>
In-Reply-To: <20190306075053.GA12946@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Wed, 6 Mar 2019 10:16:37 +0100
Message-ID: <CAA2SeNJQyFp0kWX5+_VeXtUz05Azt3w=QgOzGkFiPzTD5rb7-Q@mail.gmail.com>
Subject: Re: mediatek: duplicate usb devices
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Tue, Mar 05, 2019 at 07:33:51PM +0100, Xose Vazquez Perez wrote:
> > There a three duplicate devices at:
> >
> > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
> > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Aukey USB-AC1200 */

This has been introduced in commit 62a25dc56990a, I will post a fix

Regards,
Lorenzo

> One duplicated entry should be removed.
>
> > mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> > mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },
> Not sure about this.
>
> > mt76/mt76x0/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax / Elecom  */
> > mt76/mt76x2/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax EW 7722 UAC */
> According to wikidevi we really have duplicated IDs:
>
> https://wikidevi.com/wiki/Edimax_EW-7722UAC
> https://wikidevi.com/wiki/Elecom_WDC-433SU2M
>
> I think we can handle this by checking ASIC version from the EEPROM
> or registers at the beginning of probe and exit if it does not mach.
> This should assure we will load proper driver.
>
> Stanislaw

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
