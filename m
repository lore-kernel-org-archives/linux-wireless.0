Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:56131 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYFQP7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 11:59:04 -0400
Message-Id: <20080617154008.883383150@localhost> (sfid-20080617_175912_673335_B33F2037)
Date: Tue, 17 Jun 2008 18:40:08 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first and still quite preliminary version of changes to
introduce IEEE 802.11w (management frame protection) support into
mac80211. As such, I'm mainly looking for comments on the current
design to help me in finalizing and cleaning up the patches.

Please note that couple of small additions to hostapd and wpa_supplicant
are required to actually configure MFP and those are not yet included in
the hostap git repository. Consequently, this is not yet available for
real testing. Or well, if you really want to test this now, I can send
an experimental patch to hostapd/wpa_supplicant to enable MFP support.

The current version is relatively complete for mac80211, but there are
still couple of known missing functions and I've done only very
limited testing so far. I was able to send and receive both CCMP and
BIP protected deauthentication frames and based on a sniffer log, the
frames looked correct. All this is with mac80211_hwsim and software
crypto. It is unclear whether this can be used as-is with devices that
use hwaccel for crypto at least before the low-level drivers and/or
firmware have been modified to cope with the possibility of CCMP being
used with management frames.

This patch set does not address the issues found in configuring default
keys for monitor interfaces, i.e., this still needs a workaround in
hostapd to set IGTK for both wlan# and mon.wlan#. In addition, the
debugfs directory is left behind when the monitor interface is removed.

Since IEEE 802.11w draft is still in progress and open to changes, it is
also unclear whether we would actually like to introduce IEEE 802.11w
support as-is into mac80211 in main line kernels at this point. Then
again, IEEE 802.11w draft is quite a bit further in the standardization
process than IEEE 802.11s draft and we already have some pre-standard
mesh support in mac80211 at least in wireless-testing.

-- 
Jouni Malinen                                            PGP id EFC895FA
