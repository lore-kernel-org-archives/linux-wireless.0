Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78995C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 10:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45ABF20851
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 10:45:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45ABF20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbeLDKpT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 05:45:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbeLDKpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 05:45:18 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7BF9E3154872;
        Tue,  4 Dec 2018 10:45:18 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C4B75C21C;
        Tue,  4 Dec 2018 10:45:15 +0000 (UTC)
Date:   Tue, 4 Dec 2018 11:45:10 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT 3/4] mt76x02: do not set protection on
 set_rts_threshold callback
Message-ID: <20181204104459.GA2081@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-4-git-send-email-sgruszka@redhat.com>
 <20181109092355.GB4174@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109092355.GB4174@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 04 Dec 2018 10:45:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 10:23:56AM +0100, Lorenzo Bianconi wrote:
> > Use set_rts_threshold calback to enable/disable threshold only for
> > legacy traffic. RTS/CTS threshold for HT TXOP make make no sense
> > to me since used protection (RTS/CTS , CTS-to-self or none)
> > should be determined by HT capabilities and applied to any HT
> > frames.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 16 +---------------
> >  drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
> >  3 files changed, 3 insertions(+), 17 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > index 59b336e34cb5..567a7ab47fab 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > @@ -737,7 +737,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
> >  }
> >  EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
> >  
> > -void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
> > +void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
> >  {
> >  	u32 data = 0;
> >  
> > @@ -751,20 +751,6 @@ void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val)
> >  		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> >  	mt76_rmw(dev, MT_OFDM_PROT_CFG,
> >  		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> 
> Do we need to configure MT_OFDM_PROT_CFG and MT_CCK_PROT_CFG here? (since they
> are already configured in 4/4 (mt76x02: set protection according to ht
> capabilities))

Only OFDM_PROT_CFG is configured there based on legacy proto
value. I'm not sure how handle CCK_PROT_CFG.

> > -	mt76_rmw(dev, MT_MM20_PROT_CFG,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_MM40_PROT_CFG,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_GF20_PROT_CFG,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_GF40_PROT_CFG,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_TX_PROT_CFG6,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_TX_PROT_CFG7,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> > -	mt76_rmw(dev, MT_TX_PROT_CFG8,
> > -		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
> 
> Removing these lines we are no longer able to configure protection for VHT
> rates. Do we have an equivalent for them in vht_capab?

Actually it's not based on HT capabilities but by on ht operation and
it's modified dynamically by hostapd based on what stations are
associated. For STA mode it's provided by remote AP via HT operation IE.

VHT Operation IE do not define protection. Seems interoperability with
legacy STA's is not allowed for VHT, so leaving default values from
initvals where PROT bits are 0 (none protection) is right thing to do.

Regards
Stanislaw
