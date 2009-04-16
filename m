Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53713 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZDPJ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 05:59:54 -0400
Received: by bwz17 with SMTP id 17so302707bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 02:59:52 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
References: <1239837672.11795.46.camel@violet>
	<1239841291.25334.18.camel@johannes.local>
	<87ocuxf7kv.fsf@litku.valot.fi>
	<1239873166.9737.4.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 12:59:51 +0300
In-Reply-To: <1239873166.9737.4.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 11\:12\:46 +0200")
Message-ID: <87fxg8apgo.fsf@litku.valot.fi> (sfid-20090416_115957_898142_D8F0B02E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-16 at 09:14 +0300, Kalle Valo wrote:
>
>> Basically the problem is that if you scan in an area where there are no
>> or very few APs and scan takes more than two seconds (like abg band
>> scans usually take), sta->last_rx won't get updated because mac80211 is
>> not receiving any frames. This is why the beacon loss check will trigger
>> in ieee80211_associated().
>> 
>> The problem won't happen if there are lot of APs in the neighbourhood
>> distributed throughout the channels because then sta->last_rx is updated
>> often enough and the beacon loss check won't trigger.
>
> That doesn't make sense, why would our AP sta->last_rx be updated for
> other APs? I think you mean sdata->u.mgd.last_beacon, which is, probably
> wrongly, updated for all beacons.

Yes, I meant sta->last_beacon. But the principle is the same anyway.

>> I have been thinking two ways to fix this, either disabling the timer
>> for the duration of the scan or add a check for scan scan in
>> ieee80211_associated(). I started implementing the former but haven't
>> finished it yet. It would be great if someone else can fix it.
>
> But that doesn't make sense to me now. ieee80211_associated() is only
> run from the station work (ieee80211_sta_work) which doesn't do anything
> when we're scanning (and gets restarted on scan end). So even if last_rx
> or last_beacon isn't updated we should only run the evaluation of that
> after the scan finishes.

ifmgd->timer is run every two seconds, even then scanning and it calls
like this:

ieee80211_sta_timer() -> ieee80211_sta_work() -> ieee80211_associated()

And to my knowledge the timer is run even when scanning. Or am I missing
something?

Like you have sometime ago said, this MLME code we would need a rewrite.
It's getting messier all the time.

-- 
Kalle Valo
