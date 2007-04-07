Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:45156 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965739AbXDGKvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 06:51:41 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id C03118CBD7
	for <linux-wireless@vger.kernel.org>; Sat,  7 Apr 2007 12:51:36 +0200 (CEST)
Message-Id: <20070407105138.693035816@warmcat.com>
References: <20070407105058.762762192@warmcat.com>
Date: Sat, 07 Apr 2007 11:51:01 +0100
From: andy@warmcat.com
To: linux-wireless@vger.kernel.org
Cc: Andy Green <andy@warmcat.com>
Subject: [PATCH 3/7] mac80211: Radiotap rx to use fallback rate calc if ieee80211_get_rate fails
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>

Michael Wu's radiotap rx code gave me a rate of 0 on zd1211rw-mac80211, perhaps
because no interface to the physical device was associated.  Added some fallback
code so that if the rate could not be computed by ieee80211_get_rate it uses
Michael's original method (which always worked for me).

Signed-off-by: Andy Green <andy@warmcat.com>



diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index e8c5f8d..211886c 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2821,6 +2821,8 @@ ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
 	rate = ieee80211_get_rate(local, status->phymode, status->rate);
 	if (rate)
 		rthdr->rate = rate->rate / 5;
+	else
+		rthdr->rate = status->rate / 5;
 	rthdr->chan_freq = cpu_to_le16(status->freq);
 	rthdr->chan_flags =
 		status->phymode == MODE_IEEE80211A ?

-- 
