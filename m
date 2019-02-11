Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201A0C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 11:06:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF19F20844
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 11:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfBKLGm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:06:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50222 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfBKLGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 06:06:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id x7so1123340wmj.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 03:06:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IzM61peGQkLOvyrnloG7tgA84k0Wy1IupXjsPq5LUk4=;
        b=QGaGH4kBlkT2qOXTki2cOEgTlERVOPyTMhSF3BZciA1sNd+agAhm4ZxBnj3VDgU5Pa
         lJSOmYYD+aBgbD0iq8Mmw5HLJPfkQuaDtivpQcMpDMR89tZtpotgcnpLGcySjgBL+NdZ
         XJKtM5A32P6XVEUEdF31F7zBK5EMeoVPGu6bqHgM6FoLZK2SHKkVmdINxZVwTE4ITOQX
         lo8s6pmsDjDntnu0ql2QYqMcMY/cSsXme/Sc4VXnLTRdbz0UkeL2Y57eE4tAOViY8kiA
         fnnImzuHVonv94kU7yBlgZp2uyaIkY5YIyZfXNSZILTUq2AYCI12l2pnTW7HVVsP1cLD
         QiuA==
X-Gm-Message-State: AHQUAub6nNfLq9pa3yEvZjH+gttgiD9Rwx4Zm7tXXFE79Az/R/CiSHE9
        +KoaAbL60/5vfowX59XU3QuQTA==
X-Google-Smtp-Source: AHgI3IY6364JVr/y3/MPdH4LXqxdLl3MM6K73u5NWWJ+eF2a46H2diyBfOiO4l2NV9rplYvmx69ahw==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr9252479wmh.118.1549883199686;
        Mon, 11 Feb 2019 03:06:39 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q12sm5833378wmf.2.2019.02.11.03.06.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 03:06:38 -0800 (PST)
Date:   Mon, 11 Feb 2019 12:06:36 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211110635.GD2293@localhost.localdomain>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
 <20190211074455.GA6292@redhat.com>
 <20190211100405.GD3467@localhost.localdomain>
 <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c29b08-c7d5-4d10-4be1-958ee79678f1@i2se.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Hi,
> 
> Am 11.02.19 um 11:04 schrieb Lorenzo Bianconi:
> >> On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
> >>>> On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> >>>>>> could you please test the following series:
> >>>>>> https://patchwork.kernel.org/cover/10764453/
> >>>>> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
> >>>> So this is either dwc2 scatter-gather problem which should be addressed in
> >>>> this driver or mt76x0u does something wrong when configuring SG.
> >>>>
> >>>> Disabling SG is just workaround, which do not address actual problem.
> >>>>
> >>>> I think I found mt76x0u issue that could cause this USB probe error
> >>>> (and possibly also address AMD IOMMU issue). We seems do not correctly
> >>>> set URB transfer length smaller than sg buffer length. Attached  patch
> >>>> should correct that.
> >>> Hi Stanislaw,
> >>>
> >>> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().
> >> It is, buf->len and sg[0].length are initialized to the same value for 1
> >> segment. But then buf->len (assigned to urb->buffer_transfer_length) change
> >> to smaller value , but sg[0].length stay the same. What I think can be
> >> problem for usb host driver.
> >>
> >>> Moreover applying this patch I got the following crash (rpi-5.0.y):
> >> Ok, so with patch probe fail instantly and trigger yet another bug(s)
> >> on error path. You seems to address that already. 
> >>
> >>> Moreover for mt76x0u SG is 'already' disabled since we use just one
> >>> buffer so from performance point of view I do not see any difference
> >>> of using a standard usb buffer.
> >>> This patch has been tested in multiple scenarios and seems to fix
> >>> reported issues (for usb2.0).
> >> Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
> >> does not work for 1 segment ?
> > Here it is a different issue respect to the AMD IOMMU one, dwc2 host driver
> > does not implement SG I/O so probing fails. I guess it is still useful to
> > implement a 'legacy' mode that enable mt76 on host controllers that do not implement
> > SG I/O (rpi is a very common device so it will be cool to have mt76 working on
> > it). Moreover we are not removing functionalities, user experience will remain
> > the same
> >
> i'm not sure that you understand my mail [1] with the summary of my test
> results.
> 

Yes right, I did not get it sorry :)
as indicated here https://www.raspberrypi.org/documentation/linux/kernel/building.md
I am using bcm2709_defconfig config (using it I spotted the mt76 crashes and
probe failure)

Regards,
Lorenzo

> In case of using the arm/multi_v7_defconfig (32 bit) the mt76 works like
> a charm without your sg avoid patch series, but the arm64/defconfig (64
> bit) requires the series to probe at least. So i wouldn't conclude from
> the fact that dwc2 doesn't support SG any probing issues on arm64. So we
> need to investigate which config option triggers the problem.
> 
> Stefan
> 
> [1] - https://marc.info/?l=linux-usb&m=154981675724078
> 
