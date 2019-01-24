Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE8BC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 16:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4B322184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 16:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfAXQfs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 11:35:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39925 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727690AbfAXQfr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 11:35:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id t27so7185658wra.6
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 08:35:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Cwi9XS64BbHBQKsVys7uXaBs1a0udmsnqj5hx6nOA58=;
        b=M62yMCtH1Qgdpzca1sPilgcIeAXLqiXBuZDm3XfcICc8IYiMFC1MytUfMbgak8MiWQ
         IYMQIejG6GAYbg4rb0QjcUaeaOvgFy8sciXaLgSeNslJd76ZHCNIuDbdmowV737jvMi9
         lp241WbjJ2rXvP+8UnEWXCiGuxACEuR736UK3i+BRHDVFKX48ungEzDavr1e2Ypyo+bw
         q11rMt+6BqlKDPuKQZcG9RhuNCfH0Uq+IBkIiaiI3FZcLw+FMe2VKEu9Vl0eqqfkntk8
         CEXgFOT4Mu0hR7t7cwC/giodcnA2Lf/GQelx82Hm8vnzCo0OXERzUCgdPzvJkTLhj2cm
         5T2A==
X-Gm-Message-State: AJcUukd36ePKMsu45YS5gKXBl5A3+S0wzcRSqtExRapJriJ4hxmw2Ked
        6XcBeM0MACggPjnInXEKJRNjDg==
X-Google-Smtp-Source: ALg8bN6l4MI0ob5qYWcrzKtSl95j8QwI+vVdqUxp9okMIoJRIktc9R9Oi9p8oQN3Fn/I94jZ2yOrmg==
X-Received: by 2002:adf:ef88:: with SMTP id d8mr7891548wro.163.1548347745563;
        Thu, 24 Jan 2019 08:35:45 -0800 (PST)
Received: from localhost.localdomain (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id m21sm44177556wmi.43.2019.01.24.08.35.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 08:35:44 -0800 (PST)
Date:   Thu, 24 Jan 2019 17:35:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] mt76x02: use mask for vifs
Message-ID: <20190124163541.GB10806@localhost.localdomain>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
 <1548344649-10404-2-git-send-email-sgruszka@redhat.com>
 <20190124161235.GA10806@localhost.localdomain>
 <20190124162040.GA5136@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124162040.GA5136@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Jan 24, 2019 at 05:12:37PM +0100, Lorenzo Bianconi wrote:
> > > Use vif_mask to count interfaces to allow to set mac address
> > > if there is only one interface and support more STA vifs in
> > > the future.
> > > 
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/mt76x02.h      |  2 ++
> > >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 18 +++++++++++++-----
> > >  2 files changed, 15 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> > > index 6d96766a6ed3..be077443bdb0 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
> > > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
> > > @@ -73,6 +73,8 @@ struct mt76x02_dev {
> > >  
> > >  	struct mutex phy_mutex;
> > >  
> > > +	u16 vif_mask;
> > > +
> > >  	u8 txdone_seq;
> > >  	DECLARE_KFIFO_PTR(txstatus_fifo, struct mt76x02_tx_status);
> > >  
> > > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > index 062614ad0d51..1a949453dc25 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > > @@ -288,10 +288,7 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
> > >  mt76x02_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> > >  {
> > >  	struct mt76x02_dev *dev = hw->priv;
> > > -	unsigned int idx = 0;
> > > -
> > > -	if (vif->addr[0] & BIT(1))
> > > -		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
> > > +	unsigned int idx, offset = 0;
> > >  
> > >  	/*
> > >  	 * Client mode typically only has one configurable BSSID register,
> > > @@ -307,7 +304,16 @@ void mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
> > >  	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
> > >  	 */
> > >  	if (vif->type == NL80211_IFTYPE_STATION)
> > > -		idx += 8;
> > > +		offset = 8;
> > > +
> > > +	idx = ffs(~(dev->vif_mask >> offset)) - 1;
> > > +	idx += offset;
> > > +
> > > +	/* Allow to change address is only one interface. */
> > > +	if (!dev->vif_mask && (!ether_addr_equal(dev->mt76.macaddr, vif->addr)))
> > > +                mt76x02_mac_setaddr(dev, vif->addr);
> > 
> > I guess this does not work if you add 2 vifs and then you remove the first one
> > (you will end up with a wrong configuration in MT_MAC_ADDR_DW{0,1}). I guess
> > the hw will not work well if MT_MAC_ADDR_DW{0,1} is not properly configured

Maybe I am missing something, but let's assume you add the interface vif0 with address
00:11:22:33:44:55 (MT_MAC_ADDR_DW{0,1} will be set to 00:11:22:33:44:55) and
then you add vif1 with address 00:aa:bb:cc:dd:ee. If at some point you remove
vif0 MT_MAC_ADDR_DW{0,1} will not be properly reconfigured. The problem will
be more complex if you have more interfaces

> 
> This is only done when when vif_mask is 0 i.e. no interfaces. When
> some interface is already created, changing MAC address will now work
> anyway.
> 
> Thanks
> Stanislaw
