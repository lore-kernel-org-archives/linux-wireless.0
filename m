Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15C2C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9621E20850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfDLOyx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 10:54:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbfDLOyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 10:54:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED932C0842CD;
        Fri, 12 Apr 2019 14:54:47 +0000 (UTC)
Received: from localhost (ovpn-204-29.brq.redhat.com [10.40.204.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CF8019CA0;
        Fri, 12 Apr 2019 14:54:44 +0000 (UTC)
Date:   Fri, 12 Apr 2019 16:54:43 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190412145442.GA2539@redhat.com>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 12 Apr 2019 14:54:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrote:
> Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order to
> properly deallocate all pending skbs during suspend/resume phase

On suspend/resume tx skb's are processed after tasklet_enable()
in resume callback. There is issue with device removal though
(during suspend or otherwise).

> Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
> index a3acc070063a..575207133775 100644
> --- a/drivers/net/wireless/mediatek/mt76/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
>  void mt76u_stop_queues(struct mt76_dev *dev)
>  {
>  	tasklet_disable(&dev->usb.rx_tasklet);
> -	tasklet_disable(&dev->usb.tx_tasklet);
> -
>  	mt76u_stop_rx(dev);
> +
>  	mt76u_stop_tx(dev);
> +	tasklet_disable(&dev->usb.tx_tasklet);

If tasklet is scheduled and we disable it and never enable, we end up
with infinite loop in tasklet_action_common(). This patch make the
problem less reproducible since tasklet_disable() is moved after
usb_kill_urb() -> tasklet_schedule(), but it is still possible.

I comprehansive have fix for that, but giving it more testing.
Please drop this patch.

Stanislaw
