Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8609 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbaE1Efq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 00:35:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 May 2014 21:35:21 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5E4B3@SC-VEXCH1.marvell.com> (sfid-20140528_063549_949434_3892A3A9)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
 <20140528020128.GG4151@us.netrek.org>
In-Reply-To: <20140528020128.GG4151@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > We use a GPIO to wake from WLAN.
> >
> > This doesn't match the gpio parameter configured in hscfg command
> > 0xe5.
> 
> You're right, and I'm quite wrong.  Sorry about that.  I misread our
> code.
> 
> Correction, we use SDIO to wake from WLAN.
> 
> We set gap to 0xff, which we think is a special value that means the
> device will wait for the host to acknowledge before sending data to
> the host.

Yes, gap=0xff should be used. Actually I also have the patch to set gap to 0xff queued in my local tree. I will send it upstream.

> 
> Looking through history of development, we thought that this would
> avoid a race condition, where the host starts to suspend, configures
> the device for host sleep, but the device may wake in the time before
> the host suspends.
> 
> We don't see this "mmc0: Timeout waiting for hardware interrupt."
> problem unless we use WPA2.  It does not reproduce on an open access
> point.

With WPA2 enabled, does the "mmc0 timeout" happen in every suspend attempt?

Thanks,
Bing

