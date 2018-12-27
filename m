Return-Path: <SRS0=u8cq=PE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37BEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 16:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0ADA20873
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Dec 2018 16:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbeL0Ql1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Dec 2018 11:41:27 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36073 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729378AbeL0Ql1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Dec 2018 11:41:27 -0500
Received: by mail-io1-f65.google.com with SMTP id m19so14950436ioh.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Dec 2018 08:41:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOzxW1/FDejUJuIML75mAQ0lovB7YVVTS775khyFiwQ=;
        b=QCmeWvWzdhJzplOHMhiEz3CLAhNn1mg5McMFLdIAlPOyMVSEH35D1gVHhzJnnC+Iat
         IrckLrdKYl+1PD2lUDlwBwZaFZ4NQ8rD7Jgtp2sfEhbxH3R+atXvrK15THDU1PbB51fW
         SuTC+t9D7kIh6KrifnB2YZCV1c9mo6KC9eQ0arkMqPKN37e9hnmXpMgJDx34yNKEmsO+
         jMEFFTTpsPQfNs4f+SdwbYUTMy6EimIDeWv39dOCXCT9oExr/vu2NU6wBHRfAYp8QO3U
         5NtoBz44/Zhi9QLVBquLg7+6m8XTSh/NnCC0+zh9ec6+lchhveapBP9ECN1MxJPTxiHj
         PLeQ==
X-Gm-Message-State: AJcUukcdqOSVgSUxevVpfPjrQ7BJVvKhTeIZzVKLxSzMznPykFe7iMxS
        Own+gZ2fqlANlvdts2jb4zkyDXJPGU4SjfLM+sb6yA==
X-Google-Smtp-Source: ALg8bN4VbItOroeSxEvEw8SCc1flb7xE2aKmpBdHh5GGvMssyUM6OhCSRoSSUJLqYmcbd4gHfC+icqMyVYoiWrihe70=
X-Received: by 2002:a5e:940c:: with SMTP id q12mr14862748ioj.228.1545928886956;
 Thu, 27 Dec 2018 08:41:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
 <cce12fc0b89944f1bea0b8bbddacf81547572c0f.1545667662.git.lorenzo.bianconi@redhat.com>
 <20181227105909.GE25885@redhat.com>
In-Reply-To: <20181227105909.GE25885@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Thu, 27 Dec 2018 17:41:17 +0100
Message-ID: <CAJ0CqmVJ_+djjWQ6YnUT7k_H1eauJ2hhy_4GB1jORQ-5bbvRAg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mt76: introduce mt76x02_check_tx_hang watchdog
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Mon, Dec 24, 2018 at 05:24:42PM +0100, Lorenzo Bianconi wrote:
> > Port mt76x02_check_tx_hang watchdog from vendor driver in order to
> > perform a device reset when tx mac/dma logic hangs. Tx mac/dma stuck
> > has been observed when the device is heavily loaded or in a noisy
> > environment.
>
> On what hardware this happen ? Is this only for AP mode?

Hi Stanislaw,

I an able to trigger the issue using a mt7662 AP device till now, not
running STA or other modes yet.
I will respin this patch adding tx watchdog just on mt76x2 devices in
AP mode for the moment.

Regards,
Lorenzo

>
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > index a4ff5a7a219f..402944e81e5e 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > @@ -778,6 +778,90 @@ static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
> >               MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
> >  }
> >
> > +static void mt76x02_mac_watchdog_reset(struct mt76x02_dev *dev)
>
> This all is MMIO specific, it should be moved to mt76x02_mmio.c
>
> Regards
> Stanislaw
