Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59C12C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2799C2083D
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 13:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfB1NwV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 08:52:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbfB1NwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 08:52:21 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03700AB976;
        Thu, 28 Feb 2019 13:52:21 +0000 (UTC)
Received: from localhost (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9996C620C3;
        Thu, 28 Feb 2019 13:52:14 +0000 (UTC)
Date:   Thu, 28 Feb 2019 14:52:09 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 07/12] mt76x02: fix hdr pointer in write txwi for USB
Message-ID: <20190228135208.GA8852@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
 <1551341013-24519-8-git-send-email-sgruszka@redhat.com>
 <20190228093819.GA2768@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228093819.GA2768@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 28 Feb 2019 13:52:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 28, 2019 at 10:38:20AM +0100, Lorenzo Bianconi wrote:
> > Since we add txwi at the begining of skb->data, it no longer point
> > to ieee80211_hdr. This breaks settings TS bit for probe response and
> > beacons.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> > index fdd6a021914d..bcf3126efda9 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> > @@ -85,8 +85,9 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
> >  
> >  	mt76x02_insert_hdr_pad(skb);
> >  
> > -	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
> > +	txwi = (struct mt76x02_txwi *)(skb->data - sizeof(struct mt76x02_txwi));
> >  	mt76x02_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
> > +	skb_push(skb, sizeof(struct mt76x02_txwi));
> >  
> >  	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
> >  	txwi->pktid = pid;
> > -- 
> > 2.20.1
> > 
> 
> Good catch :)
> I think we should post it ontop of wireless-drivers since sw encryption is not
> working now.
> 
> Acked-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

I can send it against 5.0, if Kalle will accept it, however
I do not have practical bug associated with this. Maybe we
sometimes can send ordinal frame with TS bit in txwi and it
is then malformed by HW, but I'm not sure. IBSS work with
this bug, not sure about MESH.

Stanislaw

