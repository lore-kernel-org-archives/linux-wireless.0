Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:34886 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbYKAPUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 11:20:31 -0400
Date: Sat, 1 Nov 2008 17:19:38 +0200
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Michael MIC failures in AP mode?
Message-ID: <20081101151938.GA4857@jm.kir.nu> (sfid-20081101_162043_951195_6B30AF69)
References: <87wsfnldq9.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wsfnldq9.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 01, 2008 at 04:31:26PM +0200, Kalle Valo wrote:

> Now that AP mode works in mac80211 I want to use it to test Michael
> MIC failures in a wlan driver. Any recommendations, or tips, how to
> easily create them with mac80211 and hostapd?

There used to be test code for this in mac80211 that allowed testing of
more or less all TKIP error cases (MIC error on TX/RX, ICV error on
TX/RX, replay), but it looks like that has been mostly "cleaned up" be
removal.. You might be able to find it from some old version..

Anyway, if you just want to test Michael MIC error processing on a
client, force mac80211 to do software encryption and modify
ieee80211_tx_h_michael_mic_add() in net/mac80211/wpa.c to insert an
incorrect MIC (e.g., add mic[0]++; after the michael_mic() call). You
will probably need a trigger mechanisms (say debugfs write) to enable
this for a single TX frame in order to allow proper client testing.

Once I have some time, I could take a look at recovering the old design
with a debugfs interface (it used to use private ioctl). It is useful to
be able to test this type of things during development/system
validation.

-- 
Jouni Malinen                                            PGP id EFC895FA
