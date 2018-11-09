Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B9CC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8B3B20840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 09:24:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8B3B20840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbeKITDo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:03:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32992 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbeKITDo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 14:03:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id u9-v6so1129568wrr.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 01:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mFoMy2iozgkaYXsqEkLEXZ1qyKyFzxDkLcvEqB9+cnQ=;
        b=eRk8kATojZHmcAXYzvsWRJAnnop5gVbW4dKwml00wQDx6o9MHVI4sq75oDlVLRd7dK
         3onUZK40hvx0zljYUlMdDegLm6TFIM9it4O9B3nQOvY7J16mfyUvCx6ZnQcvh7lf5SdV
         k4nmxyEkRAa1pLGuIhMxqHQtgV2xXsqBzYxJX/T7yeTdmQiL87vkLq/PCYxlX7bBoUgG
         VugZJ++6lR7ZV4dsfGp1eg58l7BCfUcVyN+49CitJh4k+syAJ0+vXr1amz5pBs/siKKB
         180nBPrkKaArGjtK0chE0aTOV022lyBH7/tPyp6vBg57f8u4dT3jzeFcU+Fp/PdB8xCo
         adyQ==
X-Gm-Message-State: AGRZ1gKWpNP2GnBwY7V2W1Xm6bnoqf3uszoOWXu6qMUzdkLvYirYHX1c
        Nflm9pmnK5TohzjZZmjzNjgxO9zQ3Ls=
X-Google-Smtp-Source: AJdET5e0MfFQs+7RV4v8g/wb59IC0p/z+E+Ovt0AHTvJLrkoO1xC4zR8shTg336rTp02bcXrFDdtgQ==
X-Received: by 2002:adf:f0c9:: with SMTP id x9-v6mr6895883wro.15.1541755441223;
        Fri, 09 Nov 2018 01:24:01 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c184-v6sm712018wma.15.2018.11.09.01.24.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 01:24:00 -0800 (PST)
Date:   Fri, 9 Nov 2018 10:23:56 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 3/4] mt76x02: do not set protection on
 set_rts_threshold callback
Message-ID: <20181109092355.GB4174@localhost.localdomain>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-4-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541688430-31855-4-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use set_rts_threshold calback to enable/disable threshold only for
> legacy traffic. RTS/CTS threshold for HT TXOP make make no sense
> to me since used protection (RTS/CTS , CTS-to-self or none)
> should be determined by HT capabilities and applied to any HT
> frames.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 16 +---------------
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
>  3 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> index 59b336e34cb5..567a7ab47fab 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> @@ -737,7 +737,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
>  
> -void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
> +void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
>  {
>  	u32 data = 0;
>  
> @@ -751,20 +751,6 @@ void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
>  		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
>  	mt76_rmw(dev, MT_OFDM_PROT_CFG,
>  		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);

Do we need to configure MT_OFDM_PROT_CFG and MT_CCK_PROT_CFG here? (since they
are already configured in 4/4 (mt76x02: set protection according to ht
capabilities))

> -	mt76_rmw(dev, MT_MM20_PROT_CFG,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_MM40_PROT_CFG,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_GF20_PROT_CFG,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_GF40_PROT_CFG,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_TX_PROT_CFG6,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_TX_PROT_CFG7,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> -	mt76_rmw(dev, MT_TX_PROT_CFG8,
> -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);

Removing these lines we are no longer able to configure protection for VHT
rates. Do we have an equivalent for them in vht_capab?

Regards,
Lorenzo

>  }
