Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34506 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbZKHUiy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 15:38:54 -0500
Received: by vs166246.vserver.de with esmtpa (Exim 4.69)
	id 1N7EXK-0006lG-V6
	for linux-wireless@vger.kernel.org; Sun, 08 Nov 2009 20:38:59 +0000
From: Michael Buesch <mb@bu3sch.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Flaky connection on b43
Date: Sun, 8 Nov 2009 21:37:46 +0100
MIME-Version: 1.0
Message-Id: <200911082137.47096.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The connection is pretty flaky in b43 on wireless-testing.
There seems to be some rekeying issue. See the log below and notice
the dropped packets after the rekeying.
Note that I have a short rekeying interval on my AP, so rekeying happens often.
Any ideas? Possible bug in mac80211? Does somebody see this with other hardware?


[76975.830202] wlan0: associated
[76975.937851] b43-phy5 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[76975.939981] b43-phy5 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[77761.827812] b43-phy5 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[77875.951220] b43-phy5 debug: Disabling hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[77875.952590] b43-phy5 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[77875.954108] b43-phy5 debug: Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[77875.956166] b43-phy5 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[77876.051452] b43-phy5 debug: RX: Packet dropped
[77877.052824] b43-phy5 debug: RX: Packet dropped
[77878.054659] b43-phy5 debug: RX: Packet dropped
[77879.053856] wlan0: deauthenticated from 00:1d:0f:b9:df:2d (Reason: 2)
[77879.056611] b43-phy5 debug: Disabling hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[77879.058366] b43-phy5 debug: Disabling hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff
[77879.059675] b43-phy5 debug: Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[77880.245052] wlan0: direct probe to AP 00:1d:0f:b9:df:2d (try 1)
[77880.248383] wlan0: direct probe responded
[77880.249491] wlan0: authenticate with AP 00:1d:0f:b9:df:2d (try 1)
[77880.252066] wlan0: authenticated
[77880.253193] wlan0: associate with AP 00:1d:0f:b9:df:2d (try 1)
[77880.256870] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=1)
[77880.258231] wlan0: associated
[77880.365791] b43-phy5 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[77880.367984] b43-phy5 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[78780.371370] b43-phy5 debug: Disabling hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[78780.372773] b43-phy5 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[78780.374583] b43-phy5 debug: Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[78780.375915] b43-phy5 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[78780.471554] b43-phy5 debug: RX: Packet dropped
[78781.472872] b43-phy5 debug: RX: Packet dropped
[78782.474189] b43-phy5 debug: RX: Packet dropped
[78783.473891] wlan0: deauthenticated from 00:1d:0f:b9:df:2d (Reason: 2)
[78783.476282] b43-phy5 debug: Disabling hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[78783.477961] b43-phy5 debug: Disabling hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[78784.661586] wlan0: direct probe to AP 00:1d:0f:b9:df:2d (try 1)
[78784.664937] wlan0: direct probe responded
[78784.666073] wlan0: authenticate with AP 00:1d:0f:b9:df:2d (try 1)
[78784.668733] wlan0: authenticated
[78784.669863] wlan0: associate with AP 00:1d:0f:b9:df:2d (try 1)
[78784.673479] wlan0: RX ReassocResp from 00:1d:0f:b9:df:2d (capab=0x411 status=0 aid=1)
[78784.674860] wlan0: associated
[78784.782422] b43-phy5 debug: Using hardware based encryption for keyidx: 0, mac: 00:1d:0f:b9:df:2d
[78784.784936] b43-phy5 debug: Using hardware based encryption for keyidx: 2, mac: ff:ff:ff:ff:ff:ff
[78961.814261] b43-phy5 debug: Using hardware based encryption for keyidx: 1, mac: ff:ff:ff:ff:ff:ff

-- 
Greetings, Michael.
