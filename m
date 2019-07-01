Return-Path: <SRS0=l/K6=U6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B48C0650E
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Jul 2019 11:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9F9B2089C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Jul 2019 11:29:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="UoeDJP2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfGAL3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Jul 2019 07:29:48 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38920 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfGAL3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Jul 2019 07:29:48 -0400
Received: by mail-oi1-f194.google.com with SMTP id m202so9653243oig.6
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jul 2019 04:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgkSfbpNxu018aO72ejnqDYYizZP6mb2608wD1oEZlU=;
        b=UoeDJP2MuGhKBk4DuI7xaRw8S7r6S1Z37HGnbcSXtRuDIG1GAzOjdYKjxGVleWJ0Y3
         HfygUvtadsPpqlacZz8zAPLdIrBpLOauWqJoXuaHdM8HX6/Usr3yTeB0vXkU28nLiv8x
         YuzWW62UJeGfrjhcCNK5uZg/nLwQWo6Funxvb8i2N7Yv/CaviaYVjmcZsN0LWFgMD+pO
         LBRqHzeoO7kdjWgzeLP1Y5n0fHOIUlsKxSOx1Qpnu3cgE81EDpcPtnLE3iigZvdXKh9A
         y9sUS8iQEs2kslWT5jKe4MbM9g/wS0lT3cWAboJ6OWwAmjRlUdmVzFecg4xPN8Ul0bCM
         9Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgkSfbpNxu018aO72ejnqDYYizZP6mb2608wD1oEZlU=;
        b=DYwAxx4KM16hUeZBchTwvjkVmQLH96Cyj6Kca1sdwUVex8NP4E3R57Reb7ryaDViSH
         CexrYBemadBVhOGPnqusLrI4SNIqw/65I38fqpmw8XuEEyr3P6AH7z4OEN9MTdzqDp0g
         XwzBhZR72IOOCtbaGazecuzloOK6zmJ/YZc6QtZ3gP4rttv/abZ0br0k0e+vpZiWP+bV
         bjgT0lgCgMEqDhnsEiPi0tpZLgvmJwL8TiYn39VKgb38vxqw1rM75k7Wfu0C7tISLiFn
         vz23duMK01Hn34jfuNoYw7yRKTT5VYn+mfpGrezD2GwgYHen+bYA7eXUv96qHiF45kdZ
         GhDQ==
X-Gm-Message-State: APjAAAWvvU/ykneqhxeOrUkGRaN0WqRyPARW+b6jIG2N/l3eT2X/DsTJ
        /OyYUIXjUBYb4NsYo/G8i65CC0v7taJUi6FL1xo=
X-Google-Smtp-Source: APXvYqz8WfjEsuwodqGi6ieadQOWcHHY0oo5XGLkjPcDOybEHiHBEtPNo9/BaVCUMys1zNjfoRZUDf6mnRrizOsPEUs=
X-Received: by 2002:aca:4ad2:: with SMTP id x201mr6484278oia.129.1561980587043;
 Mon, 01 Jul 2019 04:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190609203621.13015-1-chunkeey@gmail.com> <87tvcasxpg.fsf@purkki.adurom.net>
 <2176615.mE3b70Bg5n@debian64>
In-Reply-To: <2176615.mE3b70Bg5n@debian64>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 1 Jul 2019 13:29:36 +0200
Message-ID: <CAFBinCCtpz4pqvG1Sy_14ZyY0AL=yBVzxFNbRJUHCG=q+PdAtw@mail.gmail.com>
Subject: Re: [PATCH v3] ath9k: add loader for AR92XX (and older) pci(e)
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, chrisrblake93@gmail.com,
        jonas.gorski@gmail.com, linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Julian Calaby <julian.calaby@gmail.com>, dev@kresin.me,
        juhosg@openwrt.org, john@phrozen.org,
        Hauke Mehrtens <hauke@hauke-m.de>, jow@openwrt.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jun 29, 2019 at 10:44 AM Christian Lamparter <chunkeey@gmail.com> wrote:
[...]
> That said: I have no problem relicensing my code under the ISC, if it
> helps with the upstreaming process. I've added Chris, Martin and
> Mathias as they both were consultants, as well as the previous
> authors of three targets to "let them know".
I am also fine with re-licensing my part of the code (to make it
explicit: of the ath9k PCI OWL loader) under the ISC (which is
expressed as MODULE_LICENSE("Dual BSD/GPL") in the ath9k driver code)


Martin
