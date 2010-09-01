Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lime.solrad.nl ([213.193.238.107]:58169 "EHLO lime.solrad.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0IAPcF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 11:32:05 -0400
Message-ID: <4C7E71F3.7000301@youcom.nl>
Date: Wed, 01 Sep 2010 17:32:03 +0200
From: Jelle Martijn Kok <jmkok@youcom.nl>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: mac80211 and powersaving
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(sorry if this mail is sent twice, but the first attempt was bounced due 
to html text)

I recently ran into trouble when using the RT73 with powersave enabled.
So I started to investigate the problem and saw the the powersave mode 
as it was implemented in de rt73usb driver could never function.
The rt73usb driver seems to switch to sleep on receival of the 
IEEE80211_CONF_CHANGE_PS flag, while it should only enable the powersave 
feature (and essentially, it would go to sleep immediatly).
However after the sleep period the rt73usb awakens for receival of a 
beacon, en then never goes back to sleep.

I discussed this issue with Ivo van Doorn (we discussed it in Dutch, so 
I won't be including it here) and he suggested to post the issue the to 
mailing list.

Assuming the powersave implementation of the RT73 is indeed incorrect, I 
would actually have the following question:
Should it not be best if the mac80211 would directly enable and disable 
the sleep modes of the hardware/driver.

I do realize that this might seriously change a lot of code, but:
- If the driver is responsible for going to and from sleep, it needs to 
have a notion of the contents of the packets it receives (as it only may 
go to sleep on a beacon without a "directed_tim"). And thus this would 
require the driver to implement a lot of code that is already present in 
the mac80211.
- It makes it much easier for drivers to support PS. The driver 
basically only need to implement a "sleep" and "awake" callback.
- Only 3 drivers seem to have a viable PS code (ath9k / iwlwifi / p54). 
However I only quickly scanned the code.
- All Ralink drivers seem to be similar to the rt73usb, that they only 
go to sleep once.

So, a quick (and very rough) idea:
- The driver should implement an "sleep" and "awake" function
- The driver should inform the mac80211 if it supports sleep and wake 
and tell if it can do this auto(nomous).
- If the driver cannot auto-sleep, the mac80211 should call the sleep 
callback (likely from "ieee80211_rx_mgmt_beacon()")
- If the driver cannot auto-wake, the mac80211 should start a timer to 
wake the driver
- Nullframes will normally also be handled by the mac80211 (unless 
otherwise specified by the driver)

This would allow almost any hardware to support (dynamic) PS, as all 
steps performed and managed by the mac80211.

Jelle Martijn Kok

