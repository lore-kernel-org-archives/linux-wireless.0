Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B58C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186A52063F
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wp.pl header.i=@wp.pl header.b="UFErPQk6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfCFSte (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:49:34 -0500
Received: from mx4.wp.pl ([212.77.101.12]:52474 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbfCFSte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 13:49:34 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2019 13:49:32 EST
Received: (wp-smtpd smtp.wp.pl 30917 invoked from network); 6 Mar 2019 19:42:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1551897769; bh=01K3iPF7ZnmWlPw0+YtzhkwEFw7CVSE0nCZP58W9Fj0=;
          h=From:To:Cc:Subject;
          b=UFErPQk6w+ocgREhxxmm0rwY3N3jQEJyLXR8vECPC3DN2zz1sVfFtWbRw+JOlTtu2
           tHAhptnM9WZ5THGLYyWHS+6Xk7vLaBQ13OeFhVNgID4+EjeK4SFMUUpXtQEO+6+H6B
           s6fN60y4VJWvWb/1P9HuFhNRsxgcinwBuWKcG/3I=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.hsd1.ca.comcast.net) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <sgruszka@redhat.com>; 6 Mar 2019 19:42:49 +0100
Date:   Wed, 6 Mar 2019 10:42:40 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: mediatek: duplicate usb devices
Message-ID: <20190306104240.64a26c51@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190306110329.GD12946@redhat.com>
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
        <20190306075053.GA12946@redhat.com>
        <CAA2SeN+V_ug2JPNQ++ZTj4hYh-YDOkNhiyP_dsaYnpddXDb6PA@mail.gmail.com>
        <20190306110329.GD12946@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: dcec0f5c05197673aaa1892a2f9bd591
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gcNk]                               
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 6 Mar 2019 12:03:30 +0100, Stanislaw Gruszka wrote:
> On Wed, Mar 06, 2019 at 11:09:12AM +0100, Lorenzo Bianconi wrote:
> > >
> > > On Tue, Mar 05, 2019 at 07:33:51PM +0100, Xose Vazquez Perez wrote:  
> > > > There a three duplicate devices at:
> > > >
> > > > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
> > > > mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Aukey USB-AC1200 */  
> > > One duplicated entry should be removed.
> > >  
> > > > mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> > > > mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },  
> > 
> > IIUC this is not in the mt7601u driver available on mtk website.  
> 
> The same apply to mt7610u. Vendor driver have only IDs for some
> reference devices. Both mt7601u and mt7610u drivers do not include
> 0x7610.
> 
> For mt76x0u ids were provided by Hans 
> https://lore.kernel.org/linux-wireless/alpine.LNX.2.00.1804092042320.8369@T420s/
> I'm not sure where they came from.

The ones in mt7601u came from Xose, the GitHub repo has fuller history:

https://github.com/kuba-moo/mt7601u/commit/5e6b565301d9882aab9af46b396a5cf489db6c78

I don't really mind which one stays :)
