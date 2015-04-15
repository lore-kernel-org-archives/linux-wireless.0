Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:48681 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbDOLiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 07:38:09 -0400
Date: Wed, 15 Apr 2015 21:37:54 +1000
From: James Cameron <quozl@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH] mwifiex: increase number of probes for specific SSID
 scans
Message-ID: <20150415113754.GH32455@us.netrek.org> (sfid-20150415_133814_453347_665B94B5)
References: <1429022956-12016-1-git-send-email-akarwar@marvell.com>
 <20150414203724.GB32455@us.netrek.org>
 <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC138@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFC138@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2015 at 02:01:44AM -0700, Amitkumar Karwar wrote:
> Hi James,
> 
> > 
> > On Tue, Apr 14, 2015 at 07:49:16AM -0700, Amitkumar Karwar wrote:
> > > It's been observed that device sometimes fails to find AP configured
> > > in hidden SSID in busy environment. We will increase number of probes
> > > for specific SSID scans for getting better results.
> > 
> > I don't like this.  It worries me.  What is the underlying cause?  If it
> > is something other than collision, why?
> > 
> 
> Idea was to have better chance of finding an AP configured with
> hidden SSID when environment is busy by sending multiple probe
> requests.

Yes, I understand the intention, but I don't understand why busy
environment should cause missed probe response from hidden SSID AP.

Speculating ...

Have you tested this?  Are you sure the probe request is being sent
when the channel is clear?  Are collisions detected?  Is recovery from
collision correct?

Are you sure it isn't caused by scan results being too large in busy
environment?  Is scan for specific SSID given priority in scan
results, by firmware?

I ask because I'm curious; perhaps there is something else happening
to cause scan failure.

I have reports of scan failure with mwifiex, with 8686 and 8787, but
I've not been able to prove the cause of the problem, because of high
complexity of testing.  Customer usually unwilling to go into depth.

> > In scenario of tens to a hundred laptops scanning for specific SSID for
> > ad-hoc in the Sugar desktop environment, this patch may decrease free
> > air time considerably.
> 
> You are right. Free air time will be decreased. We have discarded
> this approach considering its consequences.
> 
> > 
> > Should the number of probes be a choice of user space?
> > 
> 
> Do you see any potential use case for multiple probe requests? 

No use case that doesn't risk interference.  I've used it in
diagnosis, and in Open Firmware driver.

> I think, we should stick to current implementation of sending 1
> probe request.

That's fine.

> Regards,
> Amitkumar

-- 
James Cameron
http://quozl.linux.org.au/
