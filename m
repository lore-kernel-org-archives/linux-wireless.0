Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:37705 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYKEUyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:54:45 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Thoughts about mac80211 client PS implementation
References: <87k5bhkjf1.fsf@nokia.com>
	<1225917235.3619.180.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 22:54:03 +0200
In-Reply-To: <1225917235.3619.180.camel@johannes.berg> (ext Johannes Berg's message of "Wed\, 05 Nov 2008 21\:33\:55 +0100")
Message-ID: <87fxm5ki6s.fsf@nokia.com> (sfid-20081105_215449_936987_5B178A1A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2008-11-05 at 22:27 +0200, Kalle Valo wrote:
>> I'm working on implementing the "dynamic Power Save" (ie. PS enabled
>> after an idle period) feature to mac80211. Here are my current
>> thoughts:
>> 
>> First of all, I think we should enable CONF_PS only when associated.
>> So instead of directly calling hw_config() from
>> ieee80211_ioctl_siwpower() we should do that only when associated.
>> Otherwise we change it only after association or disassociation. This
>> means that we have to add a separate bit/variable for storing what
>> user has requested.
>
> Totally agreed.

Good :)

>> PS should be disabled while associated and running software scan, and
>> naturally re-enabled after the scan has finished. I assume hardware
>> scanning implementations are clever enough to disable PS when scanning
>> and we don't have to worry about that case.
>
> And on that too. And should there be a monitor flag that disables PS, so
> that we can "refcount" the PS bit in a way?

Sorry, I don't follow you here. What do you mean by a monitor flag?

>> The dynamic PS implementation is still a bit open issue for me. I have
>> been thinking something like that in tx.c frames will be queued if PS
>> is enabled, PS will be disabled in a workqueue by calling
>> ieee80211_hw_config() and only after that the queued frames are
>> transfered. So something similar as sta->ps_tx_buf does in AP mode. No
>> idea if this is feasible or not.
>
> Not sure I understand the dynamic PS yet. 

Basically the idea is to disable PS whenever we are transmitting (and
maybe also receiving, don't know yet) frames, but whenever there's a
long enough idle period PS would be enabled again. So in principle
this would be a compromise of low power consumption and low latency.

Naturally the idle period would be configurable with siwpower() and
whatever nl80211 equivalent we will have in future.

> Why would you queue up frames? To reduce the number of radio wakeups
> when TX traffic is low?

Just because I assume that invoke_tx_handlers() cannot sleep but
ieee80211_hw_config() sleeps. I didn't think of any other way to solve
this, but I haven't thought that much about this. What do you think?

-- 
Kalle Valo
