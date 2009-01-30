Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54125 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbZA3Lpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 06:45:50 -0500
Message-ID: <4982E7E3.3010104@nokia.com> (sfid-20090130_124554_599662_BCE6A7E7)
Date: Fri, 30 Jan 2009 13:43:31 +0200
From: Kalle Valo <kalle.valo@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: convert to net_device_ops
References: <20090127052926.44d3fd5f@s6510>	 <1233314257.30970.6.camel@johannes.local>	 (sfid-20090130_121747_128792_58F3B8C4) <1233314871.30970.10.camel@johannes.local>
In-Reply-To: <1233314871.30970.10.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-01-30 at 12:17 +0100, Johannes Berg wrote:
>> On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
>>> Convert to new net_device_ops in 2.6.28 and later.
>>>
>>> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>> John, please revert this commit for now, it's breaking monitor mode
>> injection (and thus AP mode) because the xmit handler assignment in
>> ieee80211_setup_sdata is not effective.
> 
> Oh, for reference:
> 
> commit e22cab741afdd1e9857ea9fe51e28a6fe3c97b90
> Author: Stephen Hemminger <shemminger@vyatta.com>
> Date:   Tue Jan 27 05:29:25 2009 +1100
> 
>     mac80211: convert to net_device_ops
>     
>     Convert to new net_device_ops in 2.6.28 and later.
>     
>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>     Acked-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Yes, I can confirm that reverting this commit solves the hostapd 
problems I have been seeing.

Kalle

