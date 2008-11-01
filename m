Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:62212 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYKAPpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 11:45:17 -0400
To: "Jouni Malinen" <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Michael MIC failures in AP mode?
References: <87wsfnldq9.fsf@nokia.com> <20081101151938.GA4857@jm.kir.nu>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 01 Nov 2008 17:45:06 +0200
In-Reply-To: <20081101151938.GA4857@jm.kir.nu> (ext Jouni Malinen's message of "Sat\, 1 Nov 2008 17\:19\:38 +0200")
Message-ID: <87skqblabh.fsf@nokia.com> (sfid-20081101_164626_193233_40FE6038)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext Jouni Malinen" <j@w1.fi> writes:

> On Sat, Nov 01, 2008 at 04:31:26PM +0200, Kalle Valo wrote:
>
>> Now that AP mode works in mac80211 I want to use it to test Michael
>> MIC failures in a wlan driver. Any recommendations, or tips, how to
>> easily create them with mac80211 and hostapd?
>
> There used to be test code for this in mac80211 that allowed testing of
> more or less all TKIP error cases (MIC error on TX/RX, ICV error on
> TX/RX, replay), but it looks like that has been mostly "cleaned up" be
> removal.. You might be able to find it from some old version..

Ok, I'll try to find it.

> Anyway, if you just want to test Michael MIC error processing on a
> client, force mac80211 to do software encryption and modify
> ieee80211_tx_h_michael_mic_add() in net/mac80211/wpa.c to insert an
> incorrect MIC (e.g., add mic[0]++; after the michael_mic() call). You
> will probably need a trigger mechanisms (say debugfs write) to enable
> this for a single TX frame in order to allow proper client testing.

Thanks, this is very helpful.

> Once I have some time, I could take a look at recovering the old design
> with a debugfs interface (it used to use private ioctl). It is useful to
> be able to test this type of things during development/system
> validation.

It sure is. I think I'm going to start using hostapd/mac80211 combo
for all my development, a simple configuration file and proper logs
are very handy compared to some crappy web interface. And having test
cases like artificial Michael MIC failure makes the system even
better.

I really hope that John can push the AP support to mainline during
next merge window :)

-- 
Kalle Valo
