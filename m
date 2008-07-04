Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:45425 "EHLO
	QMTA05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbYGDV4V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 17:56:21 -0400
Message-ID: <486EA910.80408@gentoo.org> (sfid-20080704_235624_726535_A49156D3)
Date: Fri, 04 Jul 2008 17:49:52 -0500
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: bruno@thinktube.com, vlado@work.ksp.sk
Subject: mac80211 ad-hoc problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to implement ad-hoc mode in zd1211rw. I partially succeeded 
and posted a patch, but now I'm trying to investigate why I had trouble 
getting my laptops to talk...

I'm running iwl4965 on one box and zd1211rw on another, both running 
2.6.26-rc8

I create the network on the iwl4965 system:
	iwconfig wlan0 mode ad-hoc
	ifconfig wlan0 up
	iwconfig wlan0 essid dev

And then I try to connect on the zd1211rw system:
	iwconfig wlan0 mode ad-hoc
	ifconfig wlan0 up
	iwconfig wlan0 essid dev

If that's not the right way to create an ad-hoc network between 2 
systems, please discard the rest of this email and instead tell me how 
it should be done...


After running the 3rd command on the zd1211rw system, this happens:

<7>eth7: sta_find_ibss (active_ibss=0)
<7>   bssid=66:18:74:24:c1:d8 found
<7>   sta_find_ibss: selected 66:18:74:24:c1:d8 current 00:00:00:00:00:00
<7>   did not try to join ibss
<7>eth7: Trigger new scan to find an IBSS to join
<7>phy5: HW CONFIG: freq=2412
<7>phy5: HW CONFIG: freq=2417
<7>phy5: HW CONFIG: freq=2422
<7>phy5: HW CONFIG: freq=2427
<7>phy5: HW CONFIG: freq=2432
<7>phy5: HW CONFIG: freq=2437
<7>phy5: HW CONFIG: freq=2442
<7>phy5: HW CONFIG: freq=2447
<7>phy5: HW CONFIG: freq=2452
<7>phy5: HW CONFIG: freq=2457
<7>phy5: HW CONFIG: freq=2462
<7>phy5: HW CONFIG: freq=2467
<7>phy5: HW CONFIG: freq=2472
<4>__ratelimit: 4 messages suppressed
<7>phy5: HW CONFIG: freq=2462
<7>eth7: sta_find_ibss (active_ibss=0)
<7>   bssid=66:18:74:24:c1:d8 found
<7>   sta_find_ibss: selected 66:18:74:24:c1:d8 current 00:00:00:00:00:00
<7>   did not try to join ibss
<7>phy5: Adding new IBSS station 00:16:6f:47:00:46 (dev=eth7)
<7>phy5: Allocated STA 00:16:6f:47:00:46
<7>phy5: Inserted STA 00:16:6f:47:00:46
<7>eth7: sta_find_ibss (active_ibss=0)
<7>   bssid=66:18:74:24:c1:d8 found
<7>   sta_find_ibss: selected 66:18:74:24:c1:d8 current 00:00:00:00:00:00
<7>   did not try to join ibss
<7>eth7: Trigger new scan to find an IBSS to join
<7>phy5: HW CONFIG: freq=2412
<7>phy5: HW CONFIG: freq=2417

and soon after it creates its own IBSS.

Should it not have joined the IBSS it found? That one 
(66:18:74:24:c1:d8) is indeed the network I wanted it to connect to, 
hosted on my other laptop.

Looking at the code, ieee80211_sta_find_ibss() in mlme.c, I can't see 
how it's supposed to work.  It's clear why it said it found the other 
network, because the ESSID matches. But it's also clear why it didn't 
actually bother to try and connect: the ieee80211_sta_join_ibss() call 
is surrounded in an if condition which checks the BSSID - but I 
(intentionally) didn't specify one, so the condition evaluates as false.

Is this a bug, or am I required to specify an ESSID *and* a BSSID in 
order to connect to a pre-existing IBSS network?

Thanks,
Daniel
