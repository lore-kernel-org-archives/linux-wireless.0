Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:32955 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZXT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 19:19:27 -0400
Received: by pzk37 with SMTP id 37so1632346pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 16:19:27 -0700 (PDT)
From: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
To: jouni@qca.qualcomm.com
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: [PATCH v5 0/4] hostapd: Add ACS support
Date: Tue, 26 Jul 2011 16:19:18 -0700
Message-Id: <1311722362-4070-1-git-send-email-lrodriguez@qca.qualcomm.com> (sfid-20110727_011931_443941_325F5773)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v5 addresses some shortcomings with the original
logarithmic computations where the long double did not
suffice for surveys with a lot of noise. We cap the
values now and also use logarithm identities to simplify
the computations. The license is also now following the
license of the other files in place.

With this I get:

mcgrof@mouche ~/hostap/hostapd (git::master)$ grep acs /home/mcgrof/wpa/hostapd.conf
channel=acs_survey
acs_num_req_surveys=5
acs_roc_duration_ms=5

mcgrof@mouche ~/hostap/hostapd (git::master)$ sudo ./hostapd /home/mcgrof/wpa/hostapd.conf 
Configuration file: /home/mcgrof/wpa/hostapd.conf
ACS: automatic channel selection started, this may take a bit
ACS: Ideal chan: 149 (5745 MHz) Average interference factor: -4.000000
Using interface wlan0 with hwaddr 00:03:7f:11:a3:f3 and ssid 'pogo'

I have verified the results by using the acs.git code:
mcgrof@mouche ~/acs (git::master)$ sudo ./acs wlan0
wlan0: remain on freq: 2412 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 2417 MHz, duration: 5ms, cookie f73b2280, completed: yes
wlan0: remain on freq: 2422 MHz, duration: 5ms, cookie f73b2280, completed: yes
wlan0: remain on freq: 2427 MHz, duration: 5ms, cookie f73b2880, completed: yes
wlan0: remain on freq: 2432 MHz, duration: 5ms, cookie f73b2880, completed: yes
wlan0: remain on freq: 2437 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 2442 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 2447 MHz, duration: 5ms, cookie f73b2880, completed: yes
wlan0: remain on freq: 2452 MHz, duration: 5ms, cookie f73b2880, completed: yes
wlan0: remain on freq: 2457 MHz, duration: 5ms, cookie f73b2f80, completed: yes
wlan0: remain on freq: 2462 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 5180 MHz, duration: 5ms, cookie f73b2f80, completed: yes
wlan0: remain on freq: 5200 MHz, duration: 5ms, cookie f73b2b80, completed: yes
wlan0: remain on freq: 5220 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 5240 MHz, duration: 5ms, cookie f73b2b80, completed: yes
wlan0: remain on freq: 5260 MHz, duration: 5ms, cookie e72a7400, completed: yes
wlan0: remain on freq: 5280 MHz, duration: 5ms, cookie f73b2b80, completed: yes
...etc...
   10 surveys for 2412 MHz: 10.000000 10.000000 10.000000 10.000000 9.000000 10.000000 10.000000 10.000000 10.000000 10.000000 
   10 surveys for 2417 MHz: 10.000000 10.000000 10.000000 10.000000 10.000000 9.000000 10.000000 10.000000 9.000000 10.000000 
   10 surveys for 2422 MHz: 9.000000 8.000000 9.000000 9.000000 9.000000 9.000000 9.000000 9.000000 9.000000 9.000000 
   10 surveys for 2427 MHz: 9.000000 11.000000 10.000000 10.000000 10.000000 10.000000 10.000000 9.000000 11.000000 9.000000 
   10 surveys for 2432 MHz: 10.000000 10.000000 10.000000 10.000000 10.000000 10.000000 9.000000 10.000000 10.000000 10.000000 
   10 surveys for 2437 MHz: 8.000000 9.000000 9.000000 10.000000 9.000000 9.000000 9.000000 9.000000 10.000000 9.000000 
   10 surveys for 2442 MHz: 9.000000 9.000000 8.000000 8.000000 9.000000 9.000000 9.000000 9.000000 9.000000 10.000000 
   10 surveys for 2447 MHz: 11.000000 11.000000 11.000000 11.000000 10.000000 12.000000 10.000000 10.000000 10.000000 11.000000 
   10 surveys for 2452 MHz: 8.000000 9.000000 9.000000 9.000000 9.000000 9.000000 9.000000 9.000000 8.000000 9.000000 
   10 surveys for 2457 MHz: 9.000000 10.000000 10.000000 9.000000 10.000000 10.000000 10.000000 9.000000 10.000000 9.000000 
   10 surveys for 2462 MHz: 9.000000 9.000000 9.000000 9.000000 9.000000 10.000000 9.000000 9.000000 9.000000 9.000000 
   10 surveys for 5180 MHz: 1.000000 0.000000 0.000000 1.000000 1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 
   10 surveys for 5200 MHz: 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 
   10 surveys for 5220 MHz: 2.000000 1.000000 2.000000 1.000000 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 
   10 surveys for 5240 MHz: 2.000000 2.000000 2.000000 2.000000 2.000000 2.000000 1.000000 2.000000 2.000000 2.000000 
   10 surveys for 5260 MHz: 3.000000 3.000000 3.000000 2.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 
   10 surveys for 5280 MHz: 4.000000 4.000000 4.000000 4.000000 4.000000 4.000000 1.000000 3.000000 2.000000 2.000000 
   10 surveys for 5300 MHz: 2.000000 2.000000 2.000000 1.000000 1.000000 2.000000 1.000000 2.000000 1.000000 1.000000 
   10 surveys for 5320 MHz: 3.000000 3.000000 2.000000 3.000000 2.000000 3.000000 3.000000 3.000000 3.000000 3.000000 
   10 surveys for 5745 MHz: -2.000000 -2.000000 -2.000000 -1.000000 -1.000000 -1.000000 -1.000000 -2.000000 -2.000000 -2.000000 
   10 surveys for 5765 MHz: 1.000000 0.000000 1.000000 1.000000 1.000000 1.000000 0.000000 1.000000 0.000000 1.000000 
   10 surveys for 5785 MHz: -1.000000 -1.000000 0.000000 0.000000 0.000000 -1.000000 -1.000000 0.000000 0.000000 -1.000000 
   10 surveys for 5805 MHz: -1.000000 -1.000000 -1.000000 0.000000 0.000000 -1.000000 0.000000 -1.000000 0.000000 0.000000 
   10 surveys for 5825 MHz: -1.000000 -1.000000 -1.000000 -1.000000 -2.000000 -1.000000 -1.000000 -1.000000 -2.000000 -1.000000 
