Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:17527 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756336AbXD0SDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 14:03:55 -0400
Message-ID: <46323671.2060803@linux.intel.com>
Date: Fri, 27 Apr 2007 10:44:17 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Andy Green <andy@warmcat.com>, Dan Williams <dcbw@redhat.com>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>	<200704251634.16604.flamingice@sourmilk.net>	<46312067.9090005@linux.intel.com>	<200704262023.52833.flamingice@sourmilk.net>	<1177684132.21025.36.camel@localhost.localdomain>	<20070427164208.25434f11@griffin.suse.cz>	<1177685793.21025.52.camel@localhost.localdomain>	<20070427172004.32b7bf4a@griffin.suse.cz>	<463216FA.6000206@warmcat.com> <20070427173633.506820ae@griffin.suse.cz>
In-Reply-To: <20070427173633.506820ae@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Fri, 27 Apr 2007 16:30:02 +0100, Andy Green wrote:
>>> fixes the problem. Now, let's find something that fixes the problem as
>>> well but doesn't remove the functionality. James already proposed a
>>> solution that could work if a support for user space MLME is added. Do
>>> you have an idea how to add it?
>> Jiri, what functionality?  The ability to change frequency periodically?
>>   Isn't that something mac80211 can do already?
> 
> Please see other mails in this thread. The opinions differ.
> 
> As long as it is implemented cleanly I have no objections against it.
> 
> Btw, the main argument for hw_scan was power consumption. I'd still
> like to see numbers :-)

No, my main argument for hw_scan was latency to associate.  

I also think power consumption and overall system overhead is important; opinions vary on this (I think even the 18 seconds per hour that Michael asserts is worth it given that it doesn't impose any negative impact the end users flexibility)

If mac80211 can get scanning to consistently work as fast as hardware scanning, and can show that it doesn't negatively impact battery life, CPU load, or throughput (esp. while associated)--great!  Once that goal is reached then I can't think of a reason why we would want hardware scan offloading.

I don't have numbers to show you how much power a scan costs when done in SW vs. HW.  I do have numbers that show that if I don't use hw_scan, the scan takes more than twice as long.  A code profiler can show that there is a lot more processing going on in the host during a software scan than a hardware scan.  

There are also features enabled through Intel's wireless products that mac80211 currently doesn't support that you just can't do as efficiently in a 100% host based softmac solution.  I would love to enable those as well.  One example is concurrent scanning for multiple SSIDs in a single scan without having to send multiple probe requests from the [userspace->]mac80211->driver->hardware.

James
