Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0590EC65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C592420858
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 19:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C592420858
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbeJIDIu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 23:08:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35882 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbeJIDIu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 23:08:50 -0400
Received: by mail-io1-f68.google.com with SMTP id p4-v6so16819520iom.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 12:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NoAlCjWPcWrCbziOVUiOLgNfv6qgm+3Tp8I+ZVl0OXM=;
        b=dOUYfwSuKfkdVhqD8SxbhkHVtqpyy8eK9mohnV45iqTtzkddILSMHe38hJrC6oTicQ
         +Haab1r7CKPTLgMnHGwNp5v7h+rnHSYmwek7LlI55DO104r1TUdavsCKOReKbqY7Nhrg
         FapXib712LxYjEQdl+ubyedQ9uSMVOQhGfwOa4dVy3CMq95nXBHsT1R0BiFz3OO25KX1
         RUnAL3+U4DT/RwGKak+hUER3LzeVDWApL8zaT5PYbSX5l6vh7xXo1x2FgB6LnOoupW/9
         +eaPOWEpSBiomQuFkJnYZ+pmj+L70pjuNKZR77Itgt8vCEgHwEb58m+f7B+NMniw8qg4
         h2NA==
X-Gm-Message-State: ABuFfoj84Mglg4KyYXWaJBuyFt6a0DKK22qLCpvgXhvTOgeVJDVTxr7z
        f5BO7qiJqvOJzeRhlz8GaMgxsGyoRxFrP8hniIei221EIQU=
X-Google-Smtp-Source: ACcGV63WiImvF0lDD1qlzHP8/elIXNxz+0UizfoOqZcTaaBQa9/lRYmO3MqBWaelmSaTGFSBAMldjbBxqE9YEbPCyVY=
X-Received: by 2002:a6b:c917:: with SMTP id z23-v6mr16853887iof.297.1539028525637;
 Mon, 08 Oct 2018 12:55:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539001391.git.lorenzo.bianconi@redhat.com>
 <ff6672828b7e970124a425304ad734d58133a6ff.1539001391.git.lorenzo.bianconi@redhat.com>
 <636edb3c-a2dc-306d-8ddd-8b91ebafd4f1@nbd.name>
In-Reply-To: <636edb3c-a2dc-306d-8ddd-8b91ebafd4f1@nbd.name>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon, 8 Oct 2018 21:55:14 +0200
Message-ID: <CAJ0CqmXdAwW3gbuaAr==Bjm5PPOE9t-GEg2p7=UGD9gbJHTz=g@mail.gmail.com>
Subject: Re: [PATCH] mt76x0: phy: fix restore phase in mt76x0_phy_recalibrate_after_assoc
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > index 99e0a91a2f99..d18942e54048 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > @@ -734,8 +734,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
> >       usleep_range(500, 700);
> >
> >       reg_val = mt76_rr(dev, 0x2124);
> > -     reg_val &= 0xffffff7e;
> > -     mt76_wr(dev, 0x2124, reg_val);
> > +     mt76_wr(dev, 0x2124, 0xffffff7e);
> I'm pretty sure you can drop the mt76_rr as well. Also, you can refer to
> 0x2124 as MT_BBP(IBI, 9).
>

Do you mean we do not need to reset the original value in MT_BBP(IBI, 9)?

Regards,
Lorenzo

> - Felix
