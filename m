Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957DCC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EC5120578
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 17:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405788AbfAPRQ4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 12:16:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39843 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfAPRQ4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 12:16:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id y8so2812562wmi.4
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jan 2019 09:16:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/DPrin2n9npDvTLnPwGMa/Zhaj7eSYcvloAcaxI3y/E=;
        b=ELrIzg9GOhc0E71uzBprAIey2BVPiR+K0HhGNRtIacV7RHJTKzsIBQQHUehmKQfoOZ
         9rgUiUelWF2iYgw8G9H+JnCBxX0eiZaUGeghUIJCwqFZzF7k4j1PzNtICW6v5wO0I7r3
         3yeY5tFac053EiEYw8Eqh8ZqLlX8kalDV6MYX9/FouCeUBooWtG16/s11R2LD88X1F2n
         cQqF9vTO0B4ANr2JmikiuxjQgvVTb2vZdlKN27Mr/P+zgBvaJzMuc/whtBBBIZuQCiBZ
         5W2swfen/TrP8SO6uFHdInh01zybqD164dU3id+Lc0652ugbcI1B+VgD28225VEyxBDB
         09yQ==
X-Gm-Message-State: AJcUukeeT7cP6rcXbRzPHTyBqqWF1C4XUJDk5Q5whcYjMbr3+Oc023nP
        cFjjJGLgvO1fjjgLIOfqLQ30Fw==
X-Google-Smtp-Source: ALg8bN6sZ8gqiUPG+N/RIsX79mnJ/SxZkeXBci70h6HlPcpCe0HVaIljjlv2ZQL7/zV6gRY6XjrAmw==
X-Received: by 2002:a7b:c951:: with SMTP id i17mr8850563wml.70.1547659014555;
        Wed, 16 Jan 2019 09:16:54 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x15sm82412129wrs.27.2019.01.16.09.16.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 09:16:53 -0800 (PST)
Date:   Wed, 16 Jan 2019 18:16:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190116171650.GD2454@localhost.localdomain>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
 <20190115153546.GA8387@redhat.com>
 <20190115154746.GA30564@localhost.localdomain>
 <20190116111946.GB5234@redhat.com>
 <20190116114432.GA2454@localhost.localdomain>
 <20190116122145.GA7472@redhat.com>
 <20190116134045.GB2454@localhost.localdomain>
 <20190116143905.GA18221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116143905.GA18221@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Wed, Jan 16, 2019 at 02:40:46PM +0100, Lorenzo Bianconi wrote:
> > On Jan 16, Stanislaw Gruszka wrote:
> > > On Wed, Jan 16, 2019 at 12:44:33PM +0100, Lorenzo Bianconi wrote:
> > > > > On Tue, Jan 15, 2019 at 04:47:47PM +0100, Lorenzo Bianconi wrote:
> > > > > > Hi Stanislaw,
> > > > > 
> > > > > Hi :-)
> > > > > 
> > > > > > > Not sure what is the problem , but this patch set look like a workaround
> > > > > > > not fix. If this an issue with IOMMU and sg, seems there is something wrong
> > > > > > > in sg page mappings eigher on mt76 dirver or IOMMU driver.
> > > > > > 
> > > > > > The main point here I guess is we do not need sg if fragment number is one (e.g
> > > > > > usb2.0). Moreover this can fix IOMMU reported issues.
> > > > > 
> > > > > So there if diffrence for USB host driver when we have one usb->sg
> > > > > sengment and if we just pass the buffer via urb->transfer_buf . I think
> > > > > most USB host drivers behave the same in such cases. For what USB
> > > > > hardware/driver this is needed ? Perhaps simpler fix could be done
> > > > > in USB host driver?
> > > > 
> > > > According to https://github.com/torvalds/linux/blob/master/drivers/usb/core/hcd.c#L1557
> > > > single sg urb and urb with a configured transfer_buf are managed in a different way.
> > > 
> > > But this should not make any difference for underlying low level USB
> > > host driver, since we map 1 buffer of the same size, just by using
> > > different routines for that.
> > 
> > probably amd iommu has some constraints on sg buffer layout respect to intel
> > one, not sure
> > 
> > > 
> > > > Please not I have not received any confirm that this series fixes the reported issue
> > > > yet :)
> > > 
> > > What is reported issue ?
> > 
> > https://marc.info/?l=linux-wireless&m=154716096506037&w=2
> 
> So, this if for AMD IOMMU issue as I thought initally. For the moment I
> thought you are trying to fix some diffrent problem with some 
> non-standart usb host controler.

Why not standard? Most of net usb drivers do not use sg :)

> 
> I still think not using sg is just workaround for the problem not worth
> to do, since we have already workaround in form of disabling IOMMU.
> Right fix will be fixing AMD IOMMU driver or fix sg usage in mt76-usb
> if it does something wrong.

I agree with you that this is not strictly a fix for IOMMU issue but I think
we could avoid using sg when we are working just with linear skbs.
But first I guess we need some feedbacks from users

Regards,
Lorenzo

> 
> Regards
> Stanislaw 
