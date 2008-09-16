Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38901 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYIPHJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 03:09:58 -0400
To: "Helmut Schaa" <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: More thoughts about roaming ...
References: <200809151416.07552.hschaa@suse.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 16 Sep 2008 10:09:47 +0300
In-Reply-To: <200809151416.07552.hschaa@suse.de> (ext Helmut Schaa's message of "Mon\, 15 Sep 2008 14\:16\:06 +0200")
Message-ID: <87zlm8d0sk.fsf@nokia.com> (sfid-20080916_091003_168667_AD475544)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Helmut Schaa" <hschaa@suse.de> writes:

> Hi,

Hello,

very good that you have been working on this. Like we discussed
earlier, this in an area where we need to improve mac80211.

Due to travelling (ad: Maemo Summit at Berlin) I don't have time to
test your patches this week, but hopefully next week. Few comments
first:

> * Enhance mac80211 to check the signal quality frequently (or any other
>   indicator like beacon misses) and decide when the signal quality is too low.
>   Indicate that to the user space.
>
> * wpa_supplicant (or any other user space application) gets notified about
>   the low signal quality and triggers a scan in order to find a better AP.
>   wpa_supplicant already chooses the AP with the best signal strength.

I think we should have two signals with different states. One for
informing that low signal condition has started and another one for
telling that low signal condition has ended (ie. the device has good
signal to the AP).

In the low signal state wpa_supplicant would then periodically scan
for better APs.

> The reason behind not triggering the scan directly from mac80211 is
> that the supplicant (or any other user space application) might know
> more about the current environment and could for example trigger a
> scan restricted to specific channels (in the future) which should
> speed up the scan. Hence let the user space decide what to do with a
> low signal.

Exactly.

> However the detection of when the signal quality is low should still
> be done in mac80211 or the driver as some cards seem to have the
> needed functionality implemented in firmware (e.g. missed beacon
> interrupt).

I agree.

-- 
Kalle Valo
