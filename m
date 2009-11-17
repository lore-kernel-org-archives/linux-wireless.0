Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:5854 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZKQRKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:10:54 -0500
Received: by qw-out-2122.google.com with SMTP id 3so63259qwe.37
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 09:10:59 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/16] wl1251: fix deadlock with ieee80211 beacon filter calls
References: <20091117164614.2236.8543.stgit@tikku>
	<20091117164852.2236.24891.stgit@tikku>
	<1258477288.21197.1.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 17 Nov 2009 19:10:51 +0200
In-Reply-To: <1258477288.21197.1.camel@johannes.local> (Johannes Berg's message of "Tue\, 17 Nov 2009 18\:01\:28 +0100")
Message-ID: <87r5rxcc10.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2009-11-17 at 18:48 +0200, Kalle Valo wrote:
>> From: Vidhya Govindan <vidhya.govindan@nokia.com>
>> 
>> Lockdep shows that there is a deadlock when calling ieee80211_rssi_changed()
>> under wl->mutex. Fix it by releasing mutex before calling mac80211 functions.
>> This patch is based on Work-In-Progress patch sent by Kalle Valo.
>
>>  	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
>>  		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
>> +		/* need to unlock mutex to avoid deadlocking with rtnl */
>> +		mutex_unlock(&wl->mutex);
>>  
>>  		/* indicate to the stack, that beacons have been lost */
>>  		ieee80211_beacon_loss(wl->vif);
>> +		mutex_lock(&wl->mutex);
>
> That can't be true, ieee80211_beacon_loss() only calls
> ieee80211_queue_work().

You are correct, of course. The problem was in our internal and
heavily patched 2.6.28 tree, but not in wireless-testing. I should
have checked this when I was rebasing the patches. Johannes, thank you
for noticing this!

John, can you drop this patch or do you want me to resend the patch
set? Based on stgit there might some problems with patch 10 after
dropping this patch, but at least stgit was able to handle it
automatically.

-- 
Kalle Valo
