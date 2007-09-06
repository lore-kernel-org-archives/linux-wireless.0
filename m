Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ananke.telenet-ops.be ([195.130.137.78]:45012 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbXIFBcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 21:32:05 -0400
Message-ID: <46DF5894.70909@telenet.be>
Date: Thu, 06 Sep 2007 03:32:04 +0200
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
References: <1188192012.13078.177.camel@debian.sh.intel.com>	 <20070831205524.GA11128@tuxdriver.com>	 <1188872746.13078.411.camel@debian.sh.intel.com> <1188915229.9942.29.camel@johannes.berg>
In-Reply-To: <1188915229.9942.29.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Johannes Berg wrote:
> On Tue, 2007-09-04 at 10:25 +0800, Zhu Yi wrote:
> 
>> Since they are device specific rate scale algorithm, I don't think they
>> will help to increase performance for other devices.
> 
> What exactly is device specific?
> 

I thought I'd try and answer this question to the best of my ability, since it
has been asked before. And even though it's open source and now has been submitted
to this list, leaving this unanswered feels like a creepy way of potential time bombs
and frustration. That said I'm probably not the best person to do it.


iwl3945-rs:

- the device can retry at different rates, and hence is able to deduct
from the total number of retries a packet needed at which rates it failed/
succeeded

- tables of expected tpt (throughput?) which are used in the the throughput
calculation are probably not very universal?
there aren't identical for 3945 and 4965.

-some synchronization of the station list with the device ucode happens here


addidtionally in iwl4965-rs:

- there is additionally the use of the "link quality" command which for example gets issued when
there isn't enough of other throughput data available.



Might be other things that I have missed, and
parts of the algorithm might be tested/fine tuned for the intended devices.


So that's that. Some questionable implementation details, but it does use
device specific logic/capabilities in order to decide which rate to use.
Now what do we do?

ian

> johannes
