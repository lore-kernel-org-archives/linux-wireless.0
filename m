Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46199C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E541A20875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwDauokI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E541A20875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbeJEPlF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:41:05 -0400
Received: from mail-yw1-f50.google.com ([209.85.161.50]:41139 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEPlE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:41:04 -0400
Received: by mail-yw1-f50.google.com with SMTP id q129-v6so4925433ywg.8
        for <linux-wireless@vger.kernel.org>; Fri, 05 Oct 2018 01:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Yf44McJF5ZW06jKx/Y7wMGqhuPxNMqCEukepcicXUs=;
        b=hwDauokIiCQhtxxogbDVoRsEJeDke2nnXYyN3Xp/8N9+U6yOsi1ip6m2BhMLx6Y0z2
         szjJWtzBw7e1X9zz8xCDhYeS8VIolbiP2NJm7wczZHNqT0HwN1Fv9kRDKAABefCJStQw
         xdg2E8TN8wydnfw4AGWPxkJqPQh7kQBUpi1M9O1ECQ1iRyMzw5o86oOGLkNz18GzmGua
         pKVPcsuy+ty1+Hi2WYMzS3kRctKxjOJE4ioLxvOzbm4CCWi3j8J4fKUZFp21D2OoyOhY
         AbfHOeIrCrC5dEVZPMiUoAfBbhHV7v0nUCTNA4QK13WX0QnL0yswdd6m42mq4oCpTJDs
         yXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Yf44McJF5ZW06jKx/Y7wMGqhuPxNMqCEukepcicXUs=;
        b=BQvc0qoGfmnDEszMAZaug4DI48swB3hXDLcHCRSwLildvWlLgRgropW4c9WxQ+eqye
         stBGkBNQU8Lsaz4WVnhiEHdTrIbNgp0gP+48XnBNjFp6HN4iVR/oqm9DSgCekI67QsqD
         Jul0KKTmMUmRGlGtrrNfTLYbTFj1KPiwQ1YIpFDR+Cf/TcRxad1n/mKCczf8ZS68FGo6
         +79hRJiuUJRcnXUlvs0rKFFuq+oWVInVszuKmAEnzvxwM/LdcFGuIKQwYHB5A3oSJly1
         EBE/SGXf/uoI21HGhRl02y+lOEjvlkFhMJlJ23g0QolbjTW/CnSd57e2d/Boni38ZWhn
         LUUg==
X-Gm-Message-State: ABuFfogZww0FrOIglGJpCx9MJgudkJJGIBNr/K7mMuf2uDfqadz+yLkb
        aSXQt2VSTzOnkQ7jB1qiM2ZV3j61k7s0zYy4Nr4=
X-Google-Smtp-Source: ACcGV63ZvBseM7ikM57VUSfICO2Nh2wVbj/Dpo427C8XBwFniA+hH124ZThQueanZeF1LgL3OupvL+RtAlN9FKF+Rzc=
X-Received: by 2002:a81:9b83:: with SMTP id s125-v6mr5642293ywg.47.1538729001777;
 Fri, 05 Oct 2018 01:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20181005083748.GD1931@redhat.com>
In-Reply-To: <20181005083748.GD1931@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Fri, 5 Oct 2018 10:43:10 +0200
Message-ID: <CAA2SeNLtnOFJpriEVtMiM3c3v-Hb20mayZ2+WSeY76Bvcd_-GQ@mail.gmail.com>
Subject: Re: crash in ieee80211_wake_txqs
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     mpubbise@codeaurora.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Hi
>
> I have crash in ieee80211_wake_txqs:
> https://imgur.com/a/VIrU9yK
> when starting mt76x0u driver. Not sure if this is beacuse the driver
> do not initalize sta->txq properly, but reverting the
>
> commit 21a5d4c3a45ca608477a083096cfbce76e449a0c
> Author: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Date:   Wed Jul 11 00:12:53 2018 +0530
>
>     mac80211: add stop/start logic for software TXQs
>
> make crash gone.
>
> gdb pointed at 'if (ac != txq->ac)' line in the code:
>
>                for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
>                        struct ieee80211_txq *txq = sta->sta.txq[i];
>
>                        txqi = to_txq_info(txq);
>
>                        if (ac != txq->ac)
>                                continue;
>
> Looks txq is NULL and referencing txq->ac crashes.
>
> Thanks
> Stanislaw

Hi Stanislaw,

I guess it is fixed here:
https://marc.info/?l=linux-kernel&m=153694084922438&w=2

Regrads,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
