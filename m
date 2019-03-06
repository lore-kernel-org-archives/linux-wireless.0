Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0EFC43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 10:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD24020657
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 10:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oGvpBquB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbfCFKJs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 05:09:48 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:36330 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfCFKJr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 05:09:47 -0500
Received: by mail-ot1-f53.google.com with SMTP id v62so10249601otb.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2019 02:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JE1lsUhotCK5Zr9Bk7dM7M5Va830PIWex3LK+aHWtag=;
        b=oGvpBquB1ll4F5YtytuwGucy8rrybYD/qC+WqKJl7X8FwTZtyIk0NLuYOWvPTAXNEN
         idobb7i5d/q/FIHLJs6Ghsa7XkLtF9ouE0FS11SVHNssxrHLkTiCSJ3NFkuRcb1HKL/C
         32w6xtNiUT7sW8aACIUwZjPfjqQXwbokkuGYqXtxUXVAfjl2plFhidVNBFKOkHRSoA3r
         Dp7OOZzAFPKNpXh5kBqO1JRLixMP6jttM7RBbJCg7agzRihOJ1uoRVt0JXezeEZW9v0z
         McPI90gbq0YXL72FqO33Y85E5gr6z+zDBlkN2JA0nbc/0Dwwba2+YlNwS+gMTeB8iwem
         Wvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JE1lsUhotCK5Zr9Bk7dM7M5Va830PIWex3LK+aHWtag=;
        b=UnZkPU2GF9LyShA1IjSbCcoRZmVD3794V+AhhX6J53sHn34Ovp6INTZ2V42RGHN8rJ
         PZM2E9Tc/OspMtiZ8QMXQ6Zq/cp5WpV2GsCBh6bbalqbaht4kdG+9/p0ENiMOqeD6bh3
         IWigryJx8T9++l6/C+xKhtwxmacV2CJYqo41hhY31Mo3YHuGGgPp5EuKv9PAisu53rSF
         eSmHq5pdT1RULcZ8pxthDDVvPq+SsBSYfZ3JacchwMHJ/Sc5I6+wUunQDdGTUYpGDoBb
         sFIwDun/kMNl6i8f3nVXvZF+aMOSdCIpi24qj/NNcSywa7CGtUgoQ5hQMzkPTTloovvp
         wIMQ==
X-Gm-Message-State: APjAAAXufdUI460lm0mod+s6NIJh/98wnG4luf3EoXocsY5aYKcM3XiI
        BJ2lHL+Qk9IUrB1uD2aBDOKC0a8W6zfE0k3vGLQ=
X-Google-Smtp-Source: APXvYqwwbKMryf+sY9EsZqgwGB4XQ2TxNp7PxuFbSWrT+BisJL4+xmOIzzRL0lWMgywXftVAw8VBXn4YbgA17uIZPbE=
X-Received: by 2002:a9d:1b2f:: with SMTP id l44mr3926959otl.217.1551866986866;
 Wed, 06 Mar 2019 02:09:46 -0800 (PST)
MIME-Version: 1.0
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com> <20190306075053.GA12946@redhat.com>
In-Reply-To: <20190306075053.GA12946@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Wed, 6 Mar 2019 11:09:12 +0100
Message-ID: <CAA2SeN+V_ug2JPNQ++ZTj4hYh-YDOkNhiyP_dsaYnpddXDb6PA@mail.gmail.com>
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
> One duplicated entry should be removed.
>
> > mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> > mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },

IIUC this is not in the mt7601u driver available on mtk website.
@Jakub: should we remove it from mt7601u driver?

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
