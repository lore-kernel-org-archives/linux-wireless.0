Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20921 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912AbaE1FFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 01:05:11 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 May 2014 22:04:51 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5E4CC@SC-VEXCH1.marvell.com> (sfid-20140528_070515_569884_A0D1294C)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
 <20140528020128.GG4151@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E4B3@SC-VEXCH1.marvell.com>
 <20140528044945.GI4151@us.netrek.org>
In-Reply-To: <20140528044945.GI4151@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > We set gap to 0xff, which we think is a special value that means the
> > > device will wait for the host to acknowledge before sending data to
> > > the host.
> >
> > Yes, gap=0xff should be used. Actually I also have the patch to set
> > gap to 0xff queued in my local tree. I will send it upstream.
> 
> Thanks.  Today I have been testing with gap 50ms and no longer able to
> reproduce the "mmc0: Timeout waiting for hardware interrupt." problem.

Hmm, that's interesting.
The concern of none-0xff gap was that the SDIO interrupt could come in without acknowledgement from host. As long as XO-4 system (specifically mmc subsystem) can wake up within 50ms you are fine.

> 
> > > Looking through history of development, we thought that this would
> > > avoid a race condition, where the host starts to suspend, configures
> > > the device for host sleep, but the device may wake in the time before
> > > the host suspends.
> > >
> > > We don't see this "mmc0: Timeout waiting for hardware interrupt."
> > > problem unless we use WPA2.  It does not reproduce on an open access
> > > point.
> >
> > With WPA2 enabled, does the "mmc0 timeout" happen in every suspend
> > attempt?
> 
> No, it is rare, of the order of one in every 6000 attempts, and depends
> on the timing of arriving packets.  Our reproducer uses a ping ramp,
> with interval varying from 0.1 to 0.9 seconds with 50ms increment, and
> this brings the problem frequency down to about one in 200 attempts.
> 
> The OLPC XO-4 by default tries to suspend automatically when user is
> idle, which is why we notice the problem.

Good to know.

Thanks,
Bing

