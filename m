Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93F3C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 10:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF3BB2184B
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 10:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfAYKZw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:25:52 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36656 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbfAYKZv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 05:25:51 -0500
Received: by mail-wr1-f65.google.com with SMTP id u4so9702228wrp.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 02:25:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QAvmdEQ95FkXze9n7fjnrHCEuihRXdGsaA3zjMUMGR8=;
        b=qCxPEYHBJain2bA+dZFwAkmICd6HiNtq35CEyAYFsEOwnvR2oQBaQYWBI3h89IwQCf
         UPJuenOHUOrqQ0r6k8BdxFZTknZmLA8624V1GjRAWSY3OxWp5H+3OyUoml2LVsIoLYU4
         Tsr0fotuMICXQ7uF5ZyaUl0epPsNPwmlIyIWvdD1ULWxcu+dGodwsqJ5Ho8BfQtSJu1j
         ALtKS+hAGQ2AktHU/L7SwUy4RT2u7mkh57szGFVOymzZctGLBWD3QPUEvRtRHDZRDJ5i
         g9gAl9Lr112YrZdhHOxq7yISJXxLmWlzhRzhOW5Gcnp9W8Tj5/IKYmmPxhbcOSDLrBZA
         r9qw==
X-Gm-Message-State: AJcUukef4MQocTTXJieNtTL8dCfKwvdSqVYxlvGQ3wLbHbFCiCokR1xJ
        wx1wsgzUQY7eYs0urQOOPsEQmg==
X-Google-Smtp-Source: ALg8bN4Yg45j2L8REtX4HWBZwJUMwjAzyHL8uB+BzOzP/lVlTpXgpc+Es68V2YPcw5rmhEcDUhtvlA==
X-Received: by 2002:a5d:5443:: with SMTP id w3mr10198310wrv.4.1548411949950;
        Fri, 25 Jan 2019 02:25:49 -0800 (PST)
Received: from p1372.fit.wifi.vutbr.cz ([147.229.117.36])
        by smtp.gmail.com with ESMTPSA id o81sm98799523wmd.10.2019.01.25.02.25.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 02:25:49 -0800 (PST)
Date:   Fri, 25 Jan 2019 11:25:46 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190125102545.GA27731@p1372.fit.wifi.vutbr.cz>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
 <20190124163541.GB10806@localhost.localdomain>
 <20190124222040.GA2873@localhost.localdomain>
 <20190125082556.GA2180@redhat.com>
 <20190125090236.GA2761@p1372.fit.wifi.vutbr.cz>
 <20190125094757.GA11700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125094757.GA11700@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Fri, Jan 25, 2019 at 10:02:38AM +0100, Lorenzo Bianconi wrote:
> > > On Thu, Jan 24, 2019 at 11:20:42PM +0100, Lorenzo Bianconi wrote:
> > > > > > > 
> > > > > > > I guess this does not work if you add 2 vifs and then you remove the first one
> > > > > > > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > > > > > > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured
> > > > > 
> > > > > Maybe I am missing something, but let's assume you add the interface vif0 with address
> > > > > 00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
> > > > > then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
> > > > > vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
> > > > > be more complex if you have more interfaces
> > > 
> > > Ok, so in remove_interface extra code can be added to implement that.
> 
> Something like this should address the issue you raised:
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index 3880caa0c64a..44b4af928a4e 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -320,6 +320,15 @@ void mt76x02_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_add_interface);
>  
> +static void mt76x02_setaddr_iterator(void *data, u8 *mac,
> +                                     struct ieee80211_vif *vif)
> +{
> +	struct mt76x02_dev *dev = data;
> +
> +	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
> +                mt76x02_mac_setaddr(dev, vif->addr);

This will end-up with multiple configurations if we have more than two
interfaces, right?

> +}
> +
>  void mt76x02_remove_interface(struct ieee80211_hw *hw,
>  			      struct ieee80211_vif *vif)
>  {
> @@ -328,6 +337,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
>  
>  	mt76_txq_remove(&dev->mt76, vif->txq);
>  	dev->vif_mask &= ~BIT(mvif->idx);
> +
> +	if (hweight16(dev->vif_mask) == 1)
> +		ieee80211_iterate_interfaces(hw, 0, mt76x02_setaddr_iterator,
> +					     dev);

I guess we have the same issue if we have more than two interfaces and we
remove the first one that has been configured.
Moreover I am a little worried about tpt regressions with this patch.
Are you sure that if you use complete different mac addresses on a multivif scenario
you can get the same tpt on all the interfaces? Could you please provide some
tpt results?
Vendor driver relies on a strict scheme for mac addresses in multi-bss. If tpt is
nice I am ok with this patch

Regards,
Lorenzo

>  }
>  EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
