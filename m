Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3393C169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 07:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAFE120811
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 07:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfBKHpD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 02:45:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725931AbfBKHpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 02:45:03 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D55D47F6CE;
        Mon, 11 Feb 2019 07:45:02 +0000 (UTC)
Received: from localhost (ovpn-204-174.brq.redhat.com [10.40.204.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CBF162662;
        Mon, 11 Feb 2019 07:44:57 +0000 (UTC)
Date:   Mon, 11 Feb 2019 08:44:56 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211074455.GA6292@redhat.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
 <20190210094123.GB2913@redhat.com>
 <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmXp2a-zwPMyMFu+UCqTHP7qNRiJFopDSdZWdms7dVef4Q@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 11 Feb 2019 07:45:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Feb 10, 2019 at 11:22:25AM +0100, Lorenzo Bianconi wrote:
> > On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> > > > could you please test the following series:
> > > > https://patchwork.kernel.org/cover/10764453/
> > >
> > > yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.
> >
> > So this is either dwc2 scatter-gather problem which should be addressed in
> > this driver or mt76x0u does something wrong when configuring SG.
> >
> > Disabling SG is just workaround, which do not address actual problem.
> >
> > I think I found mt76x0u issue that could cause this USB probe error
> > (and possibly also address AMD IOMMU issue). We seems do not correctly
> > set URB transfer length smaller than sg buffer length. Attached  patch
> > should correct that.
> 
> Hi Stanislaw,
> 
> I think 'sg[0].length' is already set in mt76u_fill_rx_sg().

It is, buf->len and sg[0].length are initialized to the same value for 1
segment. But then buf->len (assigned to urb->buffer_transfer_length) change
to smaller value , but sg[0].length stay the same. What I think can be
problem for usb host driver.

> Moreover applying this patch I got the following crash (rpi-5.0.y):

Ok, so with patch probe fail instantly and trigger yet another bug(s)
on error path. You seems to address that already. 

> Moreover for mt76x0u SG is 'already' disabled since we use just one
> buffer so from performance point of view I do not see any difference
> of using a standard usb buffer.
> This patch has been tested in multiple scenarios and seems to fix
> reported issues (for usb2.0).

Ok, so passing buffer via urb->transfer_buffer works. But why urb->sg
does not work for 1 segment ?

> Are you concerned about increasing code complexity?

That's one of my concerns. Another, more important one, is that
changing to urb->transfer_buffer just hide the problems. And they will
pop up when someone will start to use SG (BTW how this can be tested
for more than one fragment, IOW how multiple fragments skb's can
be generated ? ).

And now I think the bugs can be in mt76 driver taking that problems
happened on different platforms (rpi and AMD IOMMU), i.e. we do not
correctly set urb->nub_seg or length or do some other thing wrong.

Stanislaw
