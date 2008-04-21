Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:38164 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYDUQEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 12:04:42 -0400
Received: from Relay2.suse.de (relay-ext.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 9124940B03
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 18:04:41 +0200 (CEST)
From: Helmut Schaa <hschaa@suse.de>
To: linux-wireless@vger.kernel.org
Subject: Question about IEEE80211_PROBE_DELAY
Date: Mon, 21 Apr 2008 18:04:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804211804.38060.hschaa@suse.de> (sfid-20080421_180539_631084_0CE5109B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was just playing around with the mac80211 scan-code and stumbled across 
IEEE80211_PROBE_DELAY. I'm a bit curious why this delay is needed due to the 
fact that any driver can set the channel_change_time to any value it needs.

Therefore I simply removed the IEEE80211_PROBE_DELAY (see below) and only used 
the channel_change_time exposed by the driver. I did some tests with the 
iwl4965 and ath5k (reports AR5213A as chipset) driver and did not notice any 
regression.

Could somebody explain to me if the IEEE80211_PROBE_DELAY is needed anymore 
and for which particular reason?

Thanks,
Helmut

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3853,8 +3853,7 @@ void ieee80211_sta_scan_work(struct work_struct *work)
 		if (skip)
 			break;
 
-		next_delay = IEEE80211_PROBE_DELAY +
-			     usecs_to_jiffies(local->hw.channel_change_time);
+		next_delay = usecs_to_jiffies(local->hw.channel_change_time);
 		local->scan_state = SCAN_SEND_PROBE;
 		break;
 	case SCAN_SEND_PROBE:
