Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2712EC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7D7A2081C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7D7A2081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbeKIVHJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:07:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52315 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKIVHJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:07:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id r11-v6so1678398wmb.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 03:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5tsqv1XgBVcBupV7Sof8jszbb4yO9+FBcjuuxdE5smE=;
        b=p7IQHwOVXi4/V+eOtRJdSVRSFFesmXRG9Yt3XJ7Jtens69IOx9VvPgR6GwyhP4DU/V
         qwz5tbxc6HbNW92ohQAVh9yTL9LYygiYWMez6Dq27MqzAN9Q33Ph7LZ+uJDMb5YdyHzN
         zfrJ4lkWtzeBcBSbW+FniP2cnRsx3pRn6GIms5PScM5lqbei9ihhMQsV95nAt4/0G2rr
         DkORJ76E89Ycds09KsoYpy6yMi0+cPAFtxcZFGUK78+z3/qJVwhauDPxAN7nepzYPfvT
         y9+oQZNO8+2OfXpQxsRup8BE3Mp2gsy6PANfKNN/sgn/hjpVBrrqpwo/d5VlioV4CCZk
         Un+w==
X-Gm-Message-State: AGRZ1gKMn5cEMtWZbL25P6cySnN4Z1HfVzEzsbXSGP6rInKQUu2fiD9U
        i7cve16NSbai22yO22s+guh7iQ==
X-Google-Smtp-Source: AJdET5cLPlqZKmgxlLGGH0uViiQq8MCS7qJbVz6V6UbfKCVNEOc3lhkSDeCNrfFc+IiQNxQaCd8icA==
X-Received: by 2002:a1c:6a01:: with SMTP id f1-v6mr4232100wmc.85.1541762816008;
        Fri, 09 Nov 2018 03:26:56 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q7-v6sm1243605wmg.27.2018.11.09.03.26.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 03:26:55 -0800 (PST)
Date:   Fri, 9 Nov 2018 12:26:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Message-ID: <20181109112651.GF4174@localhost.localdomain>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Configure multi bss mode by default on all devices. That mean we
> use MAC address for MT_MAC_BSSID_DW and use MT_MAC_APC_BSSID
> for configuree bssid for each vif.
> 
> This is separe from beaconing as we can have for example 2 STA vifs,
> so do not mix bssid init and beacon init.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c   |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     | 17 +++++++++++++++--
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h     |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 13 ++-----------
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  4 +---
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c |  3 ---
>  7 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
> index 497e762978cc..5036b61b66f9 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c

[snip]

> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> index de0fbdb02c4d..4fb87deff261 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
> @@ -189,7 +189,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
>  	if (err < 0)
>  		return err;
>  
> -	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
> +	mt76x02_mac_init_mbss(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
>  	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
>  
>  	if (!mt76x02_wait_for_txrx_idle(&dev->mt76))
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> index a9ecc92875ae..977e74091a27 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
> @@ -52,9 +52,6 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
>  	struct mt76x02_dev *dev = hw->priv;
>  	unsigned int idx = 8;
>  
> -	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
> -		mt76x02_mac_setaddr(dev, vif->addr);
> -

I think this is a regression since you will able to change device mac address
in this way. Do you agree?

>  	mt76x02_vif_init(dev, vif, idx);
>  	return 0;
>  }
> -- 
> 1.9.3
> 
