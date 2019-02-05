Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E06C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECAFD2083B
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 15:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfBEPhv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 10:37:51 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44653 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfBEPhu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 10:37:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id v16so2245628wrn.11
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2019 07:37:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fmxlT1Ath4D6Bn96cGgKj59SS15zsawLbQnfZwJ0gvU=;
        b=Sj8lvH2F6e7IfCm/dySottcjhKxag2CqNGrYCGNLtEgmM9JsVycXaqe6TYL52xV79u
         rC+13mDzep7Hznye4XXJaQpg0THD1HfqJZrDjhZVMgjBgf2RlRmyqP8vJiOYoRq85UWV
         vNW4lMOcWl9l71F+Z2eQxDLtn8c1qg0Wm4BbZAmop6k/J6wl79g2t7dYNGZ8L7+7SRmx
         eLMt9H6T/x/QmxWRZa0GykvM5i5l7RAvMtjQ50y99pjSNLGOplb3/IkJnB15ORjP6kh/
         ywqdlh6goZZwtYDWj4GdkGN7jAo2B0APGomvrPZHBuxbWGiMd5BULVxcjQ2Q3iUdpHTA
         OxTA==
X-Gm-Message-State: AHQUAuaPtCcN2CnSHx4QG1+L5K4Hb1NDcgVA6mcdjlbxzSoKNd4VHQl9
        WAbp/mfHmouDwCSpDWW3BOweeA==
X-Google-Smtp-Source: AHgI3IYGn/h6QnpYr/k/0koumqJ+LU5jK5uMYj/0w94YTTPur3A30SU5WLRQIk74ehOcquJMRijjLg==
X-Received: by 2002:adf:8061:: with SMTP id 88mr4355880wrk.10.1549381068786;
        Tue, 05 Feb 2019 07:37:48 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e7sm9635568wme.15.2019.02.05.07.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Feb 2019 07:37:47 -0800 (PST)
Date:   Tue, 5 Feb 2019 16:37:45 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 5.0] mt76x0u: fix suspend/resume
Message-ID: <20190205153744.GA13965@localhost.localdomain>
References: <1549378057-13790-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549378057-13790-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> We need to reset MCU and do other initalizations on resume otherwise
> MT7610U device will fail to initalize, what cause system hung due to
> USB requests timeouts.
> 
> Patch fixes 4.19 -> 4.20 regression.
> 
> Cc: stable@vger.kernel.org # 4.20+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 43 +++++++++++++------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> index 0e6b43bb4678..bd1dedcb7952 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -158,39 +158,52 @@ static const struct ieee80211_ops mt76x0u_ops = {
>  	.get_txpower = mt76x02_get_txpower,
>  };
>  
> -static int mt76x0u_register_device(struct mt76x02_dev *dev)
> +static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
>  {
> -	struct ieee80211_hw *hw = dev->mt76.hw;
>  	int err;
>  
> -	err = mt76u_alloc_queues(&dev->mt76);
> -	if (err < 0)
> -		goto out_err;
> -
> -	err = mt76u_mcu_init_rx(&dev->mt76);
> -	if (err < 0)
> -		goto out_err;
> -
>  	mt76x0_chip_onoff(dev, true, true);
> +

Why this new line here? it is not related to the patch

>  	if (!mt76x02_wait_for_mac(&dev->mt76)) {
>  		err = -ETIMEDOUT;
> -		goto out_err;
> +		return err;

just return -ETIMEDOUT here

For the rest looks good to me

Regards,
Lorenzo

>  	}
>  
>  	err = mt76x0u_mcu_init(dev);
>  	if (err < 0)
> -		goto out_err;
> +		return err;
>  
>  	mt76x0_init_usb_dma(dev);
> +
>  	err = mt76x0_init_hardware(dev);
>  	if (err < 0)
> -		goto out_err;
> +		return err;
>  
