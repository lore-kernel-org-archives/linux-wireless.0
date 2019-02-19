Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE181C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7B9D21773
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 15:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfBSPkt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 10:40:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33388 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1725885AbfBSPks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 10:40:48 -0500
Received: (qmail 3646 invoked by uid 2102); 19 Feb 2019 10:40:47 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 19 Feb 2019 10:40:47 -0500
Date:   Tue, 19 Feb 2019 10:40:47 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Stanislaw Gruszka <sgruszka@redhat.com>
cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
In-Reply-To: <20190219105941.GB22999@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1902191032480.1623-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 19 Feb 2019, Stanislaw Gruszka wrote:

> It would be interesting why urb->num_sgs = 0 & urb->sg cause
> the troubles. This is how usb_sg_init() submit urbs for sg_tablesize = 0
> controllers. So either are there are some requirement on urb->sg
> mapped via dma_map_page() (which mt76usb does not meet) not needed
> for urb->transfer_buffer mapped via dma_map_single() or there
> is something wrong in dwc2 with sg and this driver will not
> work with urb_sg_init() as well. I don't have hardware to investigate
> this and don't want to bother you with more patches.

urb->sg != NULL and urb->num_sgs == 0 means that the transfer buffer 
must fit into a single page, which is pointed to by the first element 
of the scatterlist.

But now that I look at the code in usb_sg_init(), it seems odd that the
!use_sg case doesn't increment sg during each loop iteration.  I don't
see how that could possibly work -- it looks like a bug!

Alan Stern

