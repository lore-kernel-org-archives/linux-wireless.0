Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:47924 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbYHRQs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 12:48:27 -0400
Received: from a88-112-108-69.elisa-laajakaista.fi ([88.112.108.69] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KV7rp-0002wp-TC
	for linux-wireless@vger.kernel.org; Mon, 18 Aug 2008 09:46:08 -0700
Date: Mon, 18 Aug 2008 19:47:42 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: Userspace client MLME and BSSID-mismatch filtering for scans
Message-ID: <20080818164741.GA4809@jm.kir.nu> (sfid-20080818_184834_494434_721ABD0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get userspace client MLME working again and the next
blocker seems to be in Probe Response frames being dropped during
scanning (prepare_for_handlers() rejects frame due to BSSID mismatch
when "not in scan" (which is currently defined as kernel MLME or hw
scan).

I can workaround this with the patch below, but I would assume there are
some consequences in doing this (at least as far as CPU use is
concerned). Would there be a better way of doing this? Should I add yet
another parameter (like sdata->flags IEEE80211_SDATA_USERSPACE_MLME) for
indicating another type of scan (userspace MLME scanning) and get
wpa_supplicant setting that around scan operations? That would get
rx->flags IEEE80211_RX_IN_SCAN set in __ieee80211_rx_handle_packet and
consequently, would likely allow the ProbeResp frames to be received in
this case.

Any preferences or comments on this?



Index: wireless-testing/net/mac80211/rx.c
===================================================================
--- wireless-testing.orig/net/mac80211/rx.c
+++ wireless-testing/net/mac80211/rx.c
@@ -1828,7 +1828,8 @@ static int prepare_for_handlers(struct i
 		if (!bssid)
 			return 0;
 		if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid)) {
-			if (!(rx->flags & IEEE80211_RX_IN_SCAN))
+			if (!(rx->flags & IEEE80211_RX_IN_SCAN) &&
+			    !(sdata->flags & IEEE80211_SDATA_USERSPACE_MLME))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!multicast &&

-- 
Jouni Malinen                                            PGP id EFC895FA
