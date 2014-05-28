Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:36004 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbaE1EuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 00:50:05 -0400
Date: Wed, 28 May 2014 14:49:45 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mwifiex: block work queue while suspended
Message-ID: <20140528044945.GI4151@us.netrek.org> (sfid-20140528_065016_051664_2DCCBF32)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
 <20140528020128.GG4151@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E4B3@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70F5E4B3@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 09:35:21PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > > > We use a GPIO to wake from WLAN.
> > >
> > > This doesn't match the gpio parameter configured in hscfg command
> > > 0xe5.
> > 
> > You're right, and I'm quite wrong.  Sorry about that.  I misread our
> > code.
> > 
> > Correction, we use SDIO to wake from WLAN.
> > 
> > We set gap to 0xff, which we think is a special value that means the
> > device will wait for the host to acknowledge before sending data to
> > the host.
> 
> Yes, gap=0xff should be used. Actually I also have the patch to set
> gap to 0xff queued in my local tree. I will send it upstream.

Thanks.  Today I have been testing with gap 50ms and no longer able to
reproduce the "mmc0: Timeout waiting for hardware interrupt." problem.

> > Looking through history of development, we thought that this would
> > avoid a race condition, where the host starts to suspend, configures
> > the device for host sleep, but the device may wake in the time before
> > the host suspends.
> > 
> > We don't see this "mmc0: Timeout waiting for hardware interrupt."
> > problem unless we use WPA2.  It does not reproduce on an open access
> > point.
> 
> With WPA2 enabled, does the "mmc0 timeout" happen in every suspend
> attempt?

No, it is rare, of the order of one in every 6000 attempts, and depends
on the timing of arriving packets.  Our reproducer uses a ping ramp,
with interval varying from 0.1 to 0.9 seconds with 50ms increment, and
this brings the problem frequency down to about one in 200 attempts.

The OLPC XO-4 by default tries to suspend automatically when user is
idle, which is why we notice the problem.

-- 
James Cameron
http://quozl.linux.org.au/
