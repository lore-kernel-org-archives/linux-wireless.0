Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D08C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622902082C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbfAXWuy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 17:50:54 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33505 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfAXWuy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 17:50:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id p7so8329628wru.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 14:50:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/AxALnwu37BigLrqM4cnA+iFydrEDzaue9LezJZ60C4=;
        b=pBaW9mv/WAk9cd+svLirQGG4xc2nSDLwW4wD9eYJlvLwMRdN6Oh/el2xgQirX1WWSI
         mzmc2rfA1HuykXAuhi5oe8s5z3opZocadNP8O4K5Lp1YSKtDeW5nQYjE+bMdU+FXIGQf
         xYtAsi78kgXEs+IFsomXQtwklU3FMDih+7WhV4C45pcBqsknrur5913mTgZASFYiQ9+u
         flVzWcg+dHWNqEFfjEjITOUgaqcV4ihTuvQULGtvmESWInVbdtIJskAVV3iKTFsZje4Z
         M+V+QYCRTLU+bc6XK+WBb3I+PqzKE1Rka4Xul7sr1l8kmpz+E5C9SMBrlLUoaVHUvDnD
         R+2g==
X-Gm-Message-State: AJcUukdcJOc/eQshLs3qbnQxF0mrFoyUFfiZ1kfwjjZXPdkH7jk4mite
        7AF7dOo8R/P2Y7hXiHOCth9ZFg==
X-Google-Smtp-Source: ALg8bN6SIOfCSaP7rNBZqMmkdNbDIDYekX/pcD7CcueZYOjjrIx2iT76KOsj7BN+ztS9qolzCKiVUw==
X-Received: by 2002:a5d:4586:: with SMTP id p6mr8697375wrq.69.1548370252521;
        Thu, 24 Jan 2019 14:50:52 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id u204sm101271489wmu.30.2019.01.24.14.50.51
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 14:50:51 -0800 (PST)
Date:   Thu, 24 Jan 2019 23:50:49 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] mt76: beaconing fixes for USB
Message-ID: <20190124225048.GD2873@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-7-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548344649-10404-7-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Jan 24, Stanislaw Gruszka wrote:
> Configure beaconing on USB devices without PS buffering support.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mac80211.c     |  3 ++-
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 24 ++++++++++++++++++++---
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  8 +++++---
>  4 files changed, 29 insertions(+), 8 deletions(-)
> 

[...]

> +
> +void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
> +			           bool val, struct sk_buff *skb)
> +{
> +	if (mt76_is_mmio(dev))
> +		tasklet_disable(&dev->pre_tbtt_tasklet);
> +
> +	__mt76x02_mac_set_beacon_enable(dev, vif_idx, val, skb);
> +
> +	if (mt76_is_mmio(dev))
> +		tasklet_enable(&dev->pre_tbtt_tasklet);
> +}
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> index 76e564b8f5da..a15fc71e3d55 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
> @@ -205,7 +205,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
>  int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
>  			   struct sk_buff *skb);
>  void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx,
> -				   bool val);
> +				   bool val, struct sk_buff *skb);
>  
>  void mt76x02_edcca_init(struct mt76x02_dev *dev);
>  #endif
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 741ecd723b8e..8732e07c01ad 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -687,6 +687,7 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
>  {
>  	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
>  	struct mt76x02_dev *dev = hw->priv;
> +	struct sk_buff *skb;
>  
>  	mutex_lock(&dev->mt76.mutex);
>  
> @@ -694,10 +695,11 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
>  		mt76x02_mac_set_bssid(dev, mvif->idx, info->bssid);
>  
>  	if (changed & BSS_CHANGED_BEACON_ENABLED) {
> -		tasklet_disable(&dev->pre_tbtt_tasklet);
> +		skb = NULL;
> +		if (info->enable_beacon && mt76_is_usb(dev))
> +			skb = ieee80211_beacon_get(hw, vif);

What about moving this in mt76x02_mac_set_beacon_enable(), I guess the code
will be more readable. Moreover you can move skb pointer declaration in
if (changed & BSS_CHANGED_BEACON_ENABLED) block

Regards,
Lorenzo

>  		mt76x02_mac_set_beacon_enable(dev, mvif->idx,
> -					      info->enable_beacon);
> -		tasklet_enable(&dev->pre_tbtt_tasklet);
> +					      info->enable_beacon, skb);
>  	}
>  
>  	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
> -- 
> 1.9.3
> 