2412 MHz: 9.900000
2417 MHz: 9.800000
2422 MHz: 8.900000
2427 MHz: 9.900000
2432 MHz: 9.900000
2437 MHz: 9.100000
2442 MHz: 8.900000
2447 MHz: 10.700000
2452 MHz: 8.800000
2457 MHz: 9.600000
2462 MHz: 9.100000
5180 MHz: 0.600000
5200 MHz: 2.000000
5220 MHz: 1.800000
5240 MHz: 1.900000
5260 MHz: 2.800000
5280 MHz: 3.200000
5300 MHz: 1.500000
5320 MHz: 2.800000
5745 MHz: -1.600000
5765 MHz: 0.700000
5785 MHz: -0.500000
5805 MHz: -0.500000
5825 MHz: -1.200000
Ideal freq: 5745 MHz

Luis R. Rodriguez (4):
  hostapd: split up channel checking into helpers
  hostapd: add offchannel support
  hostapd: add survey dump support
  hostapd: add Automatic Channel Selection (ACS) support

 hostapd/Makefile             |   12 +
 hostapd/config_file.c        |   47 +++++-
 hostapd/defconfig            |   25 +++
 hostapd/hostapd.conf         |   17 ++
 src/ap/acs.c                 |  460 ++++++++++++++++++++++++++++++++++++++++++
 src/ap/acs.h                 |   40 ++++
 src/ap/ap_config.c           |   15 ++
 src/ap/ap_config.h           |    4 +
 src/ap/ap_drv_ops.h          |   26 +++
 src/ap/drv_callbacks.c       |  138 +++++++++++++
 src/ap/hostapd.c             |    2 +
 src/ap/hostapd.h             |   24 +++
 src/ap/hw_features.c         |  188 +++++++++++------
 src/drivers/driver.h         |  171 ++++++++++++++++-
 src/drivers/driver_nl80211.c |  193 ++++++++++++++++++
 15 files changed, 1292 insertions(+), 70 deletions(-)
 create mode 100644 src/ap/acs.c
 create mode 100644 src/ap/acs.h

-- 
1.7.4.15.g7811d

