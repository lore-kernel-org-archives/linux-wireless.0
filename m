Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.gibraltar.at ([80.120.3.98]:56738 "EHLO
	mail1.gibraltar.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZJKTOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 15:14:34 -0400
Date: Sun, 11 Oct 2009 21:13:47 +0200
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	leitner@esys.at
From: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
Message-ID: <e193131e154b38ff58f37adc1acbf8ab@www.gibraltar.at>
In-Reply-To: <200909280956.23887.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody,
 
>> [ 1698.498801] ath: EEPROM regdomain: 0x0 
>> 
>> Does this indicate that the EEPROM is locked to country code
>> 0x0 (whatever that is, probably US)? "iw reg" doesn't seem to
>> change anything: 
> 
> Yep, that's the case.
> 
> However, "iw XXX reg set XX" should *STILL* change some things, 
> so I guess that crda/regdb isn't still correctly installed. And 
> you should still see something in your "dmesg" output. Hey, 
> even "COUNTRY=AT crda" should change/produce something, e.g. 
> check "dmesg" and "iw list".

After installing Ubuntu's wireless-crda package (which includes crda, the
regulatory.bin, and the udev rule), things started to work. One kernel
module update later, I was able to issue "iw reg set AT" manually and via
hostapd and it seems to do something - "iw reg get" now returns "country
98". This should now let me use channel 40 (5GHz band), which I will try
later on this week.
 
> Oh, and what I'm not yet getting: how can a wrong country setting 
> lead to so much packet-loss?

I can now confirm that the country setting was only a side issue that
prevented me from switching to the 5GHz band, but had nothing to do with the
massive packet loss issue. With or without the correct country setting, the
packet loss happened.


However, a (very) recent update seems to have solved this problem. While (if
I remember correctly) compat-wireless-2009-09-25 still caused the packet
loss, compat-wireless-2009-10-09 seems to be stable. With kernel 2.6.30.9
and compat-wireless-2009-10-09, scripts/driver-select set to "ath" and
loading the updated modules, I have now had a stable (nearly
packet-loss-free) connection for nearly 2h. This is a new record ;-) 
Unfortunately, the connection to a Linksys WUSB600N v2 in client mode at
about 1m distance from the miniPCI Atheros AR9280 with two antennas in
access point mode is still limited to a maximum of roughly 30MBit/s of
actual transfer rate as measured with iperf (the Windows client with Linksys
rt2870 drivers reports a connection speed of 270 to 300MBit/s). hostapd is
set to 

channel=6
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40]
wpa=3
wpa_passphrase=long...
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wme_enabled=1
#
# Low priority / AC_BK = background
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
# Note: for IEEE 802.11b mode: cWmin=5 cWmax=10
#
# Normal priority / AC_BE = best effort
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
# Note: for IEEE 802.11b mode: cWmin=5 cWmax=7
#
# High priority / AC_VI = video
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
# Note: for IEEE 802.11b mode: cWmin=4 cWmax=5 txop_limit=188
#
# Highest priority / AC_VO = voice
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0
# Note: for IEEE 802.11b mode: cWmin=3 cWmax=4 burst=102

Should the current ath9k code in access point be able to provide higher
throughput? The Linksys WUSB600N v2 is, according to multiple reviews,
capable of much more (which is the reason why I bought it as a test client).

On a side note, "rmmod cfg80211" causes a kernel BUG with subsequent network
subsystem instability independently of the module version (upstream
2.6.30.9, compat-wireless-2009-09-25 and 2009-10-09).

best regards,
Rene


