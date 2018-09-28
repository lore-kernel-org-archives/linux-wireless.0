Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A24CC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56502172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 10:28:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C56502172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbeI1Qvm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:51:42 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:55591 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729321AbeI1Qvm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:51:42 -0400
Received: by mail-it1-f195.google.com with SMTP id c23-v6so1924819itd.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 03:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KL4IPPYViosqxpTZoHIZp6OH4DRzoZba1tmgaly7eWM=;
        b=Qe5x0UWxZ6n0uZ4nt4uvqeBvmGA3uPeLrnDRqaKjUP9chACY3JMDk3sqrgYePqLguK
         U4eahjbm+eWZfZlB9FcCJJ9N/dig1rN8jZ1Cg1tuwJG3Aqb/BwOTBvjbdCyHfS7AXhvc
         tK9P5WUzAfQ4/0YWJgyc8HFJKiGvXMiiyfmQqbSZv+vICMxKmkwTpjEPPsn3pSrbgdyu
         teMUla+AkiBR/X22nlJkfdMQE76cdADz73VIfisa/OtQ4TRK0j6HNMG5MWPuxSk+u/jQ
         c5OuTZ/yP/MMAgRjFSUICYAVRZu59Cy9+gDFAfwq3jvkH98UqDNOR1jQ02L8tSVFlADb
         0lug==
X-Gm-Message-State: ABuFfogqpH8UyBDnJ+4X2NTNqaJbQ5AJ4RvJrlB1um6NGZseWPYKnx39
        JsP0Q1m5mNvoP08c6CIY+3j+tVUzgMFy/b/5b7iAJA==
X-Google-Smtp-Source: ACcGV63Fys/L8b7VE1beFLFDBKGMJlxJN5AcjJVp47kRpbL3wrj2OIrDRbX+NZbHEqZ/Df5CQuL0Mk3ZVPO1+iEga4Y=
X-Received: by 2002:a02:982:: with SMTP id 2-v6mr12971388jam.78.1538130515881;
 Fri, 28 Sep 2018 03:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20180928064017.26870-9-lorenzo.bianconi@redhat.com> <20180928085940.GA8323@redhat.com>
In-Reply-To: <20180928085940.GA8323@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 28 Sep 2018 12:28:24 +0200
Message-ID: <CAJ0CqmXHpA7=TiUKZo1z_K5x3CSHJV9X7hnNnWAgz5fxk+ZqEQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/24] mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Fri, Sep 28, 2018 at 08:40:01AM +0200, Lorenzo Bianconi wrote:
> > +static inline bool
> > +mt76x02_wait_for_txrx_active(struct mt76_dev *dev)
> > +{
> > +     return __mt76_poll_msec(dev, MT_MAC_STATUS,
> > +                             MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
> > +                             0, 100);
> > +}
>
> The name is unfortunate, what we wait for is TX and RX become idle
> i.e. hardware do not perform any RX or TX (see for example
> mt76x2_mac_stop() ).

Hi Stanislaw,

This is what I meant, but probably 'mt76x02_wait_for_txrx_idle' will
be better I guess, agree?

>
> I think this patch should be droped and we should just use
> mt76_poll_msec(MT_MAC_STATUS) directly, there is no real benefit
> for this function.
>

I would prefer to use shared utilities if it possible.
I will fix it in v3

Regards,
Lorenzo

> Thanks
> Stanislaw
>
