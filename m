Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:45419 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbXKWAOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 19:14:34 -0500
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: davem@davemloft.net
Cc: shaddy_baddah@hotmail.com
Cc: kune@deine-taler.de
Subject: [PATCH 2.6.24] zd1211rw: fix unaligned memory accesses comparing MAC addresses
Message-Id: <20071123001428.03A199D4A1F@zog.reactivated.net> (sfid-20071123_001438_811073_6683A41B)
Date: Fri, 23 Nov 2007 00:14:27 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shaddy Baddah reported some unaligned accesses with the zd1211rw driver.
David Miller found an issue with comparison of ethernet addresses, and I
found a few others on top of that. This patch should remove most/all of the
unaligned accesses.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

---

A different patch will follow for 2.6.25 soon, probably using
compare_ether_addr_unaligned() if David accepts that patch.

Index: linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
===================================================================
--- linux-2.6.24-rc3-git1.orig/drivers/net/wireless/zd1211rw/zd_mac.c
+++ linux-2.6.24-rc3-git1/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -974,14 +974,14 @@ static int is_data_packet_for_us(struct 
 	switch (ieee->iw_mode) {
 	case IW_MODE_ADHOC:
 		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) != 0 ||
-		    compare_ether_addr(hdr->addr3, ieee->bssid) != 0)
+		    memcmp(hdr->addr3, ieee->bssid, ETH_ALEN) != 0)
 			return 0;
 		break;
 	case IW_MODE_AUTO:
 	case IW_MODE_INFRA:
 		if ((fc & (IEEE80211_FCTL_TODS|IEEE80211_FCTL_FROMDS)) !=
 		    IEEE80211_FCTL_FROMDS ||
-		    compare_ether_addr(hdr->addr2, ieee->bssid) != 0)
+		    memcmp(hdr->addr2, ieee->bssid, ETH_ALEN) != 0)
 			return 0;
 		break;
 	default:
@@ -989,9 +989,9 @@ static int is_data_packet_for_us(struct 
 		return 0;
 	}
 
-	return compare_ether_addr(hdr->addr1, netdev->dev_addr) == 0 ||
+	return memcmp(hdr->addr1, netdev->dev_addr, ETH_ALEN) == 0 ||
 	       (is_multicast_ether_addr(hdr->addr1) &&
-		compare_ether_addr(hdr->addr3, netdev->dev_addr) != 0) ||
+		memcmp(hdr->addr3, netdev->dev_addr, ETH_ALEN) != 0) ||
 	       (netdev->flags & IFF_PROMISC);
 }
 
@@ -1047,7 +1047,7 @@ static void update_qual_rssi(struct zd_m
 	hdr = (struct ieee80211_hdr_3addr *)buffer;
 	if (length < offsetof(struct ieee80211_hdr_3addr, addr3))
 		return;
-	if (compare_ether_addr(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid) != 0)
+	if (memcmp(hdr->addr2, zd_mac_to_ieee80211(mac)->bssid, ETH_ALEN) != 0)
 		return;
 
 	spin_lock_irqsave(&mac->lock, flags);
