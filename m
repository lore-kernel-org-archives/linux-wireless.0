Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54864 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755507AbXD0I7v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 04:59:51 -0400
Date: Fri, 27 Apr 2007 11:00:11 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
Message-ID: <20070427110011.5dbf8f13@griffin.suse.cz>
In-Reply-To: <46317888.9040909@linux.intel.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	<200704251634.16604.flamingice@sourmilk.net>
	<46312067.9090005@linux.intel.com>
	<200704262023.52833.flamingice@sourmilk.net>
	<46317888.9040909@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 26 Apr 2007 21:14:00 -0700, James Ketrenos wrote:
> Right now the scanning in mac80211 is slow.  I haven't really dug
> into it to see if it will transition from passive to active if it
> detects RF activity on an otherwise passive channel, etc. but I have
> seen that if we turn on hw scanning we can get results back in a few
> seconds vs. 10 or more.  

The scanning in mac80211 needs to be improved. I'd consider this as a
job for user space MLME, though.

> The more passive channels you add (most of 802.11a) the slower the
> scanning gets.

This seems to be a common, not a softmac specific problem. At least, if
done properly, I don't see how there could be a difference in softmac
vs. firmware scanning wrt. time.

> If done right, the stack would set up the list of channels to scan,
> whether to scan the channel active or passive, and the template for
> the probe request to use.  
> 
> For sw based scans, the stack would then have a mechanism for
> executing that scan through a series of tunes, transmits, etc.  For
> hw scans, it would pass that structure to the driver which would
> package it for the hardware and pass it down.
> 
> Upon completion of the scan (sw or hw) the notification would come
> back to the stack to let it know scanning is complete.  
> 
> The sw scan engine would be tied into the rest of the transmit
> infrastructure to manage off channel time, etc. (which you don't have
> to do with hw scanning since the hardware/uCode does it all for you)

This sounds reasonable and I think it addresses most of Michael's
objections.

Unfortunately, I don't see how user space MLME fits into this. Any idea
how to solve this remaining issue? (But no ugly hacks, please.)

> Unless there is a mechanism to quickly and easily toggle between
> filter and don't  filter, you'll end up turning off hw/uCode
> filtering of packets all the time.  

I'm not sure I understand. What prevents you from turning off the
filtering just during the scanning?

> Which means the hardware would be set to full promiscuous mode and
> every packet Rx'd would get tossed to the host to then either process
> or discard--which keeps the host CPU awake (which isn't good on
> laptops or anywhere else folks care about power consumption)  And
> scanning is one of those things that happens more frequently when you
> are not plugged in and are moving around the home, school, office,
> etc.

Yes, power consumption is a good argument. However, how much time you
spend in scanning (compared to the total time you use your wifi card)?
It would be helpful to see some numbers.

> > What's the big bottleneck that justifies moving this to 
> > hardware? 
> 
> With the 3945 its mainly power consumption.

Do you have some numbers? Personally, I have no idea how much power you
can save by offloading the scan. It could be interesting.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
