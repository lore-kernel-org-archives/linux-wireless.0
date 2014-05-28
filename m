Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:41979 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaE1CB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 22:01:56 -0400
Date: Wed, 28 May 2014 12:01:28 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mwifiex: block work queue while suspended
Message-ID: <20140528020128.GG4151@us.netrek.org> (sfid-20140528_040159_087642_41BFD75B)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 04:39:07PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > > To understand what is happening here could you apply attached debug
> > > patch to generate logs, or enable dynamic_debug for that?
> > 
> > Here's a dynamic_debug log.
> > 
> > Note the point of failure is the "mmc0: Timeout waiting for hardware
> > interrupt." message, which occurs in the driver SDIO interrupt
> > function, which began execution in a critical time period after driver
> > suspend but before platform suspend.
> > 
> > We use a GPIO to wake from WLAN.
> 
> This doesn't match the gpio parameter configured in hscfg command
> 0xe5.

You're right, and I'm quite wrong.  Sorry about that.  I misread our
code.

Correction, we use SDIO to wake from WLAN.

We set gap to 0xff, which we think is a special value that means the
device will wait for the host to acknowledge before sending data to
the host.

Looking through history of development, we thought that this would
avoid a race condition, where the host starts to suspend, configures
the device for host sleep, but the device may wake in the time before
the host suspends.

We don't see this "mmc0: Timeout waiting for hardware interrupt."
problem unless we use WPA2.  It does not reproduce on an open access
point.

-- 
James Cameron
http://quozl.linux.org.au/
