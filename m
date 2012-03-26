Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49154 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932598Ab2CZPNO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 11:13:14 -0400
Message-ID: <4F708782.3000400@hartkopp.net> (sfid-20120326_171317_881103_F335568E)
Date: Mon, 26 Mar 2012 17:13:06 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Amit Beka <amit.beka@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	David Spinadel <david.spinadel@intel.com>,
	linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: 3.4-merge: iwlwifi needs more than 1 minute to connect
References: <20120316180428.GD2563@tuxdriver.com>  <4F6CD1BC.4040703@hartkopp.net> <1332756333.7081.18.camel@jlt3.sipsolutions.net> <4F707AA7.5050401@hartkopp.net>
In-Reply-To: <4F707AA7.5050401@hartkopp.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 26.03.2012 16:18, Oliver Hartkopp wrote:

> On 26.03.2012 12:05, Johannes Berg wrote:
> 
>> Hi Oliver,
>>
>>> i'm using the *very* latest 3.4-merge tree from Linus and my Wifi now needs
>>> more than one minute to connect to my access point.
>>
>>> [   16.288562] wlan0: authenticate with bc:05:43:94:1a:da
>>> [   16.299644] wlan0: send auth to bc:05:43:94:1a:da (try 1/3)
>>> [   16.302060] wlan0: authenticated
>>> [   16.302492] wlan0: waiting for beacon from bc:05:43:94:1a:da
>>> [   16.432398] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 0 addr bc:05:43:94:1a:da
>>
>> This is an odd message. I need to figure out how that can even happen.
>>
>> What's the beacon interval on your AP? It seems more likely that this is
>> a problem with RX though.



Hi Johannes and Amit,

pointing to the RX path was a good idea!

I checked the commits of the last three weeks and discovered that it turns
out that the patches from Amit caused the regression:

iwlwifi: add testmode command for rx forwarding
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=0aef8ddc8bedac1db4c96fddc9fb1b44b730cf4f


iwlwifi: fixed testmode notifications length
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8e81f65fdc7f5d292bb3c115b748767d921823c1

I reverted them in the opposite order (of course) and now the issue is gone.

Regards,
Oliver
