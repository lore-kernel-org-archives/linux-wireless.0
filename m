Return-Path: <SRS0=DQ7G=T4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2414C04AB6
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 14:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5A362081C
	for <linux-wireless@archiver.kernel.org>; Tue, 28 May 2019 14:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfE1ORV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 28 May 2019 10:17:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38290 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726609AbfE1ORV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 May 2019 10:17:21 -0400
Received: (qmail 1747 invoked by uid 2102); 28 May 2019 10:17:19 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 28 May 2019 10:17:19 -0400
Date:   Tue, 28 May 2019 10:17:19 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Kalle Valo <kvalo@codeaurora.org>
cc:     Christian Lamparter <chunkeey@gmail.com>,
        syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <andreyknvl@google.com>,
        <syzkaller-bugs@googlegroups.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] network: wireless: p54u: Fix race between disconnect
 and firmware loading
In-Reply-To: <8736kyvkw9.fsf@purkki.adurom.net>
Message-ID: <Pine.LNX.4.44L0.1905281014340.1564-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 28 May 2019, Kalle Valo wrote:

> The correct prefix is "p54:", but I can fix that during commit.

Oh, okay, thanks.

> > Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> > ===================================================================
> > --- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
> > +++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
> > @@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
> >  MODULE_FIRMWARE("isl3886usb");
> >  MODULE_FIRMWARE("isl3887usb");
> >  
> > +static struct usb_driver p54u_driver;
> 
> How is it safe to use static variables from a wireless driver? For
> example, what if there are two p54 usb devices on the host? How do we
> avoid a race in that case?

There is no race.  This structure is not per-device; it refers only to
the driver.  In fact, the line above is only a forward declaration --
the actual definition of p54u_driver was already in the source file.

Alan Stern

