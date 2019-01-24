Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3420BC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 16:12:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F37B218A2
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 16:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfAXQMo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:12:44 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54888 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbfAXQMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 11:12:43 -0500
Received: by mail-wm1-f66.google.com with SMTP id a62so3746985wmh.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 08:12:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xnHztGI4rrXTkEGJcx7QshBc4BP2jgQ3eMrXsxZaKJs=;
        b=qibHED1+B6Ex5qiaGWstca2njn8PAnOFnhEDzcjgEVfON6ybpJFrJD060IYgKft88x
         2yr4krtRYgsZ5qZDz1xc2yolzVgC9SZ2NJI6OAqhEGA3aoErKHDBheIC9fp9cnc0j+3k
         FFuDskA3AMoNPJCsav0Cyu9ukaAyLy7dvbz53RENKJnOdzb9VNPajbRf22zVWYjg/KD9
         4uLyIHqiWiFpqF50b8Uy3qhhgME7p5qZ1MQtDr09Zc7QlVPOGzF55+l/fDzN0nz6Hrd9
         6MDml7ViT8qN9cY9nvA98131XiRLNoQ8cQueswnJ8vmV95m/UL4tVQ+2pmH1E15YbY9l
         V7vA==
X-Gm-Message-State: AJcUukfyyKFX2go53cR8AXowOf5P8oDR5egRzV23cW8ACIBCPaXorfCx
        AQPXTykhAIJZVedfoza+sT6D/80+8tAd8g==
X-Google-Smtp-Source: ALg8bN6CbOePxQ3WPaR40VhRH4wUVloOeFfKlaGPlQTTBO8yCWO9Zb+sDu3ZPCDuyuScbd8mlliX+Q==
X-Received: by 2002:a1c:6243:: with SMTP id w64mr3206416wmb.153.1548346360560;
        Thu, 24 Jan 2019 08:12:40 -0800 (PST)
Received: from localhost.localdomain (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id s1sm150302114wro.9.2019.01.24.08.12.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 08:12:39 -0800 (PST)
Date:   Thu, 24 Jan 2019 17:12:37 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190124161235.GA10806@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use vif_mask to count interfaces to allow to set mac address
> if there is only one interface and support more STA vifs in
> the future.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02.h      |  2 ++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 18 +++++++++++++-----
>  2 files changed, 15 insertions(+), 5 deletions(-)
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
> index 062614ad0d51..1a949453dc25 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -288,10 +288,7 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
>  mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>  {
>  	struct mt76x02_dev *dev = hw->priv;
> -	unsigned int idx = 0;
> -
> -	if (vif->addr[0] & BIT(1))
> -		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
> +	unsigned int idx, offset = 0;
>  
>  	/*
>  	 * Client mode typically only has one configurable BSSID register,
> @@ -307,7 +304,16 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
>  	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
>  	 */
>  	if (vif->type == NL80211_IFTYPE_STATION)
> -		idx += 8;
> +		offset = 8;
> +
> +	idx = ffs(~(dev->vif_mask >> offset)) - 1;
> +	idx += offset;
> +
> +	/* Allow to change address is only one interface. */
> +	if (!dev->vif_mask && (!ether_addr_equal(dev->mt76.macaddr, vif->addr)))
> +                mt76x02_mac_setaddr(dev, vif->addr);

I guess this does not work if you add 2 vifs and then you remove the first one
(you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured

Regards,
Lorenzo

> +
> +	dev->vif_mask |= BIT(idx);
>  
>  	mt76x02_vif_init(dev, vif, idx);
>  	return 0;
> @@ -318,8 +324,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
>  			      struct ieee80211_vif *vif)
>  {
>  	struct mt76x02_dev *dev = hw->priv;
> +	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
>  
>  	mt76_txq_remove(&dev->mt76, vif->txq);
> +	dev->vif_mask &= ~BIT(mvif->idx);
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
>  
> -- 
> 1.9.3
> 
