Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E26C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5CC72086D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:35:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5CC72086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJIOvY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 10:51:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbeJIOvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 10:51:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7DB3356FD;
        Tue,  9 Oct 2018 07:35:49 +0000 (UTC)
Received: from localhost (ovpn-204-240.brq.redhat.com [10.40.204.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 143DF67CCB;
        Tue,  9 Oct 2018 07:35:46 +0000 (UTC)
Date:   Tue, 9 Oct 2018 09:35:46 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: phy: fix restore phase in
 mt76x0_phy_recalibrate_after_assoc
Message-ID: <20181009073545.GA21027@redhat.com>
References: <cover.1539001391.git.lorenzo.bianconi@redhat.com>
 <ff6672828b7e970124a425304ad734d58133a6ff.1539001391.git.lorenzo.bianconi@redhat.com>
 <636edb3c-a2dc-306d-8ddd-8b91ebafd4f1@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <636edb3c-a2dc-306d-8ddd-8b91ebafd4f1@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 09 Oct 2018 07:35:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 08, 2018 at 08:11:45PM +0200, Felix Fietkau wrote:
> On 2018-10-08 14:40, Lorenzo Bianconi wrote:
> > Fix restore value configured in 0x2124 register in
> > mt76x0_phy_recalibrate_after_assoc routine.
> > 
> > Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > index 99e0a91a2f99..d18942e54048 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > @@ -734,8 +734,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
> >  	usleep_range(500, 700);
> >  
> >  	reg_val = mt76_rr(dev, 0x2124);
> > -	reg_val &= 0xffffff7e;
> > -	mt76_wr(dev, 0x2124, reg_val);
> > +	mt76_wr(dev, 0x2124, 0xffffff7e);
> I'm pretty sure you can drop the mt76_rr as well. Also, you can refer to
> 0x2124 as MT_BBP(IBI, 9).

I think is needed we do:

	reg_val = mt76_rr(dev, 0x2124); 
	mt76_wr(dev, 0x2124, 0xffffff7e);

	CALIBRATE

	mt76_wr(dev, 0x2124, reg_val);

so seems we have to restore orginal value after calibration.

Referencing as MT_BBP(IBI, 9) is obviously fine.

Thanks
Stanislaw
 
