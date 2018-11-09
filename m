Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305C0C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03D8020818
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:18:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03D8020818
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbeKIU7F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:59:05 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33878 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKIU7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:59:05 -0500
Received: by mail-wr1-f65.google.com with SMTP id j26-v6so1505117wre.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 03:18:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QeNCRKxgqKT4vplGLQ6mHr8JRgTY3cOgi5XIabGuB7A=;
        b=YnPRUt9y9rvXUgxm6YTehACbR8bRlYmT2MnD6ZijDcOWsSvpQQsTMZuB6MnMhFEgxK
         4qnpgWIccrgxCKnJkdh3mvvNJr0h+5zj4EFZWqBtFbt8W+GX88m/LRwIBSBkZfqTuNxm
         tvAn4i+AmfSxDtMzUF1IuWrRbe5cGAO5P9coZDmstCZnlkc5kkNrDv2gwvpZcPZC1lji
         An2hKfthSzG1eCpqf2Qf/78VL9Ap2crMPujd4ogvZfdSGiuQn3tQt2XNH5NKcyn+EiV7
         WLJiSEXRVgpif49ibV0sVdai6UPlkw56w2dAAaCrH7cAMLEheh6Jw2t6eg82xI3nEDEq
         jpvQ==
X-Gm-Message-State: AGRZ1gJtFo0q8cwMwYWwZF8oiYGYfPKJH8QdJ71euOXhaamboDinM7Ip
        Kt809xBFuiFtTdIQkY1PiVWI9Q==
X-Google-Smtp-Source: AJdET5czvBm0iAJJYV0levPDbduvcT4mYnzFHFYlS3+DurENEXMfMlVnz900ZEc114yBdIPHYnbjpA==
X-Received: by 2002:adf:f542:: with SMTP id j2-v6mr7280519wrp.70.1541762333742;
        Fri, 09 Nov 2018 03:18:53 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z6-v6sm8513226wrs.19.2018.11.09.03.18.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 03:18:53 -0800 (PST)
Date:   Fri, 9 Nov 2018 12:18:49 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] mt76x2u: use common mt76x02_add_interface
Message-ID: <20181109111848.GE4174@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-4-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541758814-2046-4-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> There is no need anymore to use custom add interface function
> for mt76x02u.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02.h         |  2 --
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c    |  6 +++---
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 12 +-----------
>  3 files changed, 4 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> index a8c5fdd903b9..f8e998ef8716 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> @@ -115,8 +115,6 @@ int mt76x02_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  		      struct ieee80211_sta *sta);
>  
> -void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
> -		      unsigned int idx);
>  int mt76x02_add_interface(struct ieee80211_hw *hw,
>  			 struct ieee80211_vif *vif);
>  void mt76x02_remove_interface(struct ieee80211_hw *hw,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 2aa3f4b15fd9..dbf9d89dd328 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -228,8 +228,9 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_sta_remove);
>  
> -void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
> -		      unsigned int idx)
> +static void
> +mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
> +		 unsigned int idx)
>  {
>  	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
>  
> @@ -238,7 +239,6 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
>  	mvif->group_wcid.hw_key_idx = -1;
>  	mt76x02_txq_init(dev, vif->txq);
>  }
> -EXPORT_SYMBOL_GPL(mt76x02_vif_init);
>  
>  int
>  mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> index 977e74091a27..6b51dd749491 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> @@ -46,16 +46,6 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
>  	mutex_unlock(&dev->mt76.mutex);
>  }
>  
> -static int mt76x2u_add_interface(struct ieee80211_hw *hw,
> -				 struct ieee80211_vif *vif)
> -{
> -	struct mt76x02_dev *dev = hw->priv;
> -	unsigned int idx = 8;
> -
> -	mt76x02_vif_init(dev, vif, idx);
> -	return 0;
> -}

This routines seems wrong since here we should have the possibility to change
the device mac address:
https://github.com/nbd168/wireless/blob/mt76/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c#L54

and IIRC I have not removed it in:
https://patchwork.kernel.org/patch/10670853/

Regards,
Lorenzo

> -
>  static int
>  mt76x2u_set_channel(struct mt76x02_dev *dev,
>  		    struct cfg80211_chan_def *chandef)
> @@ -122,7 +112,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
>  	.tx = mt76x02_tx,
>  	.start = mt76x2u_start,
>  	.stop = mt76x2u_stop,
> -	.add_interface = mt76x2u_add_interface,
> +	.add_interface = mt76x02_add_interface,
>  	.remove_interface = mt76x02_remove_interface,
>  	.sta_add = mt76x02_sta_add,
>  	.sta_remove = mt76x02_sta_remove,
> -- 
> 1.9.3
> 
