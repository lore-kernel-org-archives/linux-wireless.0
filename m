Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward9l.mail.yandex.net ([84.201.143.142]:49978 "EHLO
	forward9l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3HQMXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:23:46 -0400
From: Sergey K <perplexus@ya.ru>
To: linux-wireless@vger.kernel.org
Cc: Sergey K <perplexus@ya.ru>
Subject: [PATCH 1/1] Delete duplicate code. Use of the variable instead call a function
Date: Sat, 17 Aug 2013 16:16:37 +0400
Message-Id: <1376741797-25505-2-git-send-email-perplexus@ya.ru> (sfid-20130817_142350_034634_A1C98E89)
In-Reply-To: <1376741797-25505-1-git-send-email-perplexus@ya.ru>
References: <1376741797-25505-1-git-send-email-perplexus@ya.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 net/mac80211/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 098ae85..79db7f3 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1769,8 +1769,6 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			memcpy(hdr.addr3, skb->data, ETH_ALEN);
 			memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
 			hdrlen = 30;
-			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-			wme_sta = test_sta_flag(sta, WLAN_STA_WME);
 		}
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
@@ -1979,7 +1977,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * EAPOL frames from the local station.
 	 */
 	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
-		     !is_multicast_ether_addr(hdr.addr1) && !authorized &&
+		     !multicast && !authorized &&
 		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-- 
1.8.1.5

