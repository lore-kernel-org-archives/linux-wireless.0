Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3FCC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:32:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0604921872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 22:32:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfAXWcU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 17:32:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41226 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfAXWcU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 17:32:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so8237390wrs.8
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 14:32:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OrExiY2vbzKwktpwDupiLsdyrztjGbfdlkkbznet0fA=;
        b=XgK9aFUQ68rTVpBVUve4HoAbalZublAuNZJCS7wW6gR3fES7d3HavuPdeYzwmzHNur
         UlxCYQrw/G/Uscx4SE96V/TRyxts+qOl+EYDRhW/l+dKSP5E5jHvWgMQ1+dhe812pdoK
         E0R6UhZeg35kSmJxQNKBsXGYUZP+jkzMVxwLP1t/WqLpMR0Od3uCUXmr3op9Y0ZNDuzL
         4OCJ2c2DFPntYtb0VaewKQMOtPD8GvdknRb1FbVi2eTPP5cpCIC7V+31kV4DFFPfcJAB
         jisnluZmULz/Pa9D8GdOvJOkzV9FKQWZh6IcL3uPWRgUIsoqsdqclCgItBgOckLVm65w
         LhKQ==
X-Gm-Message-State: AJcUukdH+nZub45HoxTZzO9fCf5Y2O8ZFoD6uqFylPQhkog4Mtexn7Tb
        561ETGnXgzlKNjGDuDw+Ghv3MQ==
X-Google-Smtp-Source: ALg8bN6H0jm9LgEEmGZfm6Dup+Pk7n50sJhJ7T18kDKbLoVV/dGLSIsEjl+qUloi57xxNP8YWBgN8A==
X-Received: by 2002:adf:b307:: with SMTP id j7mr9347649wrd.46.1548369138181;
        Thu, 24 Jan 2019 14:32:18 -0800 (PST)
Received: from localhost.localdomain ([85.93.125.228])
        by smtp.gmail.com with ESMTPSA id y13sm71151725wme.2.2019.01.24.14.32.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 14:32:17 -0800 (PST)
Date:   Thu, 24 Jan 2019 23:32:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/7] mt76x02: minor beaconing init changes
Message-ID: <20190124223213.GB2873@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-5-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548344649-10404-5-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Disable BEACON timer during init and remove interrupt registers
> initialization form generic code since they are PCIe specific.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  7 +++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 11 ++++-------
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  8 ++++++++
>  3 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
> index 1472c8699b29..cb68af5b7478 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
> @@ -128,6 +128,13 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
>  	if (err < 0)
>  		return err;
>  
> +	/* Beaconing: fire a pre-TBTT interrupt 8 ms before TBTT */
> +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
> +		       8 << 4);
> +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
> +		       MT_DFS_GP_INTERVAL);
> +	mt76_wr(dev, MT_INT_TIMER_EN, 0);

What about having a dedicated routine for that configuration since we need it
for mt76x2 and mt76x0 drivers?

> +
>  	if (mt76_chip(&dev->mt76) == 0x7610) {
>  		u16 val;
>  
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 02139dce4800..741ecd723b8e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -667,13 +667,10 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
>  {
>  	int i;
>  
> -	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
> -	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
> -		       8 << 4);
> -	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
> -		       MT_DFS_GP_INTERVAL);
> -	mt76_wr(dev, MT_INT_TIMER_EN, 0);
> -
> +	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
> +					     MT_BEACON_TIME_CFG_SYNC_MODE |
> +					     MT_BEACON_TIME_CFG_TBTT_EN |
> +					     MT_BEACON_TIME_CFG_BEACON_TX));
>  	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
>  
>  	for (i = 0; i < 8; i++)
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
> index 0ccaa64d97ec..f86ff035fa7f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
> @@ -121,6 +121,14 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
>  
>  	mt76x02_mac_setaddr(dev, macaddr);
>  	mt76x02_init_beacon_config(dev);
> +
> +	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
> +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
> +		       8 << 4);
> +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
> +		       MT_DFS_GP_INTERVAL);
> +	mt76_wr(dev, MT_INT_TIMER_EN, 0);
> +
>  	if (!hard)
>  		return 0;
>  
> -- 
> 1.9.3
> 
