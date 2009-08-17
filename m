Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:46379 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbZHQOYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 10:24:47 -0400
Received: by fxm11 with SMTP id 11so2313385fxm.39
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 07:24:47 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: allow configure_filter callback to sleep
References: <1250518613.15103.7.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 17 Aug 2009 17:24:44 +0300
In-Reply-To: <1250518613.15103.7.camel@johannes.local> (Johannes Berg's message of "Mon\, 17 Aug 2009 16\:16\:53 +0200")
Message-ID: <87zl9ytt5f.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Over time, a whole bunch of drivers have come up
> with their own scheme to delay the configure_filter
> operation to a workqueue. To be able to simplify
> things, allow configure_filter to sleep, and add
> a new prepare_multicast callback that drivers that
> need the multicast address list implement. This new
> callback must be atomic, but most drivers either
> don't care or just calculate a hash which can be
> done atomically and then uploaded to the hardware
> non-atomically.
>
> A cursory look suggests that at76c50x-usb,

BTW, at76c50x-usb is broken currently. The change of providing bssid to
the driver only after association broke it. I don't have time to fix it
right now, but I try to find some time next week.

> ar9170, mwl8k (which is actually very broken now), rt2x00, wl1251,
> wl1271 and zd1211 should make use of this new capability.

This will make things a lot easier for wl1251 and wl1271. Thank you for
this.

-- 
Kalle Valo
