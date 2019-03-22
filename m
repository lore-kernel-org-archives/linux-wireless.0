Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFA0C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CD25218E2
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 12:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbfCVMpz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:45:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388025AbfCVMpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 08:45:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1248D3082E8F;
        Fri, 22 Mar 2019 12:45:53 +0000 (UTC)
Received: from localhost (ovpn-204-52.brq.redhat.com [10.40.204.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D9921754D;
        Fri, 22 Mar 2019 12:45:50 +0000 (UTC)
Date:   Fri, 22 Mar 2019 13:45:49 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 03/12] mt76usb: change mt76u_fill_rx_sg arguments
Message-ID: <20190322124548.GA11032@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
 <20190321152537.19105-4-sgruszka@redhat.com>
 <20190322101038.GA22889@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190322101038.GA22889@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 22 Mar 2019 12:45:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 22, 2019 at 11:10:40AM +0100, Lorenzo Bianconi wrote:
> > We do not need to pass len and sglen to the function.
> > Additionally pass gfp to control allocation context.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/usb.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> > index 3f21599d52de..56e7a2ca8930 100644
> > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > @@ -285,11 +285,13 @@ mt76u_set_endpoints(struct usb_interface *intf,
> >  }
> >  
> >  static int
> > -mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
> > -		 int nsgs, int len, int sglen)
> > +mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
> > +		 gfp_t gfp)
> >  {
> >  	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
> > +	int sglen = SKB_WITH_OVERHEAD(q->buf_size);
> >  	struct urb *urb = buf->urb;
> > +
> 
> please drop newline here

Not sure where it came from, but is already removed on patch 8.

Stanislaw
