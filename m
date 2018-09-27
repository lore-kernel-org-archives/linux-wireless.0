Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1BDC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18712150D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B18712150D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbeI0Poh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:44:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34339 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbeI0Pnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:43:53 -0400
Received: by mail-wr1-f65.google.com with SMTP id z4-v6so406147wrb.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:26:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cp3Aru76138V+BxIw3+kAyt6evKikvPz9grdiAWhVL0=;
        b=NCsB6i7pikOSzsz9Am1y7gHxRuZ3s1PhQ4afvMVkoz4UpWuNmLW330xQ3dHND2w33n
         RjwJkUiX4/8qR7cDNcoTpdLGRB1E6caXjV6tVUvE7FOasDgGdvRsFTJnpTPVpxe1kU6q
         vZrWBZL4TfVPWJtGuKBN1G58P0Hkek3KepHZ+Je73RU5Lz9Yzr1cUh2F+I2Bgt7B26lx
         te4KGa1miacOjH+2mOFL9mi62CF+cytEWkSCUfx2r3QwaBu02B7cTEgqnyI4MgEB2vxT
         QMwD3euaonBNVLiEVJI+iU762Db0UJwZBE38GPpWR/4agvC/DVJ6SKvqrMn1BFUMZhk2
         eAXA==
X-Gm-Message-State: ABuFfohv4+6vhs2mZ16ynBhl/AKlQUrm8i5jfT9byrG329veENLq54s+
        QFBtl4Nuvj282s6l1IPH6ZO1bR4no/k=
X-Google-Smtp-Source: ACcGV626Gro9Ljq0X+eBHiLn3TBebC6fZ9pailWcupaODYF8FGs9fb0yRftoSTgrrYBTwozrAYTroQ==
X-Received: by 2002:adf:e910:: with SMTP id f16-v6mr8287627wrm.126.1538040392352;
        Thu, 27 Sep 2018 02:26:32 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j133-v6sm3027467wmd.12.2018.09.27.02.26.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:26:31 -0700 (PDT)
Date:   Thu, 27 Sep 2018 11:26:30 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] mt76x0: print BBP version only for debug
Message-ID: <20180927092629.GA2489@localhost.localdomain>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
 <1538037450-18949-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538037450-18949-2-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Use dev_dbg to print BBP version.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index 4fd2c65e196a..ca0a693654a3 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -187,7 +187,6 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
>  
>  	do {
>  		val = mt76_rr(dev, MT_BBP(CORE, 0));
> -		printk("BBP version %08x\n", val);
>  		if (val && ~val)
>  			break;
>  	} while (--i);
> @@ -197,6 +196,7 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
>  		return -EIO;
>  	}
>  
> +	dev_dbg(dev->mt76.dev, "BBP version %08x\n", val);
>  	return 0;
>  }

I guess we can drop mt76x0_wait_bbp_ready and use mt76x02_wait_for_mac instead

Regards,
Lorenzo

>  
> -- 
> 1.9.3
> 
