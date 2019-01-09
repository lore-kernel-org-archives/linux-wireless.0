Return-Path: <SRS0=9BuQ=PR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F32C43387
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 11:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BCB021738
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Jan 2019 11:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730798AbfAILdX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 06:33:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39760 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbfAILdX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 06:33:23 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92B7B356E7;
        Wed,  9 Jan 2019 11:33:22 +0000 (UTC)
Received: from localhost (unknown [10.40.205.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6D03600C4;
        Wed,  9 Jan 2019 11:33:21 +0000 (UTC)
Date:   Wed, 9 Jan 2019 12:33:20 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Jeroen Roovers <jer@airfi.aero>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
Message-ID: <20190109113320.GA15658@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
 <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com>
 <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 09 Jan 2019 11:33:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 09, 2019 at 07:17:59AM +0100, Jeroen Roovers wrote:
>      Hi Tom,
> 
> On Tue, 8 Jan 2019 at 12:04, Tom Psyborg <pozega.tomislav@gmail.com> wrote:
> > > rt2x00usb_vendor_request: Error - Vendor Request X failed for offset X
> > > with error -110
> > > [many of these, system is slowly locking up]
> > >
> > > So the only clue that I had was that perhaps rt2x00usb_vendor_request
> > > wasn't catching the correct return value.
> >
> > Hi
> >
> > error message vendor request failed - do you get it on a real hardware
> > or in virtualized environment?
> 
> I only run these on bare metal. What I assume so far is that when
> rt2x00usb_vendor_request starts failing like this, the MCU has failed.
> Power cycling the system helps but is undesirable, and sometimes so
> does a forced removal of rt2800usb, a short recovery period (cooling
> down, reloading the firmware?) and then loading the module again.
> 
> But the problem I am looking to solve is not a hardware problem, it is
> recovering gracefully from a failure in the RT5592, so I have been
> looking intently at rt2x00usb_vendor_request because that's the
> function that complains loudly and kills the entire kernel when the
> RT5592 sees this failure.

So would be below patch (on top of this set) be a solution for at 
least to not kill the kernel. Or we looking for something better
i.e. watchdog ?

Regards
Stanislaw

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 60b8bccab83d..ee5bd0efd2c7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -36,7 +36,7 @@ static bool rt2x00usb_check_usb_error(struct rt2x00_dev *rt2x00dev, int status)
 	if (status == -ENODEV || status == -ENOENT)
 		return true;
 	
-	if (status == -EPROTO)
+	if (status == -EPROTO || status == -ETIMEDOUT)
 		rt2x00dev->num_proto_errs++;
 	else
 		rt2x00dev->num_proto_errs = 0;

