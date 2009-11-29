Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39813 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbZK2M3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 07:29:50 -0500
Date: Sun, 29 Nov 2009 14:29:42 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] mac80211: Fix TX status reporting for injected data frames
Message-ID: <20091129122942.GA21310@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An earlier optimization on removing unnecessary traffic on cooked
monitor interfaces (f6021ac43c4cd556ade8c0b0d641b29fd0181d4a) ended up
removing quite a bit more than just unnecessary traffic. It was not
supposed to remove TX status reporting for injected frames, but ended
up doing it by checking the injected flag in skb->cb only after that
field had been cleared with memset.. Fix this by taking a local copy
of the injected flag before skb->cb is cleared.

This broke user space applications that depend on getting TX status
notifications for injected data frames. For example, STA inactivity
poll from hostapd did not work and ended up kicking out stations even
if they were still present.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 net/mac80211/status.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- uml.orig/net/mac80211/status.c	2009-11-29 13:33:16.000000000 +0200
+++ uml/net/mac80211/status.c	2009-11-29 14:15:50.000000000 +0200
@@ -148,6 +148,7 @@ void ieee80211_tx_status(struct ieee8021
 	struct net_device *prev_dev = NULL;
 	struct sta_info *sta;
 	int retry_count = -1, i;
+	bool injected;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/* the HW cannot have attempted that rate */
@@ -297,6 +298,9 @@ void ieee80211_tx_status(struct ieee8021
 	/* for now report the total retry_count */
 	rthdr->data_retries = retry_count;
 
+	/* Need to make a copy before skb->cb gets cleared */
+	injected = !!(info->flags & IEEE80211_TX_CTL_INJECTED);
+
 	/* XXX: is this sufficient for BPF? */
 	skb_set_mac_header(skb, 0);
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -311,7 +315,7 @@ void ieee80211_tx_status(struct ieee8021
 				continue;
 
 			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
-			    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
+			    !injected &&
 			    (type == IEEE80211_FTYPE_DATA))
 				continue;
 

-- 
Jouni Malinen                                            PGP id EFC895FA
