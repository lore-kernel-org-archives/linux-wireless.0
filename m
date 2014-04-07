Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:55677 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGKLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 06:11:54 -0400
Received: from smtp01.msg.oleane.net (smtp01.mail.priv [172.17.20.110])
	by smtp-out04.msg.oleane.net with ESMTP id s379ox2U030325
	for <linux-wireless@vger.kernel.org>; Mon, 7 Apr 2014 11:50:59 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp01.msg.oleane.net (MTA) with ESMTP id s379UdRx017158
	for <linux-wireless@vger.kernel.org>; Mon, 7 Apr 2014 11:30:39 +0200
Subject: [MAC80211] Radar detection management issue
Date: Mon, 7 Apr 2014 11:30:38 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319017342EF@sbs2003.acksys.local> (sfid-20140407_121158_359566_C3005B70)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	I'm doing some tests in 802.11a with ath9k driver and I found a
strange behavior.

	With iw phy0 info, I check the regulation rules. I can see some
channels needs radar detection. For test I set an AP on this channel and
I can see the beacon with wireshark. But ATH9K doesn't support radar
detection, so these channels should be disabled.

	I think the problem is on MAC80211 layer. In /net/wireless/reg.c
the function map_regdom_flags set the flags IEEE80211_CHAN_RADAR if the
regulatory domain set NL80211_RRF_DFS.
	But ATH9K doesn't support the radar detection, and I don't found
in MAC80211 a test on this capability.

	I only found a capabilities in ATH9K (ATH9K_HW_CAP_DFS), but
this flag is set and not used.

	I don't know how fix this issue. For the moment I disable the
channel when the NL80211_RRF_DFS is set (in map_regdom_flags).

Cedric Voncken 

