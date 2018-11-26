Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF127C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AECE220850
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 09:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AECE220850
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbeKZUxR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Nov 2018 15:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbeKZUxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Nov 2018 15:53:17 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B783189AD0;
        Mon, 26 Nov 2018 09:59:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27644608C3;
        Mon, 26 Nov 2018 09:59:37 +0000 (UTC)
Date:   Mon, 26 Nov 2018 10:59:36 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     eduardoabinader@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
Message-ID: <20181126095935.GA5710@redhat.com>
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
 <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Mon, 26 Nov 2018 09:59:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Nov 24, 2018 at 10:25:52AM +0100, Lorenzo Bianconi wrote:
> > During removal of usb dongle, noticed many unhandled rx urb
> > below. This this patch, make it possible and early completion
> > of the rx tasklet.
> >
> > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
> > mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71

If problem here is just printing errors, I think we are ok. If problem
is some hung or infinity loop, it should be fixed.

> Hi Eduardo,
> 
> I think EPROTO is a more general error (it is not strictly related to
> device removal)
> and it could happen even during normal operation. In this case I guess we should
> reinsert the urb to usb-core.

Some (out of tree) usb host drivers returns EPROTO all the time
in some error conditions. On rt2x00 resubmitting urb resulted in
infinity loop:
https://marc.info/?t=153375128700002&r=1&w=2

Fix I proposed for that was counting EPROTO errors and 
mark device as removed if 10 of them happened in row:
https://marc.info/?l=linux-wireless&m=153441755529960&w=2

Thanks
Stanislaw 
