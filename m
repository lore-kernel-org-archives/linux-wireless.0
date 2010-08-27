Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34774 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892Ab0H0TVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 15:21:23 -0400
Date: Fri, 27 Aug 2010 22:21:13 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix signal strength average initialization for
 CQM events
Message-ID: <20100827192113.GA28502@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ave_beacon_signal value uses 1/16 dB unit and as such, must be
initialized with the signal level of the first Beacon frame multiplied
by 16. This fixes an issue where the initial CQM events are reported
incorrectly with a burst of events while the running average
approaches the correct value after the incorrect initialization. This
could cause user space -based roaming decision process to get quite
confused at the moment when we would like to go through authentication
and DHCP.

Cc: stable@kernel.org
Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2010-08-27 15:48:14.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2010-08-27 21:43:54.000000000 +0300
@@ -1548,7 +1548,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	ifmgd->last_beacon_signal = rx_status->signal;
 	if (ifmgd->flags & IEEE80211_STA_RESET_SIGNAL_AVE) {
 		ifmgd->flags &= ~IEEE80211_STA_RESET_SIGNAL_AVE;
-		ifmgd->ave_beacon_signal = rx_status->signal;
+		ifmgd->ave_beacon_signal = rx_status->signal * 16;
 		ifmgd->last_cqm_event_signal = 0;
 	} else {
 		ifmgd->ave_beacon_signal =

-- 
Jouni Malinen                                            PGP id EFC895FA
