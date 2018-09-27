Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF368C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71ED021533
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71ED021533
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbeI0Pyl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbeI0Pyl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:54:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20D17C049D57;
        Thu, 27 Sep 2018 09:37:18 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8A8E5D76E;
        Thu, 27 Sep 2018 09:37:15 +0000 (UTC)
Date:   Thu, 27 Sep 2018 11:37:14 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/4] mt76x0: print BBP version only for debug
Message-ID: <20180927093713.GA20538@redhat.com>
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com>
 <1538037450-18949-2-git-send-email-sgruszka@redhat.com>
 <20180927092629.GA2489@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927092629.GA2489@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 27 Sep 2018 09:37:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:26:30AM +0200, Lorenzo Bianconi wrote:
> > Use dev_dbg to print BBP version.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > index 4fd2c65e196a..ca0a693654a3 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > @@ -187,7 +187,6 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
> >  
> >  	do {
> >  		val = mt76_rr(dev, MT_BBP(CORE, 0));
> > -		printk("BBP version %08x\n", val);
> >  		if (val && ~val)
> >  			break;
> >  	} while (--i);
> > @@ -197,6 +196,7 @@ int mt76x0_wait_bbp_ready(struct mt76x0_dev *dev)
> >  		return -EIO;
> >  	}
> >  
> > +	dev_dbg(dev->mt76.dev, "BBP version %08x\n", val);
> >  	return 0;
> >  }
> 
> I guess we can drop mt76x0_wait_bbp_ready and use mt76x02_wait_for_mac instead

Why? Wait for BBP is diffrent, we read MT_BBP(CORE, 0)=0x2000 register,
wait for MAC we read MT_MAC_CSR0=0x1000 ?

Baside this patch is about replacing printk by dev_dbg.

Thanks
Stanislaw
