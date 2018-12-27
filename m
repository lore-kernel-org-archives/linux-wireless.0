Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE097C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 16:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7CA820873
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 16:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbeL0QoV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 11:44:21 -0500
Received: from mail-it1-f193.google.com ([209.85.166.193]:36383 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbeL0QoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 11:44:21 -0500
Received: by mail-it1-f193.google.com with SMTP id c9so24320003itj.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2018 08:44:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=htRIATJ6sRgcxNxD/hvRxX7GBMk5w6KSp3cJ0RojEX8=;
        b=CvbKZ3QfcoJx+sgGGpL9p4MbwVxI2aLR9B/MNueKg73+Ebh5QeBv0H4mDUpv0K+k4i
         TNbLtpr3Hb7hJtQQ+Jxwwu1Hl7xcQejO22I3v3fHFAlWNKOxl7yyVz2Oylj3bZNVKOh0
         FDdkUxmYw9B01DJGwKh2vuoV5EWH8d71baRmv2u3yhEqmgwJb1xBngN+FndLCXaLac0q
         bPChvHKikuSVDkFULxxFh5+U9Ku7soMH/uZbpN9o+QxD73+XQ6tQihFDHOd4HuowL1FT
         pxT0jbFKGiT+01/ALBoB+baWWhXu/5QF3HdAHHf1YJbdzKtGcvRkHJAwwvrVvJWlj6E4
         a4MQ==
X-Gm-Message-State: AJcUukf9VlyNQYP6nlPMriuS1MJTPDKISAtr5WPXfQyHrRm7xJju7RHy
        WQ7glOI4FF1XOJM7ytIN/peuo12jXkxwd4ChXkKyeg==
X-Google-Smtp-Source: ALg8bN65UgCbr+mQzNq26G9Ae7TBjjNhzLmXxxT3dDdx6OlEewyZeV3Bq3MPwNl9lVNKLycd46tXo1OBaUFgcexUQKE=
X-Received: by 2002:a02:ba01:: with SMTP id z1mr11210298jan.100.1545929060697;
 Thu, 27 Dec 2018 08:44:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
 <f28b63441e1a1c1518e28dc70ff7fc854ae60361.1545667662.git.lorenzo.bianconi@redhat.com>
 <20181227105410.GD25885@redhat.com>
In-Reply-To: <20181227105410.GD25885@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 27 Dec 2018 17:44:11 +0100
Message-ID: <CAJ0CqmVaMx1FRD3z+FZ7TdkV+yQ8xT4t=5vEbfM-1Y0ek4NkBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mt76: run mac work every 100ms
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Mon, Dec 24, 2018 at 05:24:41PM +0100, Lorenzo Bianconi wrote:
> > Introduce MT_WATCHDOG_TIME macro in order to run mac work every 100ms.
> > This is a preliminary patch to implement a proper tx hang watchdog
> <snip>
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> > index b54a32397486..ec936002a286 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
> > @@ -33,7 +33,7 @@ mt76x2_start(struct ieee80211_hw *hw)
> >               goto out;
> >
> >       ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
> > -                                  MT_CALIBRATE_INTERVAL);
> > +                                  MT_WATCHDOG_TIME);
>
> There are other procedures that are performed on mac_work , which most
> likely don't have to be done so frequently. I think watchdog should
> be placed it it's own work.

I guess it will be useful to have a dedicated work for it if we add
new watchdogs (like mt7603 driver).
I will fix it in v2.

Regards,
Lorenzo

>
> Regards
> Stanislaw
>
