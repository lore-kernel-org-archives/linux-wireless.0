Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50799 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590AbbCRK0B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 06:26:01 -0400
Message-ID: <550952B4.4050400@broadcom.com> (sfid-20150318_112606_140206_DB1AC1D0)
Date: Wed, 18 Mar 2015 11:25:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wiphy band information
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Is it ok to update the wiphy band information after registration. In 
brcmfmac the firmware is queried to obtain the supported channels. 
However, it returns the channels for the current country set in 
firmware. So after probe/registration iw shows:

		Frequencies:
			* 2412 MHz [1] (20.0 dBm)
			* 2417 MHz [2] (20.0 dBm)
			* 2422 MHz [3] (20.0 dBm)
			* 2427 MHz [4] (20.0 dBm)
			* 2432 MHz [5] (20.0 dBm)
			* 2437 MHz [6] (20.0 dBm)
			* 2442 MHz [7] (20.0 dBm)
			* 2447 MHz [8] (20.0 dBm)
			* 2452 MHz [9] (20.0 dBm)
			* 2457 MHz [10] (20.0 dBm)
			* 2462 MHz [11] (20.0 dBm)

Recently, I added a .reg_notifier() callback to brcmfmac which will 
propagate country setting to firmware. This gave a crash during scan 
because ieee80211_get_channel() returned NULL for bss on freq 2472. I 
added code to update the channel info upon changing country code, but 
when I do that iw shows:

		Frequencies:
			* 2412 MHz [1] (0.0 dBm)
			* 2417 MHz [2] (0.0 dBm)
			* 2422 MHz [3] (0.0 dBm)
			* 2427 MHz [4] (0.0 dBm)
			* 2432 MHz [5] (0.0 dBm)
			* 2437 MHz [6] (0.0 dBm)
			* 2442 MHz [7] (0.0 dBm)
			* 2447 MHz [8] (0.0 dBm)
			* 2452 MHz [9] (0.0 dBm)
			* 2457 MHz [10] (0.0 dBm)
			* 2462 MHz [11] (0.0 dBm)
			* 2467 MHz [12] (0.0 dBm)
			* 2472 MHz [13] (0.0 dBm)

Looks fine apart from the power levels so it made me wonder if what I am 
doing is allowed. Any opinion on this?

I assume the supported band info is intended to show what hardware can 
do regardless of the configured country, but I have no way to pull that 
info from the device.

Regards,
Arend
