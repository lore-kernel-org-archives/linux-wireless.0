Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05479C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 12:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C758D217F5
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 12:11:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kcyeY5wX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfAWMLM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:11:12 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41873 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfAWMLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 07:11:11 -0500
Received: by mail-yw1-f68.google.com with SMTP id f65so774876ywc.8
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2019 04:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vuc+ISJB0HUxqP7OQL+cr6S7tAtolpnDdJPsRB+ehHA=;
        b=kcyeY5wX894TG6E4ee/+V6rgicFGTTRRf7zZGnR2y2O9DLaNTAjfA2DyjvDDR4VcbJ
         Izk1Ylupa+q7v339hoBJPTnXfiDgYcZqopr/aw19PWEsDCLuQy/xKfN65cALFDRGVO4K
         MucJ2ggYP+1DuYj2ikPi5NXe/qn62Rc2oLDdcpu1MWxevcbOFT7P4nqt7uAx/WKAWXPf
         Wylqkto8YK9lzljn6JMi9Mj6vFpz3oyOQvJXlT7eigoHjrBXaj0vbPumyqYSI0MRyiIn
         9zor8PgFI8qJtxCcYfE9bTh9vyAxy2xW4Nl8wmwJYQ7q1QqPnsu1ceMSXTr2rXHkDO2J
         RfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vuc+ISJB0HUxqP7OQL+cr6S7tAtolpnDdJPsRB+ehHA=;
        b=iodeU8j/Bw3Trsr6ofvn0XbzdGFKtmRQkJvl5lSfQNsTAuCpWi5T1cYCOCPoyUgHB9
         SIbkluDipghqdo5Cs2hKm93lPfKhNDO9eb7piBDB9wzWZlNzdkRE6j3aR1EIR0jlHyt8
         QlPSEsiuJ++FAGrw89bqdah/+7M7P66iY2z8YhjJgWRi9lbeCcmVzj/yg6VOkCWPWwdd
         QKwbcAluHRu+SWoKDn8v/i56e8j/ZBhiNpDwHGtuYsGnvOU1HwDIg9LPvvorlhrT4VVp
         uXYaaoYXhb2vB94ijFmE7vZ1RwcpS21yVY6w1CYq7zIlxNte0g9AOd7XQ3OMq/rD2nbP
         WLmA==
X-Gm-Message-State: AJcUukd6OC96NIfPp1lTXrUIWXJ2XnoNMAuZmqdof9D136R/3Zk6FSgC
        u6Jc3zUzA4QwoRZ491f1yQ9HyZc7atB3A8YNT0RKOJ1V0W0=
X-Google-Smtp-Source: ALg8bN7MNMjIRis9cvuTua/4eq8CNOTq+K0fzxuJR+gqkifTYbYomABSxDyUE2HhDTFg+bQEAb7Lt/Ug68l8fNRvr8E=
X-Received: by 2002:a0d:e887:: with SMTP id r129mr1781009ywe.54.1548245470850;
 Wed, 23 Jan 2019 04:11:10 -0800 (PST)
MIME-Version: 1.0
References: <20190122153823.46270-1-nbd@nbd.name>
In-Reply-To: <20190122153823.46270-1-nbd@nbd.name>
From:   Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date:   Wed, 23 Jan 2019 13:10:59 +0100
Message-ID: <CAA2SeN+MJhwYq+c=R9cLZJqXGa_amvjpWF-bDHoLp1GXfzGVfA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mt76: fix per-chain signal strength reporting
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Fix an off-by-one error that resulted in not reporting the signal strength
> for the first chain
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index ce9bb702045f..63fa27d2c404 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -648,7 +648,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
>
>         status->chains = BIT(0);
>         signal = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);

Here I guess we can do:

 signal = status->chain_signal[0] = mt76x02_mac_get_rssi(dev, rxwi->rssi[0], 0);

and avoid duplicated operations.

Regards,
Lorenzo

> -       for (i = 1; i < nstreams; i++) {
> +       for (i = 0; i < nstreams; i++) {
>                 status->chains |= BIT(i);
>                 status->chain_signal[i] = mt76x02_mac_get_rssi(dev,
>                                                                rxwi->rssi[i],
> --
> 2.17.0
>


-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
