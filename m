Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:51979 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbZCNRFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:05:14 -0400
Message-ID: <49BBE3B6.8000005@nokia.com> (sfid-20090314_180519_557640_A0049C3E)
Date: Sat, 14 Mar 2009 19:04:54 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: don't drop null frames during software scan
References: <20090314144405.670.16447.stgit@tikku>	 <1237043931.5235.67.camel@johannes.local>  <49BBCE18.4090606@nokia.com>	 <1237046839.5235.86.camel@johannes.local>	 (sfid-20090314_170734_362051_D492D2DA) <1237046957.5235.88.camel@johannes.local>
In-Reply-To: <1237046957.5235.88.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2009-03-14 at 17:07 +0100, Johannes Berg wrote:
>> On Sat, 2009-03-14 at 17:32 +0200, Kalle Valo wrote:
>>> Perhaps. I chose this path only because it was simple to implement :) 
>>> I'll take a look at the scan code in more detail and fix it there.
>> You're kinda right too, we want to disable the queues first, then set
>> sw_scanning/notify the driver, and then send the nullfunc, I think. So
>> it's either this patch, or iterating the interface list twice.
> 
> Similarly for the beacon disable part, that _needs_ to be done after
> sw_scanning=true otherwise it won't actually work...
> 
> I think I prefer your patch over that complexity, but would like to have
> a good comment explaining it

Ok. I'll add a comment in v2.

> and possibly one in
> scan.c:ieee80211_start_scan that points to that code.

Yeah, that's definitely needed. I was first really confused why the null 
frame got lost.

Kalle
