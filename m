Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:17852 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761466AbXFATV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 15:21:27 -0400
Message-ID: <46605814.1090806@linux.intel.com>
Date: Fri, 01 Jun 2007 10:32:04 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Update stop_queues kdoc
References: <200706011129.12432.mb@bu3sch.de> <4660503C.9080309@linux.intel.com> <200706011204.23666.flamingice@sourmilk.net>
In-Reply-To: <200706011204.23666.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Friday 01 June 2007 09:58, James Ketrenos wrote:
>> In this way we are putting in a work around that doesn't result in an API
>> change, and that can eventually (hopefully) be fixed the "right way"
>> (whatever that may end up being)
>>
> A workaround could be implemented, but I currently don't see any cases where 
> stopping/waking the queue outside of open/stop/tx is necessary or correct. 

Is calling the ieee80211_stop_queue[s] from open/stop OK then?  The doc update said only in ops->tx.  Should the driver be calling it in the stop callback, or will the stack stop the queues for us?

iwlwifi currently calls ieee80211_stop_queue from the Tx handler and calls ieee80211_stop_queues in the event the adapter is reset (due to HW error, RF kill transition, hw tear down, etc.) as it asynchronously brings re-initializes the hardware.

We definitely need to wake the queue outside of open/stop/tx.  If you stop the queue due to the HW ring being full, you won't be able to wake the queue until the HW has asynchronously freed a Tx slot.

iwlwifi calls ieee80211_wake_queue during buffer reclaiming after the HW indicates the Tx has completed. 

James

> (in bcm43xx, stopping the tx rings is more correct and effective for what is 
> being done there - stopping TX so the radio can be recalibrated)
> 
> -Michael Wu
