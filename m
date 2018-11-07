Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10916C46465
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0912085B
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 09:46:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUBHbljM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC0912085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbeKGTQL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 14:16:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46887 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726223AbeKGTQL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 14:16:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id 74-v6so16628698wrb.13
        for <linux-wireless@vger.kernel.org>; Wed, 07 Nov 2018 01:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vojn0juE2KpW/Cfa+SaA1FzF9GXqHINf2TjGHVDef+Y=;
        b=TUBHbljM8rvu4xY2FQ0cCcVRa+Q7YoKMjMf/Y3E9r+fuvm4wwMiuFiysb0TTS4OhcJ
         y+zp4gcQZ672cPGtyNa9ENRVM79fn9nKYVxi/l4REhGaWfHBk7oYtRHcITCfetW+vZob
         Ud16rhrnmGDeg1FbQCI/vvuo070dmcbg7iv9p2Yd46dMCRmX6yXTKVitbp8TsWYOVMTy
         5arVshKkkzUSkW4CdrWPXa6pGjao2pcdSJTJwz7JWXsHkTuwnKeVgI8+9MmAE72mzxST
         XJDfaQ68rzLL5aMhfDaT9njyDH2hnVCoLsGvK5Gs7rRVo3h4zXYmRXhUpkrZgTGXwJi0
         /Q2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vojn0juE2KpW/Cfa+SaA1FzF9GXqHINf2TjGHVDef+Y=;
        b=T61Pyd6P+S/7nOlI2NLgniJTaVZ2raBcgS6X4u7qI4ZFU2iG34HXUkBz/efnJ7c4+N
         i33kmaFWfyPfv8UMuyO0YtY3ACPnuzbTIwHdK9ghkN0gZ+lgs9cvXZBV2yHYUjb9lJjd
         AsJm5hUHzcb7WGRKukQWOo4CMaOfFCbRG4pOjsBuCxRL5bdeueeSdeGai4kr1NYha7pH
         UE8iEoTTcCylwO6SnZO4bl3oy811jB8z2gxaRGUhX3dHicUOhWA5P/dMG5PVP8wvseQK
         //VKEZWJJb6R5yft9xJT1Iu3zX3sC2sqDDUVWYTrgUPf63sVylxr7Cl3wQwaV9N98RQJ
         9/vg==
X-Gm-Message-State: AGRZ1gKNWy4nx/BLnZLdWMnVwPi5vOqIULUw+nONJgCs2+KBRSp40poD
        +MF/z1wnjAnACqrFZDQNHqoSZUDupmMwKkhpT2Y=
X-Google-Smtp-Source: AJdET5c4imuSRZcbVOg5/FLOvVttJJIcyrLurC7Oc0mNz8YeDgh841cfppAKN86L6dWTfWsUFwgxLitC2XstmOTPR5Y=
X-Received: by 2002:adf:afdc:: with SMTP id y28-v6mr1247641wrd.176.1541583994340;
 Wed, 07 Nov 2018 01:46:34 -0800 (PST)
MIME-Version: 1.0
References: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
In-Reply-To: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Wed, 7 Nov 2018 10:46:23 +0100
Message-ID: <CACna6rxJUxGLw1P7d4nCRocHxSs3nyxBvHzr4YaDH9ES+kg39g@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: support STA info struct v7
To:     Rip Route <riproute@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>, Dan HAAB <dan.haab@luxul.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 11 Oct 2018 at 22:21, Dan Haab <riproute@gmail.com> wrote:
> The newest firmwares provide STA info using v7 of the struct. As v7
> isn't backward compatible, a union is needed.
>
> Even though brcmfmac does not use any of the new info it's important to
> provide the proper struct buffer. Without this change new firmwares will
> fallback to the very limited v3 instead of something in between such as
> v4.
>
> Signed-off-by: Dan Haab <dan.haab@luxul.com>

It's too bad Broadcom's existing struct has been changed instead of
just being extended.

The patch looks good to me though. I just wanted to share my opinion /
ping due to patch being marked as "Deferred".

Reviewed-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
