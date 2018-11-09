Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CE9C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3F220840
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 11:49:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F3F220840
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbeKIVaC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 16:30:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbeKIVaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 16:30:02 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7886C81F12;
        Fri,  9 Nov 2018 11:49:45 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAD4A19C65;
        Fri,  9 Nov 2018 11:49:41 +0000 (UTC)
Date:   Fri, 9 Nov 2018 12:49:37 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] mt76x02: correct set bssid for STA
Message-ID: <20181109114936.GA2173@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
 <20181109110949.GD4174@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109110949.GD4174@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 09 Nov 2018 11:49:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 09, 2018 at 12:09:50PM +0100, Lorenzo Bianconi wrote:
> > Use MT_MAC_APC_BSSID0_H_EN bit to indicatate we are
> > setting BSSID for STA.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > index 59b336e34cb5..cfeae5586897 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
> > @@ -826,10 +826,16 @@ void mt76x02_mac_work(struct work_struct *work)
> >  
> >  void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
> >  {
> > +	u32 bssid_h = FIELD_PREP(MT_MAC_APC_BSSID_H_ADDR,
> > +				 get_unaligned_le16(addr + 4));
> > +	u32 bssid_l = get_unaligned_le32(addr);
> > +
> > +	if (idx > 7)
> > +		bssid_h |= MT_MAC_APC_BSSID0_H_EN;
> 
> This bit is to enable APClient mode and it is valid just for register 0x1094
> (MT_MAC_APC_BSSID_{L,h}(0)). Moreover IIRC APClient has been disabled because
> it causes a performance degradation.

IIRC MT_MAC_APC_BSSID0_H_EN bit enable BSSID8-15 for STA usage, how we then
can program to device those BSSIDs ?

And if this bit is disabled, shouldn't we use MAC_BSSID_DW for setting BSSID
in STA mode ?

Thanks
Stanislaw
