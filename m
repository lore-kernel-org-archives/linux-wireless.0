Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A98C64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 10:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21D4921473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 10:04:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUhWgcw0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21D4921473
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbeJFRHM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 13:07:12 -0400
Received: from mail-yb1-f178.google.com ([209.85.219.178]:36778 "EHLO
        mail-yb1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFRHM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 13:07:12 -0400
Received: by mail-yb1-f178.google.com with SMTP id 5-v6so6479365ybf.3
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2018 03:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ybxk4cnHbtTX9A0zM3tzSivO2uS60awAS5yopglL11M=;
        b=lUhWgcw0bHLy+7WmZr9gdcwmwhVw4tYx6EcR68wA2NukR5qpRbw8YEebf3XY/ANiJg
         qKyGeeQGDHDKwmboFCBGVqHaAouBJzx1DUWeW++9uQTBJaAiL8+LsntMElfgqvNLR2n/
         oa8xENhu5ALhwXJBrxmlmBLcPR0Eu3olhdBV/L8p5gfsQULXGD114QJUwqmGoBUqfQAE
         ZiU2P5iXlvE0lB2q8Gpm6d6Yv4liamPy9OnVkID7U5d7bKGRTX4M23EqtKnFQJDajmeD
         C7P+AW21MyCvXXt38FtcSa0mBHlO2AQOunAejWKVlRITlTAeUT04iG05mnlolYIsNA9j
         GWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ybxk4cnHbtTX9A0zM3tzSivO2uS60awAS5yopglL11M=;
        b=Q9y152NM78sL4d/W3twRhZGrwBxqdS2pMzbk1//AzO56b3IW3qg0AxF+vSM7khvKTL
         SVSJISZKQ6m2vsx3821uCJE8/eLDwoU611xxBUevFra9ZFtsQ2zlaS1Xg4TNPzIhjR6J
         mvUEeUbu1hf+2X+uQpEIzy3unQsktBmPri6TlO1mV4hT8rgcptHrnTvbuY3hqFyf7ZsX
         6gZljS2B9/95yrkV3ij0zGRJF9bZj2cM+EiSVClaxcslUuqOyafyVh25kzQdgswwQYXM
         obETkJdyqGqmWj+t3uw60wadS+P8pi41ce46hOnSwXH0QoJawS7/llgeU4nGxSNB9cZH
         L5KQ==
X-Gm-Message-State: ABuFfogBcoLb3mEzz6UmTCIrxxcNJ3XeqtuSw0/W/vP4RqjB5k0TbSD6
        fgjQY15sbWoBGuuY9nKnVFE1EsalOQJ14Ml1vqY=
X-Google-Smtp-Source: ACcGV622OGPLBz3c1n/K8lSwBHOGqKvQKXIERU8gks2lykQPjfo1xYCg/Htc8XQBEn6IZ+4YTWCKZKBaCeFVcIZANQY=
X-Received: by 2002:a25:9705:: with SMTP id d5-v6mr8696030ybo.408.1538820271929;
 Sat, 06 Oct 2018 03:04:31 -0700 (PDT)
MIME-Version: 1.0
References: <783b92c4-0fba-35d8-9fdb-2c3462aa9f7f@nbd.name> <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Sat, 6 Oct 2018 12:04:20 +0200
Message-ID: <CAA2SeNK58MmxfrKgiLrp=swveJOURwWQcua3MWyQp9njssAbOA@mail.gmail.com>
Subject: Re: pull request: mt76 2018-10-05
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Felix Fietkau <nbd@nbd.name> writes:
>
> > Here's another large batch of mt76 code cleanup / deduplication / fixes
> >
> > - Felix
> >
> > The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb:
> >
> >   qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44 +0300)
> >
> > are available in the Git repository at:
> >
> >   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-05
> >
> > for you to fetch changes up to 06ac97c2e58c7b32bf950ac53976c4260687d386:
> >
> >   mt76x0: pci: report firmware version using ethtool (2018-10-05 20:05:46 +0200)
> >
> > ----------------------------------------------------------------
> > mt76 patches for 4.20
> >
> > * unify code between mt76x0, mt76x2
> > * mt76x0 fixes
> > * another fix for rx buffer allocation regression on usb
> > * move mt76x2 source files to mt76x2 folder
> > * more work on mt76x0e support
> >
> > ----------------------------------------------------------------
>
> I have to drop this as it doesn't build for me:
>
> drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c: In function 'mt76x0e_load_firmware':
> drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c:119:28: error: passing argument 1 of 'mt76x02_set_ethtool_fwver' from incompatible pointer type [-Werror=incompatible-pointer-types]
>   mt76x02_set_ethtool_fwver(dev, hdr);
>                             ^~~
> In file included from drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h:18:0,
>                  from drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c:20:
> drivers/net/wireless/mediatek/mt76/mt76x0/../mt76x02_mcu.h:108:6: note: expected 'struct mt76_dev *' but argument is of type 'struct mt76x02_dev *'
>  void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
>       ^~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> scripts/Makefile.build:305: recipe for target 'drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.o' failed
>
> --
> Kalle Valo

Hi Kalle,

I guess we can just drop this patch since it is based on 'use
mt76x02_dev instead of mt76_dev as reference' series, sent just as RFC
for the moment.
I will resend this patch on top of other series. Sorry for the noise

Regards,
Lorenzo

--
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
