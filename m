Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1359 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbYLAC5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2008 21:57:51 -0500
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: rework scan handling while
	associated
From: Zhu Yi <yi.zhu@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <200811281031.04996.helmut.schaa@gmail.com>
References: <200811261805.39953.helmut.schaa@gmail.com>
	 <1227862298.2558.107.camel@debian.sh.intel.com>
	 <200811281031.04996.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 10:58:38 +0800
Message-Id: <1228100318.2558.152.camel@debian.sh.intel.com> (sfid-20081201_035758_020192_B4993CAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-11-28 at 17:31 +0800, Helmut Schaa wrote:
> Hmm, I was able to reproduce the firmware looping endlessly reasonably
> reliable (turned off the beacon-miss-cancels-scan-behaviour and increased the
> scan watchdog timeout) and the ABORT_SCAN command was processed in that case
> and canceled the scan which resulted in a
> HOST_NOTIFICATION_STATUS_SCAN_COMPLETED notification with status 2 (not sure
> if it really was 2). 

'2' is SCAN_COMPLETED_STATUS_ABORTED.

> So, at least the failure I noticed here could be corrected
> by aborting the scan instead of restarting the adapter.
>
> What about the following:
> After the first scan timeout we try to cancel the scan and if that does not
> succeed in a few seconds we can still restart the fw.

A watchdog is used to prevent unpredictable firmware hangs. In your
report, the firmware hang has a predictable pattern. We should focus on
resolving the real problem than workaround this issue.

> I see the timeout because the firmware will never stop scanning until either
> the beacon miss notification cancels the scan or the IPW_SCAN_CHECK_WATCHDOG
> timeout restarts the adapter. I already tried a scan timeout of 25 seconds but
> the firmware insists on scanning the first passive channel (in my setup 52)
> over and over again.

>From what you are saying, it looks like we have a real bug here. Why the
firmware keep sticking in the passive channel if dwell >
beacon_interval? I didn't see this in our testing environment. Normally
my scan for 24 channels takes about 1 second.

[...]

> Yes, it is. If the passive channel dwell time is larger than the beacon
> interval the firmware will be stuck at the first passive channel. Thus the
> scan will never succeed.
> 
> > We assume most APs use 100ms beacon interval. But in case you are
> > associated with an AP which uses 20ms beacon interval, do you want to
> > set the passive_dwell time to 10ms here? 
> 
> Yes, either that or just leaving all channels out that need to be scanned
> for a longer period than the beacon interval. In case of a 20ms beacon interval
> I'm pretty sure the active scan on all other channels will results in a
> endless scan loop in the fw too.
> 
> > 120ms makes sure we can at 
> > least receive a beacon for normal APs.
> 
> Yes, but I'd favour a successful scan that does not find every AP on passive
> channels over a canceled scan.

See above. I ack your idea 2. But 1 and 3 are workaround for a firmware
stuck problem on scan. Let's try to solve the real problem before
considering these workarounds. Looks like you are the only one reported
this problem. Would you like to test some debug patches?

> > BTW, another thing might help to resolve the scan-while-associate
> > problem. Currently we scan 5GHz band channels first, then 2.4GHz band
> > (see ipw_add_scan_channels). Normally most channels in 5GHz band are
> > passive ones. Thus they use longer dwell time. If we change to scan
> > 2.4GHz band channels first, we can get more scan result before a scan
> > abort. Can you please try it?
> 
> That's true but in case the scan is canceled the results are not forwarded
> to user space as they may be incomplete.

We only send an empty scan event when the scan is completed successfully
(vs. aborted). But user is still able to read the partial scan result
even if the scan is aborted. The ieee->network_list is updated anyway.

Thanks,
-yi

