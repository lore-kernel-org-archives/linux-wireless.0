Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91DAC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EEB3206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfDPIEr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfDPIEr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:04:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E375309EA78;
        Tue, 16 Apr 2019 08:04:43 +0000 (UTC)
Received: from localhost (unknown [10.40.205.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B59160501;
        Tue, 16 Apr 2019 08:04:38 +0000 (UTC)
Date:   Tue, 16 Apr 2019 10:04:37 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190416080436.GA2833@redhat.com>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
 <20190412162746.GC3156@localhost.localdomain>
 <20190413083050.GA7434@redhat.com>
 <20190413101056.GA7940@localhost.localdomain>
 <20190415115352.GA4143@redhat.com>
 <20190415150405.GA14449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415150405.GA14449@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 16 Apr 2019 08:04:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 15, 2019 at 05:04:06PM +0200, Lorenzo Bianconi wrote:
> > On Sat, Apr 13, 2019 at 12:10:59PM +0200, Lorenzo Bianconi wrote:
> > > > On Fri, Apr 12, 2019 at 06:27:48PM +0200, Lorenzo Bianconi wrote:
> > > > > > > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrote:
> > > > > > > > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order to
> > > > > > > > properly deallocate all pending skbs during suspend/resume phase
> > > > > > > 
> > > > > > > On suspend/resume tx skb's are processed after tasklet_enable()
> > > > > > > in resume callback. There is issue with device removal though
> > > > > > > (during suspend or otherwise).
> > > > > > 
> > > > > > Hi Stanislaw,
> > > > > > 
> > > > > > I guess the right moment to deallocate the skbs is during suspend since resume
> > > > > > can happen in very far future
> > > > 
> > > > Yes, it's better to free on suspend, but in practice does not really matter since
> > > > system is disabled till resume.
> > > > 
> > > > > > > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > > ---
> > > > > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > > > > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > > > 
> > > > > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > index a3acc070063a..575207133775 100644
> > > > > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > > > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
> > > > > > > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > > > > > > >  {
> > > > > > > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > > > > > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > > -
> > > > > > > >  	mt76u_stop_rx(dev);
> > > > > > > > +
> > > > > > > >  	mt76u_stop_tx(dev);
> > > > > > > > +	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > > > 
> > > > > > > If tasklet is scheduled and we disable it and never enable, we end up
> > > > > > > with infinite loop in tasklet_action_common(). This patch make the
> > > > > > > problem less reproducible since tasklet_disable() is moved after
> > > > > > > usb_kill_urb() -> tasklet_schedule(), but it is still possible.
> > > > > > 
> > > > > > I can see the point here. Maybe we can just run tasklet_kill instead of
> > > > > > tasklet_disable here (at least for tx one)
> > > > 
> > > > I think you have right as tasklet_kill() will wait for scheduled tasklet .
> > > > Originally in my patch (see below) I used wait_event as I thought
> > > > tasklet_kill() may prevent scheduled tasklet to be executed (hence cause
> > > > leak) but that seems to be not true.
> > > 
> > > I agree with rx side (good catch!!), but on tx one I guess usb_kill_urb()
> > > is already waiting for tx pending so we just need to use tasklet_kill
> > > at the end of mt76u_stop_queues, in this way we will free pending skbs during
> > > suspend
> > 
> > I looked more into that and there are some issues with this approach.
> > tx_tasklet do mt76_txq_schedule() which can queue tx frames. Also we
> > do not free skb's that require status check and dev->usb.stat_work 
> > is already (correctly) stopped on mac80211.stop. 
> 
> right
> 
> > 
> > I'll use wait_event(dev->tx_wait) on mac80211 stop to handle those
> > issues correctly.
> 
> ack
> 
> > 
> > Stanislaw
> 
> during device removal I guess we should also flush skbs in status queue, doing
> something like (after commit 0b5f71304cd9 (mt76: introduce mt76_free_device
> routine))
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> index 1ef00e971cfa..d4d1eb003148 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -299,7 +299,7 @@ static void mt76x0_disconnect(struct usb_interface *usb_intf)
>  	if (!initalized)
>  		return;
>  
> -	ieee80211_unregister_hw(dev->mt76.hw);
> +	mt76_unregister_device(&dev->mt76);

mt76_unregister_device() free mmio dma. I've added mt76_tx_status_check()
on mt76u_stop_tx() routine instead.

Stanislaw

