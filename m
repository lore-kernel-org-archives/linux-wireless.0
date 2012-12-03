Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45161 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2LCV1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 16:27:48 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH] mac80211: adapt slot time in IBSS mode
Date: Mon,  3 Dec 2012 22:21:30 +0100
Message-Id: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121203_222752_149139_4B7E2FFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In 5GHz/802.11a, we are allowed to use short slot times. Doing this
may increases performance by 20% for legacy connections (54 MBit/s).
I can confirm this in my tests (27% more throughput using iperf), and
also have a small positive effect (5% more throughput) for HT rates,
tested on 1 stream.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/ibss.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index fa862b2..1a5d29c 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -201,6 +201,19 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BASIC_RATES;
 	bss_change |= BSS_CHANGED_HT;
 	bss_change |= BSS_CHANGED_IBSS;
+
+	/* In 5 GHz/802.11a, we can always use short slot time.
+	 * (IEEE 802.11-2012 18.3.8.7)
+	 *
+	 * In 2.4GHz, we must always use long slots in IBSS for compatibility
+	 * reasons.
+	 * (IEEE 802.11-2012 19.4.5)
+	 *
+	 * HT follows these specifications (IEEE 802.11-2012 20.3.18)
+	 */
+	sdata->vif.bss_conf.use_short_slot = chan->band == IEEE80211_BAND_5GHZ;
+	bss_change |= BSS_CHANGED_ERP_SLOT;
+
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
-- 
1.7.10.4

