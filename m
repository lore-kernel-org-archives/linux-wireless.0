Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:51601 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759210AbXEJSqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 14:46:21 -0400
Message-ID: <46437DC8.2060805@linux.intel.com>
Date: Thu, 10 May 2007 13:17:12 -0700
From: jketreno <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
References: <464253CE.2030504@linux.intel.com>	<20070510132756.2ca660a0@midnight.suse.cz>	<46434596.6010908@linux.intel.com> <20070510194233.335004b7@griffin.suse.cz>
In-Reply-To: <20070510194233.335004b7@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Thu, 10 May 2007 09:17:26 -0700, James Ketrenos wrote:
>> We've written an open source rate control algorithm that can take
>> advantage of features our hardware has, that our users, testing,
>> research, and development has shown to be advantageous in terms of
>> solid performance, system overhead, power consumption, etc.
> 
> Please send your rate control algorithm first so we can know why are
> you requesting this. 

I told you the reason why I am requesting this.  Do you think I'm lying or trying to trick you?

Generic algorithms aren't as capable as hardware specific algorithms when you factor performance, latency, system utilization, power consumption, etc.  Optimal algorithms are written to take advantage of the capabilities exposed by the hardware.

The 3945, as an example, let's you configure the hardware with a set of rates, retries per rate, and a fallback order.  You submit one Tx request to the hardware and it then performs all the retries, fallbacks, etc without host interaction over overhead.  The rate control algorithm needs to be aware of the attempts made by the hardware.  The specific mechanism by which the 3945 sets up those rates is device specific.  The mechanism by which the results are reported back are device specific.  The functions related to selecting the Tx rate are called twice for *EVERY PACKET*.  Anything you can do to make that code-path faster and leaner for the specific device it is using is a win.  Hardware specific beats generic.

Might other hardware devices also support some type of rate fallback or automatic retries?  Maybe.  Do they all do it the same way?  No.  Is it worth slowing down hot code paths in the name of "generic software"?  Absolutely not.

James

PS.  You're free to download the 3945 specific rate control algorithm if you want.  It has been part of the GPL ipw3945 driver for over a year at http://ipw3945.sf.net.  You can also find it refactored in iwlwifi at http://intellinuxgraphics.org.
