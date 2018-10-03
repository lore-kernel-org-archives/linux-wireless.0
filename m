Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9562C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8438D2089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8438D2089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbeJCRRV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbeJCRRV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:17:21 -0400
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C909C01BD3F;
        Wed,  3 Oct 2018 10:29:35 +0000 (UTC)
Received: from localhost (unknown [10.40.205.0])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4BE93001741;
        Wed,  3 Oct 2018 10:29:29 +0000 (UTC)
Date:   Wed, 3 Oct 2018 12:29:28 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: new mt76 usb crashes on device removal
Message-ID: <20181003102927.GA2250@redhat.com>
References: <20181003082309.GB2229@redhat.com>
 <20181003091536.GB27279@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003091536.GB27279@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.24
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 03 Oct 2018 10:29:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 11:15:37AM +0200, Lorenzo Bianconi wrote:
> > After
> > 
> > b11e19694dc9 "mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature"
> > 
> > I have new crashs when remove mt76x0u and mt76x2u devices. 
> > I can not provide calltrace because some other warning/traces
> > show up instantly after the problem happen and mask prints
> > for initall problem. Then the machine hungs.
> > 
> > Anyway bisection blame b11e19694dc9 commit and I confirm that problem
> > not happen before this commit. I also applied the fix with I just
> > posted, so this is diffrent issue.
> 
> Hi Stanislaw,
> 
> I do not know if it is related or not, but could you please try following patch:
> 
> Regards,
> Lorenzo
> 
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> @@ -179,11 +179,11 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
>  	struct ieee80211_hw *hw = dev->mt76.hw;
>  	int err;
>  
> -	err = mt76u_mcu_init_rx(&dev->mt76);
> +	err = mt76u_alloc_queues(&dev->mt76);
>  	if (err < 0)
>  		return err;
>  
> -	err = mt76u_alloc_queues(&dev->mt76);
> +	err = mt76u_mcu_init_rx(&dev->mt76);
>  	if (err < 0)
>  		return err;

It still crashes. You can not reproduce the problem ?
It's 100% reproducible for me, when I unplug mt76x0u or mt76x2 device.

Thanks
Stanislaw
