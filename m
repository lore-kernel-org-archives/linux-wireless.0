Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47ECBC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1ECFB2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfBLNvG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:51:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729889AbfBLNvF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:51:05 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91BA6C0BFBCC;
        Tue, 12 Feb 2019 13:51:05 +0000 (UTC)
Received: from localhost (ovpn-204-125.brq.redhat.com [10.40.204.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1494B18976;
        Tue, 12 Feb 2019 13:51:01 +0000 (UTC)
Date:   Tue, 12 Feb 2019 14:51:00 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     lorenzo.bianconi@redhat.com
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190212135100.GA15292@redhat.com>
References: <cover.1549977282.git.lorenzo@kernel.org>
 <20190212134550.GA12256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190212134550.GA12256@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 12 Feb 2019 13:51:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(repost with corrected Lorenzo email)

On Tue, Feb 12, 2019 at 02:45:50PM +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 12, 2019 at 02:24:47PM +0100, LorenzoBianconilorenzo@kernel.org wrote:
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > 
> > Use linear fragment and not a single usb scatter-gather buffer in mt76u
> > {tx,rx} datapath if the usb controller has sg data length constraints.
> > Moreover add disable_usb_sg module parameter in order to explicitly
> > disable scatter-gather. SG I/O is not supported by all host drivers and
> > some users have reported sg issues on AMD IOMMU.
> 
> Again. This is not right approach. SG issues should be fixed
> not workarounded.
> 
> > This series has been tested on AMD IOMMU cpus/motherboards and on rpi3+
> 
> > - rebased on top of 'fix multiple issues in mt76u error path'
> >   https://patchwork.kernel.org/cover/10804919/
> > 
> > Lorenzo Bianconi (4):
> >   mt76: usb: move mt76u_check_sg in usb.c
> >   mt76: usb: do not use sg buffers for mcu messages
> >   mt76: usb: use a linear buffer for tx/rx datapath if sg is not
> >     supported
> >   mt76: usb: introduce disable_usb_sg parameter
> > 
> >  drivers/net/wireless/mediatek/mt76/mt76.h     |  14 +-
> >  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +-
> >  .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |   3 +-
> >  .../wireless/mediatek/mt76/mt76x2/usb_init.c  |   2 +-
> >  drivers/net/wireless/mediatek/mt76/usb.c      | 133 +++++++++++++-----
> >  drivers/net/wireless/mediatek/mt76/usb_mcu.c  |   5 +-
> >  6 files changed, 105 insertions(+), 54 deletions(-)
> 
> I really think my approach is simpler. Diffstat from my proposed patch is:
> 
>   drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
>   drivers/net/wireless/mediatek/mt76/usb.c  | 55 ++++++++++++++---------
>   2 files changed, 36 insertions(+), 20 deletions(-)
> 
> Also this fix bug(s), presumably regression for mt76x0, should be
> backported.
> 
> Stanislaw
> 
