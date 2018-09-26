Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A465C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D387721528
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:43:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D387721528
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbeIZV5G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 17:57:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35773 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbeIZV5G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 17:57:06 -0400
Received: by mail-qk1-f193.google.com with SMTP id a189-v6so6473695qkb.2;
        Wed, 26 Sep 2018 08:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DIJegVQAkMc+mSDctyoYhw0MPqLevo+DBFlteQPR34I=;
        b=BjSo6nks1sgaPslMWPK9WJYFNSLtsAiiSROlGlu10fHkhqPgDP03NgTGe+bIxuCwi6
         6iB0EO1RmunHqDxbnh55pIZPHpsuByz3b7NunPIqm75ICH68Pq+xh9+Od+efgTunf6pn
         2/aZ5UbFsBhfbp5JaoMgpOpKDSVrCSnvOLpXcc2m8dlao0J3Kj+zlgrzJx2wSw3x+ceC
         8pqb/01yXq29ysYR0+i3TRxpWifjUrGC5s7fsZ+KHbnwivft865bfNaRVvqtdxy/Ho30
         iFtMYgfxhD9EQO8DUni9ra2O2NFEc2V8R+JpAWY8tHRmr1ocmKLmGH54ajl6kQJKS6py
         yFHA==
X-Gm-Message-State: ABuFfojOW22V6fa2jt+2xY4s7zVXrTQ7Q7adfNWOAErRRujrf/y9CKjj
        p97IdsJv6wMhPfBE7Gv38aZ+Kp4u3CwSMGu2saY=
X-Google-Smtp-Source: ACcGV62n1tfMHoIkvjxYcWDBfQriivHQ/lbnPtK8/Dk7PYX9OrhQCrOdYSQXqLHiqJ+VXs9HnKdps8dBpLanT7J/GZg=
X-Received: by 2002:a37:7347:: with SMTP id o68-v6mr4750153qkc.291.1537976614126;
 Wed, 26 Sep 2018 08:43:34 -0700 (PDT)
MIME-Version: 1.0
References: <20180926125356.2026635-1-arnd@arndb.de> <20180926140627.GA9265@redhat.com>
In-Reply-To: <20180926140627.GA9265@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 26 Sep 2018 17:43:18 +0200
Message-ID: <CAK8P3a0jC8AOdimx-hx90nYXLsN0wRWGQ0bNUuiu9-vuRrLMGw@mail.gmail.com>
Subject: Re: [PATCH] mt76: fix building without CONFIG_MT76x0U
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Sep 26, 2018 at 4:06 PM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Wed, Sep 26, 2018 at 02:51:59PM +0200, Arnd Bergmann wrote:
> > The recent rework of the mt76 driver caused build failures in
> > configurations that leave the mt76x0u support disabled:
> >
> > ERROR: "mt76u_mcu_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> > ERROR: "mt76x02u_set_txinfo" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> > ERROR: "mt76u_queues_deinit" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> > ERROR: "mt76u_stop_stat_wk" [drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0-common.ko] undefined!
> >
> > The mt76x0_push_txwi()/mt76x0_tx_prepare_skb()/mt76x0_cleanup() functions
> > that cause some of these are only called from the usb portion, and can
> > be hidden in an #ifdef in this case.
> >
> > mt76u_stop_stat_wk() is called mt76x0_mac_stop(), which is in turn
> > shared between multiple callers. Calling it only when the USB driver
> > is enabled avoids the link error but it is not clear to me whether this
> > can be called from a context where it would not do the right thing.
>
> I think there not yet posted Lorenzo patches that fix this build
> problem.

Ok, good. I assume that is a better fix than mine then. I also noticed
another problem that my patch does not address, but won't send a follow
up patch for that.

Please just ignore this version.

        Arnd
