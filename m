Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B041C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E5EC20842
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbfBMLAs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:00:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33804 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729210AbfBMLAr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 06:00:47 -0500
Received: by mail-wr1-f68.google.com with SMTP id f14so1995963wrg.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Feb 2019 03:00:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RxYwZMfOqTmyDYsxmdBZ/FKItZE1YvCMXbA+VIGz8Dk=;
        b=eZZp6tH8VbUJ+hH/vQWES3VrZliOaURX3+I9gp+jlzwYeiZwAGyLapoAadCZ57iIhi
         X6jA50P0I95Bkbej5Sx3FLq3UgI1d1oRj9M91XN7jPqLJ1wGh8FjLyKqBVXKMB70Ir6h
         SfJrwPUjyGoRDAXS6LoTdnHf75s6XE01hrQ+K/hX9cLBm43bo3h/6Wbr8piRfixOv1+F
         sFiGJTOu1blw4FJ2nJRQz1KzPLgn+vJnwkRhBTLP3k0FnV6gQDN3lSsIc3J9seEgw4pa
         cw6b+SRjhVdmG76arcaAMclJvObDWPuKjJhNLl2NAqU6Dey7dTfmkQhUUI/xYwxlqouM
         9yUg==
X-Gm-Message-State: AHQUAuZ4JcAMZWZoTg6ScMJChO+ak9GNjV99kl7JULS8fejRmT4ZvSI+
        OWMD1JrTUOZT3q+lcTSFa6tqow==
X-Google-Smtp-Source: AHgI3IbHCwylraueo/sF3/+aGFrSuWX8lxylXI4neR29264oIlf+7GhJ08/Xf0ZWYrcQUwc2zw0sSQ==
X-Received: by 2002:adf:9ecc:: with SMTP id b12mr6619980wrf.83.1550055646046;
        Wed, 13 Feb 2019 03:00:46 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t199sm10396398wmt.1.2019.02.13.03.00.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Feb 2019 03:00:45 -0800 (PST)
Date:   Wed, 13 Feb 2019 12:00:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190213110041.GI6376@localhost.localdomain>
References: <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
 <20190212150836.GA10823@localhost.localdomain>
 <20190212152559.GB23126@redhat.com>
 <20190212155001.GA12780@localhost.localdomain>
 <20190212220902.GA27836@localhost.localdomain>
 <20190213094449.GA5749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213094449.GA5749@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Feb 13, Stanislaw Gruszka wrote:
> On Tue, Feb 12, 2019 at 11:09:03PM +0100, Lorenzo Bianconi wrote:
> > > > On Tue, Feb 12, 2019 at 04:08:37PM +0100, Lorenzo Bianconi wrote:
> > > > > > > > What unnecessary operation ?
> > > > > > > 
> > > > > > > the ones in mt76u_fill_bulk_urb()
> > > > > > 
> > > > > > Your patches also add extra operations on hotpath due to urb->num_sgs and
> > > > > > dev->usb.sg_en checks.
> > > > > 
> > > > > here I guess you should use mt76u_check_sg() instead of
> > > > > udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
> > > > > the hotpath
> > > > 
> > > > It's not necessary. If udev->bus->sg_tablesize > 0 is true and rest
> > > > of mt76u_check_sg() is not, we will submit urb with urb->num_sgs = 1 to
> > > > usb host driver, what is fine. 
> > > > 
> > > > > Moreover the RFC series has been tested by multiple users and on multiple
> > > > > devices
> > > > 
> > > > I know. Perhaps you could test my patch on rpi ?
> > > 
> > > sure, I will do it later
> > 
> > I confirm that even with Stanislaw's patch the usb dongle is properly working
> > on rpi3+
> 
> Thanks for testing. Would be ok to you to post my patch against
> wireless-drivers tree and cc stable as fix for non-SG usb hosts,
> drop your set for -next and work for fix for SG issue on AMD IOMMU?

I agree that your patch works (since it does not use SG I/O :)) but
I think it is more clear (and manageable) to have two separated
routines for memory allocation.
Moreover I think that this check has to be done in the control plane instead
of the data plane, so I would like to spend some more time in order to see if it is
possible to remove some checks in the hot-path

Regards,
Lorenzo

> 
> Stanislaw
