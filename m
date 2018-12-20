Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90330C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F96121852
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 14:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vhRktfrc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733181AbeLTOaY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 09:30:24 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:54474 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731393AbeLTOaY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 09:30:24 -0500
Received: by mail-it1-f194.google.com with SMTP id i145so2249037ita.4;
        Thu, 20 Dec 2018 06:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RHn4mwjXMVzxIMjABi2latZFaRq3p2Hh6gxQf2Pv30=;
        b=vhRktfrch2BycQ49Qrf19cWCobfIcJhBym5UNTFnEO4JKCm64vokVs7YuY0gakEPrQ
         nP+60T1mij6IStYD33pzZqZBUhweSfBFQD/O3RN7FyIE64Ijz2M06Ihbx5nIqvCKeX50
         G+lKHxN5wwomU6/oAI57sZkT4z2lngSA/xNRbnlkQ30F4dPPskfkD5msozZ65C/TZhW8
         CmycZsfEBCpFnubddRF3en3rq8oUeYEVNoat89xd6SeH7uxUHJBGsY9XyhyGnk3eqi+H
         L7IZzm65HHzPjyNDMRIf37yNV/xk4eg5MGjHW9goen9giS32RbVS03MdXMN49NGfp3A7
         aCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RHn4mwjXMVzxIMjABi2latZFaRq3p2Hh6gxQf2Pv30=;
        b=MEo6Gy2aAdf9E4TcHhOOlxatSZ8vzL0o6H0kBMIs7dRKaq49kj7+AmNlMVtPvaNjQa
         98kJ+3h8KPCinMFY4VsQBHQrCFwRK1fYlwbW4tDOoqzcFC7YMWL/r+jnCCyu3FyQ7m40
         urwUDR5dUGM+ys/OxbYb9fXm4VpBZQYHauzqsWQ8gHtM72UXS7ANFvQud7XdQQkSwT2e
         Wv24jp8T9oa/3Hmu8XYZz2VaZOPoo/JFU8Dz3NEG/x7QYSUUtFe1scZmUL5iltf34wzL
         bsM9MSAECfXCb/Kkmasyk3Z9dMpnHPZCRLmG15e/FMkyrjf3GJ8916+YkByAJcNu6Wv0
         qW1w==
X-Gm-Message-State: AA+aEWZVYcoc6zyvsMYRbkceLQ/VpkO0UIjIrXpyQTQbbsQRwXZImcDR
        ccL/PArWjNxtJIYg7/ujjYqQ1w00JnIjEsfD2YE=
X-Google-Smtp-Source: AFSGD/XP/S9SpqGysf7yNHd2RzhoDrRxOHH24CyzJjP/QZn6QfcfTM7X2ezniNzSLMo2YPqeprlM2esJD9dtCgm9rqM=
X-Received: by 2002:a24:dd8f:: with SMTP id t137mr8124020itf.10.1545316222492;
 Thu, 20 Dec 2018 06:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20181220114701.GA8660@redhat.com> <20181220123055.GC17138@kroah.com>
In-Reply-To: <20181220123055.GC17138@kroah.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Thu, 20 Dec 2018 09:30:14 -0500
Message-ID: <CAM0KTbD7Ky0BZNfvnoN3x=1zh39S85Bemox-1aMrfOBiqmzqpQ@mail.gmail.com>
Subject: Re: [PATCH 4.19] mt76x0: mark 802.11w as supported
To:     gregkh@linuxfoundation.org
Cc:     sgruszka@redhat.com, stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 20, 2018 at 7:30 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Dec 20, 2018 at 12:47:07PM +0100, Stanislaw Gruszka wrote:
> > commit 0ae976a11b4fb5704b597e103b5189237641c1a1 upstream.
> >
> > This is one line hw feature backport from 0ae976a11b4f ("mt76x0: init
> > hw capabilities"), which add also other different features, however
> > those are not supported in 4.19.
> >
> > 802.11w is supported by mac80211 and mt76x0u driver in 4.19 correctly
> > fall-back to software encryption when 802.11w ciphers are used.
> >
> > Without the patch we fail to associate with WPA3 APs, so this is
> > considered as fix.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > [remove marking non-working features on 4.19, make topic correspond the change]
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> What bug is this fixing?  This never worked before, so this feels like
> it is adding a new feature.

It is easy to see how this walks the line between "new feature" and
"bug".  From a user's perspective, it presents obviously as a bug:

wlan0: WPA: Failed to configure IGTK to the driver
wlan0: RSN: Failed to configure IGTK

When I cannot connect to an AP and wpa_supplicant is throwing
failures, it sure feels like a bug.  The line for acceptance shouldn't
be "never worked before" or only regressions would be fixed in stable.
Instead the line should be closer to "this doesn't work and was
expected to work".  In 4.19.5 a patch was merged to fix monitor mode
on this driver, which is a far less critical bug than not supporting
802.11w and WPA3.  For me I would define "bug" as unexpected failure,
and no where in the wpa_supplicant output does it say this is
unsupported, instead it just plain fails, and failure is a bug.

Again, I agree that it can be seen both ways, but I'm arguing that it's a bug.

Thanks,
Zero

>
> thanks,
>
> greg k-h
