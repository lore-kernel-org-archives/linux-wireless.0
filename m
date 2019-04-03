Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404F4C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 11:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F062064A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 11:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfDCLss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 07:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59310 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfDCLsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 07:48:47 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9AA6D81F11;
        Wed,  3 Apr 2019 11:48:47 +0000 (UTC)
Received: from localhost (ovpn-204-220.brq.redhat.com [10.40.204.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D52519926;
        Wed,  3 Apr 2019 11:48:46 +0000 (UTC)
Date:   Wed, 3 Apr 2019 13:48:46 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH v2 01/12] mt76x02: introduce mt76x02_beacon.c
Message-ID: <20190403114845.GA13093@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
 <1552991867-5087-2-git-send-email-sgruszka@redhat.com>
 <8253140b-5ea6-3498-6bfe-144bb86f5962@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8253140b-5ea6-3498-6bfe-144bb86f5962@nbd.name>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 03 Apr 2019 11:48:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 03, 2019 at 11:08:53AM +0200, Felix Fietkau wrote:
> On 2019-03-19 11:37, Stanislaw Gruszka wrote:
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > index ec94d612f53c..75dceeeed059 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > @@ -152,6 +152,21 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
> >  	spin_unlock_bh(&q->lock);
> >  }
> >  
> > +void mt76x02e_init_beacon_config(struct mt76x02_dev *dev)
> > +{
> > +	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
> > +		     (unsigned long)dev);
> > +
> > +	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
> > +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT, 8 << 4);
> > +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
> > +		       MT_DFS_GP_INTERVAL);
> > +	mt76_wr(dev, MT_INT_TIMER_EN, 0);
> > +
> > +	mt76x02_init_beacon_config(dev);
> > +}
> > +EXPORT_SYMBOL_GPL(mt76x02e_init_beacon_config);
> > +
> >  static int
> >  mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_sw_queue *q,
> >  		      int idx, int n_desc)
> > @@ -230,8 +245,6 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
> >  		return -ENOMEM;
> >  
> >  	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
> > -	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
> > -		     (unsigned long)dev);
> Moving the tasklet init to mt76x02e_init_beacon_config can crash the
> kernel, because it leads to the tasklet being re-initialized on every
> reset. I will update that commit and move it back.

Ehh. Some further patches will not apply and will require to be modified.
Perhaps could be easer move mt76x02e_init_beacon_config() to
mt76x2_init_hardware() (or other proper function that is used only
once once during initialization). Or just apply fix on top of the set 
as separate patch. Anyway I'm leaving that up to you. Thanks.

Stanislaw
