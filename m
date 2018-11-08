Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A32CECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41E522077B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 15:54:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41E522077B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbeKIBaO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 20:30:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbeKIBaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 20:30:14 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9D89487645;
        Thu,  8 Nov 2018 15:54:07 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37C835129E;
        Thu,  8 Nov 2018 15:54:04 +0000 (UTC)
Date:   Thu, 8 Nov 2018 16:54:03 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 2/4] mt76x02: reserve wcid 0 for global traffic
Message-ID: <20181108155403.GB13621@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
 <1541688430-31855-3-git-send-email-sgruszka@redhat.com>
 <CAJ0CqmXS6zkJf3FHb5wYyPPzvqG5OBZDfcYWSjbaJY_nhcErzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmXS6zkJf3FHb5wYyPPzvqG5OBZDfcYWSjbaJY_nhcErzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 08 Nov 2018 15:54:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 08, 2018 at 04:01:54PM +0100, Lorenzo Bianconi wrote:
> > Restore behaviour on mt76x0 before commit  1bb04bb4b838 ("mt76: move
> > mt76x02_init_device in mt76x02-lib module"). This will allow to use
> > wcid 1 for AP when we work in station mode. It's not clear if this
> > is needed, but this is how vendor driver assign wcid's in STA mode.
> > This should be harmless for mt76x2.
> >
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > index 2be4b527477f..e624397b3d8b 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > @@ -113,7 +113,11 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
> >         ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
> >         ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
> >
> > -       dev->mt76.global_wcid.idx = 255;
> > +       /* Reserve WCID 0 for mcast - thanks to this APs WCID will go to
> > +        * entry no. 1 like it does in the vendor driver.
> > +        */
> > +       dev->mt76.wcid_mask[0] |= 1;
> > +       dev->mt76.global_wcid.idx = 0;
> >         dev->mt76.global_wcid.hw_key_idx = -1;
> >         dev->slottime = 9;
> >
> 
> Does it make any difference in AP mode?

First sta will get wcid = 1 instead of 0.

> What about using 0 instead of
> 255 for global_wcid.idx?

Patch do exactly that , it assigns:

	dev->mt76.global_wcid.idx = 0;

Thanks
Stanislaw
