Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F0BC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B4F52098A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B4F52098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbeJCRUP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:20:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38053 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbeJCRUP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:20:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id 193-v6so5070933wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=he8AkbbXUlEcbyWLW1CyseX+QRRknaub24/CAs7lU3s=;
        b=LBXZhIzIeh9sSaFnvjhhExCUwGRi3q/csj6u9pmloRyQuWQDwwpxQkK/sremOXbTE3
         B6GQBCz2giVPYQoZX2H9YIZuabtnXnfkAXW2HdRgh0gOSKxivqy1K2yE6M/wFm2S14dm
         QZxt2t5apq6/Z7T1faZHMA6nlO7PUbtVeIvl8LNnq1M9aP0tgQ5TXN6+U2VT6k9fHIGy
         kqMoHhS+SUCpZg/7OesHSL+Op8GHdCrmMvbllaod4C0pv7lrVJ3nfmLpEKkvn7ppO1ui
         oBPZdsThAJPx47wB8pHUx6xXcVzuY+yK178ARskwJhWy3ZBR9AstcZqqwwxmHqhHj2L2
         sexg==
X-Gm-Message-State: ABuFfoiMBGF7pBwSMYs5vVNEcM+NDtbSAJj5RL/LhqqnDNLGgNCjQBPM
        RGLtmJC37TdVEbwiGMTYGYI1KA==
X-Google-Smtp-Source: ACcGV62ctuBQHZFSGgzbBjC781TyNOD5bVeW8EpJK+B5glXeK3fjZcW7HgQTPNdVAUHtKCimJ2KB1w==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26-v6mr1031374wmh.61.1538562747397;
        Wed, 03 Oct 2018 03:32:27 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r16-v6sm1310863wrv.21.2018.10.03.03.32.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:32:27 -0700 (PDT)
Date:   Wed, 3 Oct 2018 12:32:24 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: new mt76 usb crashes on device removal
Message-ID: <20181003103224.GE27279@localhost.localdomain>
References: <20181003082309.GB2229@redhat.com>
 <20181003091536.GB27279@localhost.localdomain>
 <20181003102927.GA2250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181003102927.GA2250@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Oct 03, Stanislaw Gruszka wrote:
> On Wed, Oct 03, 2018 at 11:15:37AM +0200, Lorenzo Bianconi wrote:
> > > After
> > > 
> > > b11e19694dc9 "mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature"
> > > 
> > > I have new crashs when remove mt76x0u and mt76x2u devices. 
> > > I can not provide calltrace because some other warning/traces
> > > show up instantly after the problem happen and mask prints
> > > for initall problem. Then the machine hungs.
> > > 
> > > Anyway bisection blame b11e19694dc9 commit and I confirm that problem
> > > not happen before this commit. I also applied the fix with I just
> > > posted, so this is diffrent issue.
> > 
> > Hi Stanislaw,
> > 
> > I do not know if it is related or not, but could you please try following patch:
> > 
> > Regards,
> > Lorenzo
> > 
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
> > @@ -179,11 +179,11 @@ static int mt76x0u_register_device(struct mt76x0_dev *dev)
> >  	struct ieee80211_hw *hw = dev->mt76.hw;
> >  	int err;
> >  
> > -	err = mt76u_mcu_init_rx(&dev->mt76);
> > +	err = mt76u_alloc_queues(&dev->mt76);
> >  	if (err < 0)
> >  		return err;
> >  
> > -	err = mt76u_alloc_queues(&dev->mt76);
> > +	err = mt76u_mcu_init_rx(&dev->mt76);
> >  	if (err < 0)
> >  		return err;
> 
> It still crashes. You can not reproduce the problem ?
> It's 100% reproducible for me, when I unplug mt76x0u or mt76x2 device.

I think I get it, I will send you a series to test. Thanks

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
