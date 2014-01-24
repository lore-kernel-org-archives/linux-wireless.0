Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:45990 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaAXR0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 12:26:48 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Sujith Manoharan <sujith@msujith.org>
Subject: IBSS can't beacon after rejoin / regression in TSF syncing code?
Date: Fri, 24 Jan 2014 18:26:44 +0100
Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201401241826.45121.sw@simonwunderlich.de> (sfid-20140124_182651_807317_35B14967)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith and list(s),

we have found a regression in the IBSS creation/joining part of mac80211 which 
is appearently connected to the TSF-syncing patches introduced last year[1]. 
It prevents beaconing of an adhoc member after rejoining a cell when this cell 
is currently empty. The problem is present in at least 3.10 and 3.13.

To reproduce, use two adhoc peers and let them join/leave in the following 
order:

station 1: join
station 2: join
station 2: leave
station 1: leave
station 1: join

now we would expect that station 1 sends beacons, but it doesn't. After 
inspecting the code, station 1 actually selected the "old" ibss network and 
waits for a beacon to sync the tsf which is never received, as all members 
already left the network. An easy workaround is to set the IBSS creator always 
to true.

Since this kind of "race condition" could be solved in various ways, e.g. a 
timeout in ibss code, timeout in ath9k, ... i'd like to hear your opinions or 
ideas how to fix it.

Thanks,
    Simon


[1] mac80211: Notify new IBSS network creation 
(c13a765bd96f4e2f52d218ee6e5c0715380eeeb8)
ath9k: Fix IBSS joiner mode (1a6404a1d8497692f31808319d662c739033c491)

[2] actual commands I used:
iw dev wlan0 ibss join "rejointest" 5180 HT40+ fixed-freq 02:de:ad:be:ee:ef
iw dev wlan0 ibss leave

