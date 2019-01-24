Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AF2C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8D2821872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbfAXWda (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 17:33:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33181 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfAXWda (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 17:33:30 -0500
Received: by mail-wm1-f67.google.com with SMTP id r24so3415145wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 14:33:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YJXw4827T7nMQB1Gz41sxK9Q1mfiWrKx100GT7vdi/Q=;
        b=MZDvkNxVgGFUlK3ySAtO/9141nfFPcpbsn4NTgoYLyE2GhRdrQOLPun005dlcG80eg
         Vwv81QWaz7Vb1DfFJeN3fzusDzHYj8zmTM0yDeCSik2vbSpzxM/A3hpO+QXZzSI2N/Af
         alhPIJfnEcUVkzSUM7/WVGyXfWaQxErvuU9ty2u0ZnHRn2SLERyNyGc8yd8AvdGGzANL
         PxY5FmJmDJPQP0JZpSklg6PAXtgcTBV/4VsDzdAhpugB/FR6DRONthtW6YkFiHJYND/f
         IhGTyEPbRLpx/YheO8AjrVg9heBym3QK3b1Vpbv1Cl1ZxN9ATASR4Qa9FiZ7VkykJl3v
         GZww==
X-Gm-Message-State: AJcUukf0hSurzsQa26yvlc88A6E6UtHUtVM1bS7sX/fdYt76wiHos2KP
        0ZY8dtt9YYFoPtiH+pg1fAzWiw==
X-Google-Smtp-Source: ALg8bN7Ci9dcVDF597RdZsD0wDSbDarZ6hRrcvWCX2THderF6LKIVbrLtdFVoytDOHxJWxJiG8Uwow==
X-Received: by 2002:a1c:2007:: with SMTP id g7mr4316706wmg.79.1548369208474;
        Thu, 24 Jan 2019 14:33:28 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id m15sm86809366wrr.95.2019.01.24.14.33.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 14:33:27 -0800 (PST)
Date:   Thu, 24 Jan 2019 23:33:25 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/7] mt76x02: init beacon config for mt76x2u
Message-ID: <20190124223324.GC2873@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-6-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548344649-10404-6-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Initialize beaconing also on mt76x2u.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> index 0be3784f44fb..3737e9fa8295 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> @@ -207,11 +207,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
>  			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
>  	}
>  
> -	mt76_clear(dev, MT_BEACON_TIME_CFG,
> -		   MT_BEACON_TIME_CFG_TIMER_EN |
> -		   MT_BEACON_TIME_CFG_SYNC_MODE |
> -		   MT_BEACON_TIME_CFG_TBTT_EN |
> -		   MT_BEACON_TIME_CFG_BEACON_TX);
> +	mt76x02_init_beacon_config(dev);
>  
>  	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
>  	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x583f);
> -- 
> 1.9.3
> 

I think this can be squashed with 4/7
