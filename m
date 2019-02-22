Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871DDC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 11:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD8A2075C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 11:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfBVLyy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 06:54:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfBVLyy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 06:54:54 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4E043001D3A;
        Fri, 22 Feb 2019 11:54:53 +0000 (UTC)
Received: from localhost (ovpn-204-60.brq.redhat.com [10.40.204.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16F6B5D706;
        Fri, 22 Feb 2019 11:54:48 +0000 (UTC)
Date:   Fri, 22 Feb 2019 12:54:47 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mt76usb: use synchronous msg for mcu command
 responses
Message-ID: <20190222115446.GA5720@redhat.com>
References: <1550679320-14343-1-git-send-email-sgruszka@redhat.com>
 <1550679320-14343-2-git-send-email-sgruszka@redhat.com>
 <20190222095318.GA14269@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222095318.GA14269@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 22 Feb 2019 11:54:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 22, 2019 at 10:53:19AM +0100, Lorenzo Bianconi wrote:
> > Use usb_bulk_msg for reading MCU command responses. This simplify code
> > a lot.
> > 
> > Together with 97a3005759c ("mt76usb: allow mt76u_bulk_msg be used
> > for reads") it also fix possible problems with rx data buffers
> > not being aligned and contained within single page. After doing
> > page_frag_alloc(1024) consecutive page_frag_alloc(PAGE_SIZE) will
> > alloc PAGE_SIZE buffer at PAGE_SIZE - 1024 offset.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt76/mt76.h          |  3 +-
> >  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 11 --------
> >  .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 32 +++++++---------------
> >  drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    | 11 --------
> >  drivers/net/wireless/mediatek/mt76/usb.c           |  1 -
> >  drivers/net/wireless/mediatek/mt76/usb_mcu.c       | 31 +++------------------
> >  6 files changed, 15 insertions(+), 74 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> > index 6092646014c4..c9b5eb9b0582 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> > @@ -384,8 +384,7 @@ struct mt76_usb {
> >  
> >  	struct mt76u_mcu {
> >  		struct mutex mutex;
> > -		struct completion cmpl;
> 
> Hi Stanislaw,
> 
> I was reviewing this approach and I guess it is a little bit racey since now we
> are not sure that when the device is removed or suspended the pending mcu commands
> are terminated and we do not have any api to stop usb transactions.
> Are we sure when we access mt76x02_dev/mt76_dev structure it has not been
> already removed?
> Maybe we need to maintain the completion in mt76u_mcu and use it to wait the mcu
> commands are terminated.

I don't think so. On suspend we do mt76xxu_mac_stop() which access registers
using mcu commands, all should be synchronized by mcu->mutex . All other
process that could use mcu command should be already stopped. Actually suspend
can be simplified.

Device remove should be properly handled by -ENODEV error returned by
usb_bulk_msg.

Stanislaw
