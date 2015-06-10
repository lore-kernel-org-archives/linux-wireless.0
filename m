Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40779 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbbFJVnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 17:43:45 -0400
Message-ID: <5578AF90.5030609@candelatech.com> (sfid-20150610_234347_989140_73DFFFB6)
Date: Wed, 10 Jun 2015 14:43:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add netdev name to  NL80211_CMD_STOP_AP event?
References: <5578AA11.2020505@candelatech.com>  (sfid-20150610_232022_833916_9A1896A2) <1433972365.3145.18.camel@sipsolutions.net>
In-Reply-To: <1433972365.3145.18.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2015 02:39 PM, Johannes Berg wrote:
> On Wed, 2015-06-10 at 14:20 -0700, Ben Greear wrote:
>> While trying to make 'iw' able to print out something useful for
>> the 'stop_ap' event, I notice there is not really any human friendly
>> info in the message (just phy id (which may not match phy name), ifindex, and some other
>> wiphy related numeric ID.
>>
>> Any reason not to add the netdev name (NL80211_ATTR_IFNAME) to this and
>> related messages?
> 
> We're not really adding that *anywhere*, and you can trivially look it
> up based on the ifindex, so why bother?

I was thinking netdevice might go away before user-space can decode the
message ( I was assuming that on delete you would stop and very shortly
after that delete the netdev).

It's a small patch to iw and the kernel as far as I can tell...when I
get it working, I'll post for consideration..if you don't want it,
I won't complain :)

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

