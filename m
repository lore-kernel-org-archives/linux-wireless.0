Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:35693 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbZGUWbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 18:31:42 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <hostap@shmoo.com>
Subject: Slow roaming in mac80211 (2.6.30).
Date: Tue, 21 Jul 2009 23:21:23 +0200
Message-ID: <1B3FCF72EBBC44A39F5A80B8FFBF6402@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Johannes,

I'm currently using the 2.6.26 kernel and have started evaluating the
2.6.30.  

For .26 I have made a few patches to fix minor issues related to
roaming.  

The trace below shows a typical roaming:
87.632965	AP 1 drops STA
87.733979	wpa_supplicant trigs a scan
88.629931	mac80211 probes for the old AP	
90.670305	SCAN result to wpa_supplicant
90.702325	wpa_supplicant ready with new AP
92.158037	mac80211 executes the wpa_supplicant decisions
92.164776	we are on line again

Total roaming time is 4,5 seconds, where mac80211 had added 2*2
seconds delay.

A first analysis gives that the two delays are the ieee80211_sta_work()
timeout.  There are many events trigging ieee80211_sta_work(), but
since only the timer sets IEEE80211_STA_REQ_RUN, nothing will happen.

Questions; 
- Why does mac80211 tells the wpa_supplicant that the AP
is gone (87.632965), and then blocks/delays the actions taken by the
wpa_supplicant?  
- Why are some wpa_supplicant actions (90.702325)
not event driven?

It looks to me as if we have to decision makers here. For me the
wpa_supplicant is the one that make the decision. Once the mac80211
gives up and feedback that the AP is gone, it should just sit 
and wait for next decision from the wpa_supplicant.

I had a few patches for this for .26, but since the code is changed
they do not apply. Before I create new patches I would like to get
your opinion on this.

Regards
/Lars
  
-----
[   87.632965] wlan0: deauthenticated (Reason: 1)
[   87.733979] [B] LaE: SCANRQUEST: SSID=AGV
[   88.629931] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 1
[   88.829932] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 2
[   89.029944] wlan0: direct probe to AP 00:40:96:a0:e7:e7 try 3
[   89.230016] wlan0: direct probe to AP 00:40:96:a0:e7:e7 timed out
[   90.670305] [B] LaE: SCANRESULT: BSSID=00:40:96:a0:e7:e7, SSID=
, ch= 1, , q=  0, l=  0(-30dBm), n=  0
[   90.670384] [B] LaE: SCANRESULT: BSSID=00:08:21:31:53:87, SSID=
, ch=11, , q=  0, l=  0(-62dBm), n=  0
[   90.670455] [B] LaE: SCANRESULT: BSSID=00:08:21:31:53:87, SSID=AGV
, ch=11, , q=  0, l=  0(-60dBm), n=  0
[   90.670705] ieee80211_ioctl_siwauth: enter
[   90.670777] ieee80211_ioctl_siwencodeext: enter
[   90.670807] ieee80211_set_encryption: enter
[   90.671128] ieee80211_ioctl_siwencodeext: enter
[   90.671165] ieee80211_set_encryption: enter
[   90.671219] ieee80211_ioctl_siwencodeext: enter
[   90.671247] ieee80211_set_encryption: enter
[   90.671297] ieee80211_ioctl_siwencodeext: enter
[   90.671325] ieee80211_set_encryption: enter
[   90.671375] ieee80211_ioctl_siwencodeext: enter
[   90.671404] ieee80211_set_encryption: enter
[   90.671623] ieee80211_ioctl_siwencodeext: enter
[   90.671659] ieee80211_set_encryption: enter
[   90.672062] ieee80211_ioctl_siwauth: enter
[   90.672295] ieee80211_ioctl_siwgenie: enter
[   90.672332] ieee80211_sta_req_auth: queue auth
[   90.672380] ieee80211_ioctl_siwauth: enter
[   90.672420] ieee80211_ioctl_siwauth: enter
[   90.672458] ieee80211_ioctl_siwauth: enter
[   90.672495] ieee80211_ioctl_siwauth: enter
[   90.672532] ieee80211_ioctl_siwauth: enter
[   90.672569] ieee80211_ioctl_siwauth: enter
[   90.672612] ieee80211_ioctl_siwfreq: enter freq=246200000
[   90.702175] ieee80211_ioctl_siwessid: enter ssid=AGV
[   90.702217] ieee80211_sta_req_auth: queue auth
[   90.702325] ieee80211_ioctl_siwap: enter AP=00:08:21:31:53:87
[   90.702372] ieee80211_sta_req_auth: queue auth
[   92.158037] wlan0: authenticate with AP 00:08:21:31:53:87
[   92.159965] wlan0: authenticated
[   92.160002] wlan0: associate with AP 00:08:21:31:53:87
[   92.164733] wlan0: RX ReassocResp from 00:08:21:31:53:87 (capab=0x431
status=0 aid=140)
[   92.164776] wlan0: associated
[   92.166984] ieee80211_ioctl_giwap: enter

-----

