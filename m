Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3285 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab2KPRIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 12:08:35 -0500
Message-ID: <50A67308.8020709@broadcom.com> (sfid-20121116_180842_150172_EA301A82)
Date: Fri, 16 Nov 2012 18:08:24 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: rework on .flush() callback
References: <50A4E458.4090508@broadcom.com>
 <1353072892.9490.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353072892.9490.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 02:34 PM, Johannes Berg wrote:
>> The problem here is that in brcmsmac the flush does the
>> >ieee80211_wake_queues() call, because that could also wakeup the netif
>> >queues. So doing it in the driver seems a bad idea. Any suggestion on
>> >how to solve this?
> Yeah so .. I actually thought about this at some point, it's tricky. For
> the global queues we check what reasons we had for stopping them, but we
> don't do that for the netif queues. Maybe we should? I also think flush
> should at least have the option to be per queue, so that we could do
> something per sdata in mac80211 if the driver uses different HW queues
> for different interfaces.

To me so from driver perspective, it was not clear what 
ieee80211_stop/wake_queues was operating on. Somehow the knowledge that 
the netif queues are already stopped upon calling 
ieee80211_stop_queues() should be retained.

Regarding the flush do you mean flush per queue or flush per vif? Per 
vif could have its perks, I guess.

> However, I'm not sure I'll have time to work on corner cases with
> software scanning since we don't use that. I might work on the flush
> thing though, that could be interesting.

ok. The drv_flush() call is done in several places so not only scanning. 
All with the drop flag set to false. Is that just to be prepared or do 
you foresee an actual use-case?

Gr. AvS

