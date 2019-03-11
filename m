Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1AFFC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95D72084F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 14:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfCKO66 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726000AbfCKO66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 10:58:58 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D23230821FF;
        Mon, 11 Mar 2019 14:58:58 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FA3B5F9C3;
        Mon, 11 Mar 2019 14:58:54 +0000 (UTC)
Date:   Mon, 11 Mar 2019 15:58:52 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76: mmio: move mt76_insert_hdr_pad in
 mt76_dma_tx_queue_skb
Message-ID: <20190311145852.GF6089@redhat.com>
References: <cover.1552306908.git.lorenzo@kernel.org>
 <e03a38968b3bca0a51a832bdb0dd9ff1beff314d.1552306908.git.lorenzo@kernel.org>
 <20190311133954.GD6089@redhat.com>
 <20190311142517.GB30882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190311142517.GB30882@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 11 Mar 2019 14:58:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 11, 2019 at 03:25:18PM +0100, Lorenzo Bianconi wrote:
> On Mar 11, Stanislaw Gruszka wrote:
> > On Mon, Mar 11, 2019 at 01:35:24PM +0100, Lorenzo Bianconi wrote:
> > > Introduce tx_aligned4_skbs in mt76_driver_ops and move
> > > mt76_insert_hdr_pad in mt76_dma_tx_queue_skb. This is a preliminary
> > > patch in order to unify tx dma mapping for mt76x02 and new chipsets
> > > 
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/wireless/mediatek/mt76/dma.c          |  3 +++
> > >  drivers/net/wireless/mediatek/mt76/mt76.h         |  1 +
> > >  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
> > >  drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c | 13 +++++--------
> > >  drivers/net/wireless/mediatek/mt76/mt76x2/pci.c   |  1 +
> > >  5 files changed, 11 insertions(+), 8 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> > > index a66832a02281..14dd6585bab4 100644
> > > --- a/drivers/net/wireless/mediatek/mt76/dma.c
> > > +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> > > @@ -300,6 +300,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
> > >  	}
> > >  
> > >  	skb->prev = skb->next = NULL;
> > > +	if (dev->drv->tx_aligned4_skbs)
> > > +		mt76_insert_hdr_pad(skb);
> > 
> > We need 4 bytes aligned skbs for mt76x02 or we just need header
> > lenght be multiple of 4 ?  
> 
> I think IV/LLC should be 4 byte aligned

mt76_insert_hdr_pad() does not change alignment of IV/LLC , it only
moves header.

I'm not sure what is actually needed (4 bytes alignment or 4 bytes
lenght), but I just saw Felix sent 2 mac80211 patches that hopfully
do the right thing, so this code after appling mac80211 changes
and set TX_NEEDS_ALIGNED4_SKBS can be removed.

Stanislaw

