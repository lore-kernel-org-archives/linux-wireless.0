Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sysgo.com ([195.145.229.155]:39745 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab0JZKyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 06:54:47 -0400
Date: Tue, 26 Oct 2010 12:48:11 +0200
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>,
	chunkeey@googlemail.com, linux-wireless@vger.kernel.org
Subject: carl9170 disconnects under load
Message-ID: <20101026104811.GA11357@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm testing driver from -wireless testing, cca 2.6.26-rc7.

It seems to work (up to 802.11n speeds -- I've seen iwconfig claiming
121 MB/sec), but disconnects rather quickly when under load:

telnet 192.168.1.3 chargen > /dev/null

The machine is powerpc mpc5200b board, with OHCI driver -- it is not
capable of USB2.0 speeds.

Any ideas?
								Pavel

wlan0: RX AssocResp from 00:23:f8:5d:76:93 (capab=0xc21 status=0
aid=1)
wlan0: associated
ieee80211 phy2: Allocated STA 00:23:f8:5d:76:93
ieee80211 phy2: Inserted STA 00:23:f8:5d:76:93
ieee80211 phy2: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023
txop=0 uapsd=0
ieee80211 phy2: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023
txop=0 uapsd=0
ieee80211 phy2: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15
txop=94 uapsd=0
ieee80211 phy2: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
uapsd=0
Open BA session requested for 00:23:f8:5d:76:93 tid 0
activated addBA response timer on tid 0
switched off addBA timer for tid 0
Aggregation is on for tid 0
Rx A-MPDU request on tid 0 result 0
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
net_ratelimit: 79 callbacks suppressed
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
net_ratelimit: 58 callbacks suppressed
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
ieee80211 phy2: release an RX reorder frame due to timeout on earlier
frames
usb 1-1: USB disconnect, address 6
Tx BA session stop requested for 00:23:f8:5d:76:93 tid 0
Rx BA session stop requested for 00:23:f8:5d:76:93 tid 0
wlan0: deauthenticating from 00:23:f8:5d:76:93 by local choice
(reason=3)
Tx BA session stop requested for 00:23:f8:5d:76:93 tid 0
ieee80211 phy2: Removed STA 00:23:f8:5d:76:93
ieee80211 phy2: Destroyed STA 00:23:f8:5d:76:93
ieee80211 phy2: device now idle
