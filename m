Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16315 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbZIVJS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 05:18:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP and WPA
Date: Tue, 22 Sep 2009 11:18:04 +0200
Cc: hostap@lists.shmoo.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909221118.04569.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Management abstrace: NL80211 is now much butter then WEXT :-)


wireless-testing GIT with the "don't overwrite security" patch
and wpa_supplicant git.

I made logs with

script -c "./wpa_supplicant -i eth1 -D nl80211 -t -c wpa.conf -d" wext_nl80211
script -c "./wpa_supplicant -i eth1 -D nl80211 -t -c wpa.conf -d" wpa_nl8021
script -c "./wpa_supplicant -i eth1 -D wext    -t -c wep.conf -d" wep_wext
script -c "./wpa_supplicant -i eth1 -D wext    -t -c wep.conf -d" wep_wext


Then I wrote a little python script to sift throught the weeds,
extract interesting events and get me the time since start and
time since previous event.

Some of those "interesting" events are further marked as
"##ERROR" to stand out from the log.


wep_wext
--------
 0.00000  0.00000: Initializing interface ...
 0.08801  0.08801: Setting scan request: 0 sec 100000 usec
 0.25167  0.16365: ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
 0.25171  0.00005: ##ERROR: Failed to get scan results
 0.25172  0.00001: ##ERROR: Failed to get scan results - try scanning again
 0.25173  0.00001: Setting scan request: 0 sec 0 usec
 0.25176  0.00003: ioctl[SIOCSIWSCAN]: Device or resource busy
 0.25179  0.00003: ##ERROR: Failed to initiate AP scan.
 0.25180  0.00001: Setting scan request: 10 sec 0 usec
 3.07458  2.82278: CTRL-EVENT-CONNECTED - Connection to 00:1b:d4:44:35:90 completed (auth) [id=0 id_str=]


wep_nl80211
-----------
 0.00000  0.00000: Initializing interface ...
 0.03985  0.03985: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.03992  0.00007: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.03998  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.04004  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.04008  0.00004: Setting scan request: 0 sec 100000 usec
 0.14061  0.10053: Received scan results (0 BSSes)
 0.14070  0.00009: Setting scan request: 0 sec 0 usec
 0.78813  0.64743: Received scan results (5 BSSes)
 0.78853  0.00040: Trying to authenticate with 00:1b:53:11:dc:40 (SSID='MNFUNK' freq=2412 MHz)
 0.78888  0.00034: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.96270  0.17382: SME: Authentication response: peer=00:1b:53:11:dc:40 auth_type=0 status_code=0


wpa_wext
--------
 0.00000  0.00000: Initializing interface ...
 0.07409  0.07409: Setting scan request: 0 sec 100000 usec
 0.24986  0.17576: ioctl[SIOCGIWSCAN]: Resource temporarily unavailable
 0.24990  0.00004: ##ERROR: Failed to get scan results
 0.24991  0.00001: ##ERROR: Failed to get scan results - try scanning again
 0.24991  0.00001: Setting scan request: 0 sec 0 usec
 0.24995  0.00003: ioctl[SIOCSIWSCAN]: Device or resource busy
 0.24998  0.00003: ##ERROR: Failed to initiate AP scan.
 0.24998  0.00001: Setting scan request: 10 sec 0 usec
 3.15609  2.90611: CTRL-EVENT-CONNECTED - Connection to 00:1b:d4:44:35:90 completed (auth) [id=0 id_str=]


wpa_nl80211
-----------
 0.00000  0.00000: Initializing interface ...
 0.07400  0.07400: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.07406  0.00007: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.07413  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.07419  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
 0.07424  0.00005: Setting scan request: 0 sec 100000 usec
 0.17475  0.10052: Received scan results (0 BSSes)
 0.17485  0.00009: Setting scan request: 0 sec 0 usec
 0.67432  0.49947: Received scan results (3 BSSes)
 0.67463  0.00032: Trying to authenticate with 00:1b:d4:44:35:90 (SSID='MNWPA' freq=2412 MHz)
 0.81141  0.13678: SME: Authentication response: peer=00:1b:d4:44:35:90 auth_type=0 status_code=0
 0.98805  0.17664: CTRL-EVENT-CONNECTED - Connection to 00:1b:d4:44:35:90 completed (auth) [id=0 id_str=]


For those tests, it was needed to rmmod mac80211 & friends
between those test, because otherwise connection could take up to
15 seconds.

We've quite a number of errors.

Also, NL80211 is usually faster connecting one than WEXT.

I can't say if this is a property of NL80211, it might also be
because COMPAT-WEXT has still some bugs and produces more errors,
making wpa_supplicant do excessive scanning.



-- 
http://www.holgerschurig.de
