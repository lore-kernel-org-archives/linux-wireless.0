Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53927 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab3GLK1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 06:27:04 -0400
Received: by mail-ea0-f182.google.com with SMTP id d10so6315243eaj.13
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 03:27:03 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: pass also QOS Null frames through mgmt tx path
Date: Fri, 12 Jul 2013 12:25:46 +0200
Message-Id: <1373624746-3244-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130712_122709_790810_3A53E5D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fw will report wrong tx status for QOS Null frames
sent through data tx path.

This patch fixes station(s) keep alive detection
triggered from wpa_supplicant/hostapd when work
as AP/GO and WMM enabled.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index da5c333..81b1a4b 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1398,11 +1398,15 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 
 	if (ieee80211_is_mgmt(hdr->frame_control))
 		ret = ath10k_htt_mgmt_tx(ar->htt, skb);
-	else if (ieee80211_is_nullfunc(hdr->frame_control))
-		/* FW does not report tx status properly for NullFunc frames
-		 * unless they are sent through mgmt tx path. mac80211 sends
-		 * those frames when it detects link/beacon loss and depends on
-		 * the tx status to be correct. */
+	else if (ieee80211_is_nullfunc(hdr->frame_control) ||
+		 ieee80211_is_qos_nullfunc(hdr->frame_control))
+		/* FW does not report tx status properly for NullFunc and
+		 * QOS NullFunc frames unless they are sent through mgmt
+		 * tx path. mac80211 sends those frames when it detects
+		 * link/beacon loss and depends on the tx status to be
+		 * correct. mac80211 also send those frames when probe_client
+		 * in case of AP/GO mode.
+		 */
 		ret = ath10k_htt_mgmt_tx(ar->htt, skb);
 	else
 		ret = ath10k_htt_tx(ar->htt, skb);
-- 
1.7.9.5

