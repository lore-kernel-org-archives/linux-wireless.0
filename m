Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:49272 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942Ab0BKMAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 07:00:17 -0500
Date: Thu, 11 Feb 2010 13:01:34 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Message-ID: <20100211120133.GA3136@sortiz.org>
References: <20100202000934.GA19847@sortiz.org>
 <201002041052.00858.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201002041052.00858.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

On Thu, Feb 04, 2010 at 10:52:00AM +0100, Holger Schurig wrote:
> >     + Slightly changed the scanning state machine: The scan
> >       worker is scheduled from the scan response handler, and
> >       we're checking for scan_channel to know if a scan is
> >       currently running. 
> 
> Can you tell my why you change the scanning state machine?  What 
> was broken with it, or why is it now better?
Well, I wasnt happy with the delayed scan work your patch was using.
First you were delaying the initial work and I dont think it's useful.
Then we were scheduling a new scan work from the scan worker itself. Although
it was also delayed by 300 ms, you still dont have any guarantees that the
previous scan is done when the next scan worker starts.
What I changed is triggerring the scan work whenever the last one is done,
i.e. triggering it from lbs_ret_scan(). This way we have a fully synchronized
scanning state machine.


> 
> Also, previously priv->scan_req was the marker that a scan was 
> going on. What did it "buy" to you to change this to 
> priv->scan_channel?
I guess I could still use scan_req for that purpose.
My initial thought was that you could have 2 lbs_cfg_scan() running at the
same time since you could potentially have a 2nd lbs_cfg_scan() call before
scan_request is actually set. However I believe cfg80211 and nl80211 prevent
that from happening anyway as they call the scan ops under the rtnl lock.
So, as I said, I could probably keep using scan_request.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
