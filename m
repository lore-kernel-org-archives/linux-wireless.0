Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:38149 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYL2GDd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 01:03:33 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1673047fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2008 22:03:31 -0800 (PST)
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add declarations for wake/stop_queue_by_reason()
References: <20081228185414.6204.97451.stgit@tikku>
	<1230500160.25726.7.camel@dv>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 29 Dec 2008 08:03:27 +0200
In-Reply-To: <1230500160.25726.7.camel@dv> (Pavel Roskin's message of "Sun\, 28 Dec 2008 16\:36\:00 -0500")
Message-ID: <87sko7ikls.fsf@litku.valot.fi> (sfid-20081229_070354_449159_F5340DB0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> On Sun, 2008-12-28 at 20:54 +0200, Kalle Valo wrote:
>> Fixes sparse warnings:
>> 
>> net/mac80211/util.c:355:6: warning: symbol 
>>   'ieee80211_wake_queue_by_reason' was not declared. Should it be static?
>> net/mac80211/util.c:385:6: warning: symbol 
>>   'ieee80211_stop_queue_by_reason' was not declared. Should it be static?
>
> ...
>  
>> +void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
>> +				    enum queue_stop_reason reason);
>> +void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
>> +				    enum queue_stop_reason reason);
>
> What's the point in declaring functions that are not used elsewhere?
> Why not make them static as sparse suggests?

I was thinking that maybe in the the future the are other users in
mac80211, but your comment made me rethink this and I agree with you,
they should be static.

Please forget this patch, I'll send a new one.

> And if those function are going to be used by other modules, maybe
> they should be exported?

This is a mac80211 internal interface, not to be used by the drivers.
So it should not be exported.

-- 
Kalle Valo
