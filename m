Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:54297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703AbXKIPTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 10:19:34 -0500
From: Helmut Schaa <hschaa@suse.de>
Subject: [PATCH 0/2] mac80211: Fix queuing of scan containing a SSID
Date: Fri, 9 Nov 2007 16:22:16 +0100
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711091622.16671.hschaa@suse.de> (sfid-20071109_151940_675785_EE7443F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first patch fixes scanning for specific ssid's which is broken due to the 
scan being queued up without respecting the ssid to scan for.

The second patch removes all references to local->scan_flags as these are not 
used anymore since the removal of prism2 ioctls (see [1]). This is related to 
the first patch because of the scan flag IEEE80211_SCAN_MATCH_SSID getting 
removed too.

I'm not sure if it makes sense to only return ssid's matching the one scanned 
for as it was done when using IEEE80211_SCAN_MATCH_SSID (at least for 
wpa_supplicant it doesn't matter). Nevertheless the flag can be dropped as we 
could simply check for local->scan_ssid_len instead.

[1] 
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=51617f0b76389b29740aa9d7736df99b75d1d9ec
