Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEC2C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52CF920842
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfBLPuH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:50:07 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54878 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728347AbfBLPuH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:50:07 -0500
Received: by mail-wm1-f65.google.com with SMTP id a62so3500057wmh.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 07:50:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IP69Wk7eKto4mwCIQtSsvuI25dMkz5RzYKhiNUtIgLI=;
        b=KIeJeT1opvYwFRanmzvr0Agv+H6D8XmH8jbAvQIGlOMuS771m70N1L3tCbbvctaSmF
         ZSvgC0lwyM0w+pcSVoolwyE0w2N9VLNsp1q57suv3VKXQqieDalhFPQUIrQ/NEdeeJm0
         b+3JA2hn2SCbe8CMwQFyif7WyOKbcJyegDZ1TVyxkp5scJFTuSHKNIVEygfqtEFACKwu
         s8A/C0gfpvRGWlaoyx1WiMhbix8/H3JgDDV1V6acaR1bjarudUsBURY1IDgt2W63FYNB
         4af2afPYWCtJtrYoybVG/PdrDpiWp6+thjXBBJAOfostakAYk9ZF2yEXek7gHYNnweuF
         dqWw==
X-Gm-Message-State: AHQUAuY9QUX49oOD9/kYTNKWQ7pb6lw6WWyy0xMJHt9GLtgfiLQjEwhP
        eHUPl8v8pPiHVLbHdk1MBXwNQQ==
X-Google-Smtp-Source: AHgI3IasSRlj8+2FQp1arX8BJuvEspb/k9dhKOeUHnaCZNZqPLiIVzJn5hyNH6axVmSCSo61QxOTLg==
X-Received: by 2002:a1c:f916:: with SMTP id x22mr3546438wmh.87.1549986605258;
        Tue, 12 Feb 2019 07:50:05 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v6sm29039172wrd.88.2019.02.12.07.50.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Feb 2019 07:50:04 -0800 (PST)
Date:   Tue, 12 Feb 2019 16:50:02 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lorenzo@kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212155001.GA12780@localhost.localdomain>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
 <20190212135100.GA15292@redhat.com>
 <CAJ0CqmVhH61P1V1fmhicPXwA7vHjv+Hh7h2DYbci1uDRJCyENA@mail.gmail.com>
 <20190212141725.GD12906@redhat.com>
 <20190212142528.GB24197@localhost.localdomain>
 <20190212145424.GE12906@redhat.com>
 <20190212150836.GA10823@localhost.localdomain>
 <20190212152559.GB23126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212152559.GB23126@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Tue, Feb 12, 2019 at 04:08:37PM +0100, Lorenzo Bianconi wrote:
> > > > > What unnecessary operation ?
> > > > 
> > > > the ones in mt76u_fill_bulk_urb()
> > > 
> > > Your patches also add extra operations on hotpath due to urb->num_sgs and
> > > dev->usb.sg_en checks.
> > 
> > here I guess you should use mt76u_check_sg() instead of
> > udev->bus->sg_tablesize > 0 so I think you need to precompute it since it is in
> > the hotpath
> 
> It's not necessary. If udev->bus->sg_tablesize > 0 is true and rest
> of mt76u_check_sg() is not, we will submit urb with urb->num_sgs = 1 to
> usb host driver, what is fine. 
> 
> > Moreover the RFC series has been tested by multiple users and on multiple
> > devices
> 
> I know. Perhaps you could test my patch on rpi ?

sure, I will do it later

Regards,
Lorenzo

> 
> Stanislaw 
> 
> 
