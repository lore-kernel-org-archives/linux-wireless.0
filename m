Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:36394 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbbDMQZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 12:25:11 -0400
Received: from RD9 ([195.6.104.67]) (authenticated)
	by smtp01.msg.oleane.net (MSA) with ESMTP id t3DGP8uU018183
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 18:25:09 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: [mac80211] 4-addresses mode: the AP does not detect the advertizing null data frame from the client
Date: Mon, 13 Apr 2015 18:25:08 +0200
Message-ID: <000f01d07606$68bccf30$3a366d90$@acksys.fr> (sfid-20150413_182515_862537_C8F0AAE5)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello list,

I am using compat-wireless-2014-11-04 and hostapd-2014-06-03 in an openwrt
environment.
I have set up a wpa_supplicant and an AP using Atheros chips. The supplicant
is set in 4-addresses mode. The AP is set to put its 4-addresses clients
into a bridge.

Symptom: the supplicant associates to the AP as expected. But from the AP it
is not possible to ping the PC connected behind the supplicant, until that
PC send something (an ARP or whatever data frame).
The reason I found is that hostapd does not put the 4-addr station in the
bridge.

I noticed that in mac80211/mlme.c the client station sends a null data frame
to inform the AP that it will use the 4-addresses format. On the AP, hostapd
logs show that it does not receive an event for this frame,  but it receives
a 4-addr event alright on a subsequent, real data frame.
I also noticed that in mac80211/rx.c the ieee80211_rx_h_sta_process()
function sends an event to userspace. But in the case of the first
null-data, the frame is trapped before, in ieee80211_rx_h_check(), in the
test of cfg80211_rx_spurious_frame().

So, though everything looks all set for the AP to detect its 4-addr client,
this does not occur if the client does not send real data.
- I tried to move the event generation code from
ieee80211_rx_h_sta_process() to ieee80211_rx_h_check(), but this does not
work, it looks like rx->sta does not exist yet at this point in the frame
processing.
- I tried to keep the 4-addr null-data by returning RX_CONTINUE in
ieee80211_rx_h_check() but the event is not generated either.
- I tried to use wpa-psk keys in the hope that the EAPOL frames 2 and 4
would be detected as 4-addr, but it looks like these frames are send in
3-addresses format by the supplicant (why?)

I'm stuck now.

Any ideas?



