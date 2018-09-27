Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EAFAC004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD9FF21570
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD9FF21570
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbeI0PwO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:52:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46995 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728477AbeI0PwN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:52:13 -0400
Received: by mail-io1-f67.google.com with SMTP id y12-v6so1420651ioj.13
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n4dauTgJrgGSj3J8zIDTVt1I7hQyGmlMM3jN7CJr0qw=;
        b=CVefRi6t7dscNrtZQOCQMtO9WB1EPvjdAKs8NRcpmLyD9pDweSh/z7gvJuTwJfJyr9
         qUjnd5tSMBS57hZbq60DHmyIwka9EVFW50+bvTmhgAOM3Ar5GP3o6M2pI2TKRjgO/2TQ
         oIvP5RD6PCnnigNIRp79JmnkNaYUr/GQw8AMoKyx2/CXu+0hC1oo4LU9HuWitR4OwIYd
         cbjfv+D0SHml1qL9XSeggx6AUUVZm1JAIDJgBpcMFmo3YmJs+pncutOxI1uklVqollCT
         87uzh0bfmK05KAsNMC5b4JDX4FVQSkYSw6RpZrzFuzTo4fVNfcd7DB8xZ7BQSCxuigBi
         /Fow==
X-Gm-Message-State: ABuFfohEJOx1XN9b4/PZfZHq/7Z7nRICRwYM/3jEJTodQQnImBhvVxch
        8VE1c7gciAysAofRA2ILMnv/3MzaQVuCAFX737mwNQ==
X-Google-Smtp-Source: ACcGV61b5/3n3p8IfLaw86R7NlEDi5VKoihWpSd3A3WSra+S8OsF5CpOfIBrQbvM0TsUiRPYKM3xmcUy5vDOfuGu1Hw=
X-Received: by 2002:a6b:c917:: with SMTP id z23-v6mr8083074iof.297.1538040890200;
 Thu, 27 Sep 2018 02:34:50 -0700 (PDT)
MIME-Version: 1.0
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
 <1538037450-18949-2-git-send-email-sgruszka@redhat.com> <20180927092629.GA2489@localhost.localdomain>
In-Reply-To: <20180927092629.GA2489@localhost.localdomain>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 27 Sep 2018 11:34:39 +0200
Message-ID: <CAJ0CqmUNDLG_FCwVzEhUWr11OhqH-wxHqL97c2gY8PkTyDNXBA@mail.gmail.com>
Subject: Re: [RFC 1/4] mt76x0: print BBP version only for debug
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> > Use dev_dbg to print BBP version.
> >
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > index 4fd2c65e196a..ca0a693654a3 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > @@ -187,7 +187,6 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
> >
> >       do {
> >               val = mt76_rr(dev, MT_BBP(CORE, 0));
> > -             printk("BBP version %08x\n", val);
> >               if (val && ~val)
> >                       break;
> >       } while (--i);
> > @@ -197,6 +196,7 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
> >               return -EIO;
> >       }
> >
> > +     dev_dbg(dev->mt76.dev, "BBP version %08x\n", val);
> >       return 0;
> >  }
>
> I guess we can drop mt76x0_wait_bbp_ready and use mt76x02_wait_for_mac instead
>
> Regards,
> Lorenzo

Please drop the comment, it is a different register. Maybe we can
generalize mt76x02_wait_for_mac instead?

Regards,
Lorenzo

>
> >
> > --
> > 1.9.3
> >
