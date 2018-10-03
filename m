Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C07C64EB8
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36CB42082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 14:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36CB42082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbeJCU5p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 16:57:45 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50339 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbeJCU5o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 16:57:44 -0400
Received: by mail-wm1-f46.google.com with SMTP id s12-v6so5879704wmc.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 07:09:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KilH1s/q3smFxT6UZjL7vtXNaEMAGMBeVnxgdAM3Xuw=;
        b=g8Ihpjy/rSwdydMEbeMMyXtr43McBSuzo5qzN5mg6LCNQjtsLCcdZPL4HufNqPKi90
         alyATB1dmEHtNEuGq/DwxpXNCwOBEGhfBhK3T9ZDlJ4CkYazb/qohtN1d4kW/DMLN7re
         851H9Ql4+OpTjJrAaMG8cas+Y9lxuM0JetnnuNmkh6cFp1stcro7MUcZCp+K2gwLSk+n
         zudYUyISIQ7wu+niH30myJNArIvpl8MNmFyK3puO8oAuz5d6FsAE2nGL2Caq+JFTDjVO
         SUvDlqdm6nLAjt2LipWEe4u1zjhx/S19rM6ALXh6jV34DZVwBa1SWGbMRHxEofPSMWNS
         Z/xA==
X-Gm-Message-State: ABuFfoi9JP98aob4uMRNgPUNW1RgKHlQEbemqc+SwG1/kQQoyu2kwgUs
        tBNYCYYUI+hmedPAEMOe8vYwlA==
X-Google-Smtp-Source: ACcGV60amsHqmwvEP2TWUBDCGIy+yZAJu9RiLBEl61GkfVpJWEcDU9yUAFjqp17vms18gz63nuUzWg==
X-Received: by 2002:a1c:6355:: with SMTP id x82-v6mr1653405wmb.145.1538575749897;
        Wed, 03 Oct 2018 07:09:09 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 204-v6sm2130471wmh.25.2018.10.03.07.09.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 07:09:08 -0700 (PDT)
Date:   Wed, 3 Oct 2018 16:09:06 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: new mt76 usb crashes on device removal
Message-ID: <20181003140905.GF27279@localhost.localdomain>
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

Hi Stanislaw,

any news about the latest patchset I sent to fix that issue?

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
