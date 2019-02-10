Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68580C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 09:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C26B2084D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 09:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfBJJ3u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 04:29:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfBJJ3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 04:29:50 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCB591E2E3;
        Sun, 10 Feb 2019 09:29:49 +0000 (UTC)
Received: from localhost (ovpn-204-24.brq.redhat.com [10.40.204.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C608D5DEE1;
        Sun, 10 Feb 2019 09:29:45 +0000 (UTC)
Date:   Sun, 10 Feb 2019 10:29:44 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190210092943.GA2913@redhat.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sun, 10 Feb 2019 09:29:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Feb 09, 2019 at 07:46:37PM +0100, Lorenzo Bianconi wrote:
> > as already reported here [1], that there are probing issues of mt76 using TP-Link Archer T2UH (wifi USB dongle) on Raspberry Pi 3 B+.
> >
> > I retested it with recent linux-next 20190208 (aarch64 defconfig + enabling mt76 driver) and got the following output after plugin the wifi dongle:
> >
> > [   29.778524] usb 1-1.3: new high-speed USB device number 6 using dwc2
> > [   31.794581] usb 1-1.3: reset high-speed USB device number 6 using dwc2
> > [   31.919916] mt76x0u 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
> > [   32.304412] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   32.325724] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   32.346866] dwc2 3f980000.usb: dwc2_update_urb_state(): trimming xfer length
> > [   33.410559] mt76x0u 1-1.3:1.0: firmware upload timed out
> > [   33.435458] mt76x0u: probe of 1-1.3:1.0 failed with error -110
> > [   33.454829] usbcore: registered new interface driver mt76x0u
> >
> > I took the firmware files from here [2].
> >
> > Btw there is another issue, if i disconnect the wifi dongle during probe i'm getting a endless flood of the following output:
> >
> > mt76x0u 1.1.3:1.0: rx urb failed: -71
> >
> > Any chance to narrow down these issues?
> 
> Hi Stefan,
> 
> could you please test the following series:
> https://patchwork.kernel.org/cover/10764453/
> Applying this series I am able to connect to my home AP using an Asus
> USB-AC51 (mt76x0u) connected to a Raspberry Pi 3 B+.
> I am running rpi-5.0.y branch of https://github.com/raspberrypi/linux.git

How the patch series fixed the issue since it was reported before that 
it does not work on 4.19.x which do not use scatter gatter I/O ?

Or it is regression ? 4.19.x driver works with rasperrypi/linux but -next
does not ?

Stanislaw
