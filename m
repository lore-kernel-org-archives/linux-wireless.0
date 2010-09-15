Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38816 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0IOPca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 11:32:30 -0400
Message-ID: <4C90E708.5050109@candelatech.com>
Date: Wed, 15 Sep 2010 08:32:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  mac80211/ath9k:  allow scanning single channel if other
 VIF is associated.
References: <4C8EB03D.7070808@candelatech.com>	 <20100915030316.GB30253@jm.kir.nu>  <4C9059DC.7060009@candelatech.com>	 <1284545796.3842.11.camel@jlt3.sipsolutions.net>	 <4C90D683.7000801@candelatech.com> <1284560664.7705.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284560664.7705.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2010 07:24 AM, Johannes Berg wrote:
> On Wed, 2010-09-15 at 07:21 -0700, Ben Greear wrote:
>
>> Right, but as soon as one finished, the next would start, and at least in .31,
>> that caused the first to un-associate, giving never-ending loop of interfaces
>> scanning and trying to associate.
>
> There should be a grace period maybe?

I don't think that really fixes anything, except make the race between
full scan and attempting for the first interface to associate harder to
hit (and that is only useful if the scan-one logic is enabled anyway).

>> Ok, I'll see if I can add a 'scan-one-if-associated' flag for wpa-supplicant to
>> use.
>
> Just make it give the channel instead of adding new API.

I think you still need an 'any', because whoever wrote the wpa_supplicant config file doesn't
necessarily know what channel the AP is on.  The first interface to do a full scan
can figure that out and associate....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
