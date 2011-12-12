Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48836 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLJWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:22:42 -0500
Received: by pbbb2 with SMTP id b2so764999pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 01:22:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323680547.3442.6.camel@jlt3.sipsolutions.net>
References: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com>
	<1323680547.3442.6.camel@jlt3.sipsolutions.net>
Date: Mon, 12 Dec 2011 10:22:41 +0100
Message-ID: <CAMG6FYjxRK30hTvKEaK=ppofN=KecJkbabTggWzXZQ5b-EN-NA@mail.gmail.com> (sfid-20111212_102246_313719_7C4BAD39)
Subject: Re: [RFC] mac80211: Prevent possible BUG on suspend.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2011 at 10:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-12-12 at 00:38 +0100, Dmitry Tarnyagin wrote:
>> Some WLAN hardware has
>> longer timeouts for non-interruptible configuration-related
>> operations, leading to the watchdog timeout while
>> ieee80211_scan_cancel is waiting on a mutex.
>
> Yuck, fix the device?
>
It's hardly possible. Some configuration changes really takes long time,
especially in presence of an active bluetooth session.
... or abort suspend on the driver's level. It's perfectly ok for me. But then
driver needs to be at least notified that WLAN is suspending. What do you
think about early-suspend driver callback which to be called before any
possibly locking operations in mac80211 code?

>> The patch checks if interface mutex is already held and rejects
>> suspend if there is a possibility of locking.
>
> That's really not a good plan. This will refuse suspend *all the time*.
>
All the time? I don't think so.. On normal Linux systems WLAN operations
should not interfere with suspend at all. On aggressive systems like Android
it's actually a good idea to reject suspend when the interface mutex is held,
otherwise system will be likely resumed almost immediately by WoW.
