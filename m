Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A86C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D07720836
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 15:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730514AbfBLP1O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 10:27:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55932 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728273AbfBLP1O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 10:27:14 -0500
Received: (qmail 1624 invoked by uid 2102); 12 Feb 2019 10:27:12 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 12 Feb 2019 10:27:12 -0500
Date:   Tue, 12 Feb 2019 10:27:12 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
In-Reply-To: <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1902121023540.1435-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 12 Feb 2019, Lorenzo Bianconi wrote:

> Hi Alan,
> 
> I actually used usb_sg_init()/usb_sg_wait() as reference to implement
> mt76u {tx/rx} datapath, but I will double-check.
> I guess we should even consider if there are other usb host drivers
> that do not implement SG I/O and it is worth to support.
> I am wondering if the right approach is to add SG to the controller
> one by one or have legacy I/O in mt76 (not sure what is the 'best'
> approach)
> What do you think?

If mt76u can use usb_sg_init/usb_sg_wait, that would be the simplest.  
It would allow you to remove a lot of code from the driver.  And then
adding SG support to the controller drivers one by one would be fine.

However, if that isn't feasible then you have to keep legacy I/O in 
mt76u as long as any controller drivers don't support SG.

Alan Stern

