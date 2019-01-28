Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75451C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 14:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 483542171F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 14:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbfA1OYH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:24:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59587 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfA1OYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 09:24:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 877C88EA29;
        Mon, 28 Jan 2019 14:24:06 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFF4B62662;
        Mon, 28 Jan 2019 14:24:00 +0000 (UTC)
Date:   Mon, 28 Jan 2019 15:23:58 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mt76x02: use mask for vifs
Message-ID: <20190128142357.GA9571@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
 <1548678108-9526-2-git-send-email-sgruszka@redhat.com>
 <20190128133537.GB9257@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190128133537.GB9257@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Mon, 28 Jan 2019 14:24:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 02:35:39PM +0100, Lorenzo Bianconi wrote:
> >  
> 
> Maybe we shoud grub dev->mt76.mutex here, since we can have multiple processes trying
> to add an interface

Interface creation and deletion are protected by rtnl_lock(), can not
be performed concurrently.

> > @@ -318,8 +326,10 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
> >  			      struct ieee80211_vif *vif)
> >  {
> >  	struct mt76x02_dev *dev = hw->priv;
> > +	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
> >  
> >  	mt76_txq_remove(&dev->mt76, vif->txq);
> > +	dev->vif_mask &= ~BIT(mvif->idx);
> 
> If we are removing the first configured interface, should we have to update
> MT_MAC_ADDR_DW{0,1} regs?

What for ?

Thanks
Stanislaw 
