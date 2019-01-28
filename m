Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BD8C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 13:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D536D2148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 13:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfA1Nft (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 08:35:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39365 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfA1Nfs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 08:35:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so18064555wra.6
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 05:35:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Sgki3DCi5p57USUZUftdnjA0KhuiVIZixfnbzHpfgMY=;
        b=PCDbxoyA0ViezpDak/Q8tE2zhPiK3vU0gvFDNbr4p9p0WrhVcH0xToXeXh0glTY0H6
         b9NfMF23phl8p4tfED8GWxCcradh4CwzYUyyLRW82AipxrZhxlT8I8nY0cMLXqXV1gHO
         xLDeU9FL7fM1HhodjV6XQOhOUxMPUkVDDUbkZTrz3c4f+xktx/8T7+H5iFMLJfu0TvQt
         HO4goQG5BpOKjmxYxkP3eyLPHlxet6EposhmrR7woFeajD7v6wQ24vdOt1bkeVUUsgFz
         BLfAmyN6ROHwjkIvHnxk+5u638bK6HvP2GIn/IPX2KvIYOwX1SjN+pHalbLXkyHpzAMD
         A2SQ==
X-Gm-Message-State: AJcUukcJoGsSfW7ouR1QdcfRRQAHvaF8altjRh766z7R75/jCOQeAGCh
        +aHypoEt9f7CCIrObvlNlBsklg==
X-Google-Smtp-Source: ALg8bN6fFnZUZfhV9S+/WkCeUxFEXubSONP1n9/9q9Gq1cj05rLtgtQA5CuLRo67OjQnNX+dA3PhzQ==
X-Received: by 2002:adf:be8b:: with SMTP id i11mr22996353wrh.235.1548682547140;
        Mon, 28 Jan 2019 05:35:47 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id g188sm90274109wmf.32.2019.01.28.05.35.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 28 Jan 2019 05:35:46 -0800 (PST)
Date:   Mon, 28 Jan 2019 14:35:39 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mt76x02: use mask for vifs
Message-ID: <20190128133537.GB9257@localhost.localdomain>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <1548678108-9526-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548678108-9526-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use vif_mask to count interfaces to allow to set mac address in HW
> if there is only one interface and report error if we create
> interface with wrong BSSID resulting in already used index.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v2:
> - do not change vif index calculation
> - return error for already used index
> 
>  drivers/net/wireless/mediatek/mt76/mt76x02.h      |  2 ++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 12 +++++++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> index 6d96766a6ed3..be077443bdb0 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> @@ -73,6 +73,8 @@ struct mt76x02_dev {
>  
>  	struct mutex phy_mutex;
>  
> +	u16 vif_mask;
> +
>  	u8 txdone_seq;
>  	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
>  
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 062614ad0d51..2e805d5493de 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -292,7 +292,6 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>  
>  	if (vif->addr[0] & BIT(1))
>  		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
> -
>  	/*
>  	 * Client mode typically only has one configurable BSSID register,
>  	 * which is used for bssidx=0. This is linked to the MAC address.
> @@ -309,6 +308,15 @@ mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>  	if (vif->type == NL80211_IFTYPE_STATION)
>  		idx += 8;
>  

Maybe we shoud grub dev->mt76.mutex here, since we can have multiple processes trying
to add an interface

> +	if (dev->vif_mask & BIT(idx))
> +		return -EBUSY;
> + 
> +	/* Allow to change address in HW if we create first interface. */
> +	if (!dev->vif_mask && !ether_addr_equal(dev->mt76.macaddr, vif->addr))
> +                mt76x02_mac_setaddr(dev, vif->addr);
> +
> +	dev->vif_mask |= BIT(idx);
> +
>  	mt76x02_vif_init(dev, vif, idx);
>  	return 0;
>  }
> @@ -318,8 +326,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
>  			      struct ieee80211_vif *vif)
>  {
>  	struct mt76x02_dev *dev = hw->priv;
> +	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
>  
>  	mt76_txq_remove(&dev->mt76, vif->txq);
> +	dev->vif_mask &= ~BIT(mvif->idx);

If we are removing the first configured interface, should we have to update
MT_MAC_ADDR_DW{0,1} regs?

Regards,
Lorenzo

>  }
>  EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
>  
> -- 
> 2.19.2
> 
