Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:49281 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZIUHrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 03:47:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] nl80211: introduce NL80211_ATTR_SCAN_EXPIRE
Date: Mon, 21 Sep 2009 09:46:19 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
References: <200909181849.22302.hs4233@mail.mn-solutions.de> <200909210842.59852.hs4233@mail.mn-solutions.de> <1253517333.4458.7.camel@johannes.local>
In-Reply-To: <1253517333.4458.7.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909210946.19675.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It's not actually the same, and you didn't explain that well.
> You care about the disappear case, but you made it sound like
> you cared about the _reappear_ case.

Okay, sorry. I thought you read my other mails about 
scan-life-time and that thus the context was/is clear.


The base issue is: SCAN_TRIGGER does normally not a "clean scan", 
it normally adds entries to the BSS list or updates existing 
ones.

Entries in the BSS list are only deleted after 15 seconds.



However, in 15 seconds you can easily leave the range of AP_OLD 
and be in the range of a completely AP_NEW. But it can also be 
the case that the (now stale!) signal of AP_OLD is higher than 
the (real) signal of AP_NEW. In this case wpa_supplicant tries 
to associate to AP_OLD, which is out-of-sight. And that takes 
unneeded time.


I simple tried to mimick this scenario in the office, by 
switching off an AP (just that I didn't really switch it off, 
because the boot-times of Cisco-APs are soooooooo sloooooow).

About your "It's not actually the same": I think that my 
laboratory experiment very well shows this behavior, e.g. see my 
2nd message with subject "Life-time of scan-results?":

1253275108.958746: Trying to authenticate with 00:13:19:80:da:30 
(SSID='MNHS' freq=2412 MHz)

Bit this is the "vanished" AP_OLD. With wireshark on a second 
WLAN card I saw the attemps of mac80211 to associate to this 
now-out-of-sight AP. This takes some tries from mac80211, then a 
timeout on wpa_supplicant, than a new scan, then a new attempt. 
All of those delays completely unnecessary if there would have 
been a way to not get stale data via SCAN_DUMP.



So, clearly I have a visible problem and need to fix that.

I could fix that by making SCAN_TRIGGER always delete all stale 
(cached) entries. Then I wouldn't need NL80211_ATTR_SCAN_EXPIRE.

However, a scan because "I want to look what is around" might be 
different to a scan because "I need fresh data of APs around for 
associating". And so I thought I make that configurable.


I hope this now makes more sense.
