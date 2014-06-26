Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43904 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaFZUXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 16:23:40 -0400
Message-ID: <53AC814C.9040201@candelatech.com> (sfid-20140626_222347_085106_A4CC069F)
Date: Thu, 26 Jun 2014 13:23:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Can we make ieee80211_iface_combination.limits non-const?
References: <53AC6454.5090605@candelatech.com>  (sfid-20140626_202012_477893_089B637F) <1403813187.4463.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1403813187.4463.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/26/2014 01:06 PM, Johannes Berg wrote:
> On Thu, 2014-06-26 at 11:20 -0700, Ben Greear wrote:
>> Depending on firmware loaded (and/or module options), a different
>> number of vdev interfaces may be supported.
>>
>> Can we remove the const from the "struct ieee80211_iface_limit *limits"
>> member of ieee80211_iface_combination?
> 
> No, it would break drivers who actually have a static const for the
> pointer target.

That could be easily fixed, eh?

> You don't have to assign something that's const, but you also can't be
> changing it on the fly after wiphy registration anyway.

This would be done before registration.  I like static init
for defaults, but wanted to poke a few variables at run-time
based on firmware, etc.

Thanks,
Ben

> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

