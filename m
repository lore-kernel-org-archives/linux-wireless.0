Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:51274 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbbGCQv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 12:51:59 -0400
Message-ID: <5596BDAB.4020001@neratec.com> (sfid-20150703_185230_221212_0356E94E)
Date: Fri, 03 Jul 2015 18:51:55 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: Q: iw - how to scan for a specific ssid / AP mode scan
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Folks,

I have difficulties using iw for a specific use case or fail to understand the
documentation correctly.

My platform is a recent OpenWRT, running ath9k.

First use case is scanning for a given ssid in managed mode. According do iw's
documentation (and the attribute description in nl80211.h), issuing

iw dev wlan0 scan flush ssid <SSID>

should do exactly this, but I keep receiving a full list of visible APs. I double
checked that NL80211_SCAN_FLAG_FLUSH and NL80211_ATTR_SCAN_SSIDS are set
correctly, so am puzzled whether there is some bug left or I miss some detail.


The second issue is about scanning in AP mode. Where I want to go is having two
APs operating on arbitrary DFS channels with periodic scans to discover each
other. What I observe is
a) passive scanning: iw dev wlan0 scan flush ap-force passive
   => does not work - no scan results are provided
b) active scanning: iw dev wlan0 scan flush ap-force
  * finds only a subset of APs compared to a scan in managed mode
  * finds only APs on non-DFS channels

Again, I might be missing some relevant documentation, but to me the observed
results look rather like 'not yet implemented' than inherent limitations.


Any hint / feedback is appreciated.

Thanks,
Zefir
