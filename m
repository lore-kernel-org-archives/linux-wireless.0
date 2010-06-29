Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41535 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754833Ab0F2UgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jun 2010 16:36:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patch
Date: Tue, 29 Jun 2010 22:36:15 +0200
Message-Id: <1277843775-2656-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index f7304cb..f3746ca 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -419,7 +419,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  			      size_t fw_name_len, u32 *hw_ver);
 --- a/drivers/net/wireless/rndis_wlan.c
 +++ b/drivers/net/wireless/rndis_wlan.c
-@@ -1587,7 +1587,11 @@ static void set_multicast_list(struct us
+@@ -1588,7 +1588,11 @@ static void set_multicast_list(struct us
  
  		netdev_for_each_mc_addr(ha, usbdev->net)
  			memcpy(mc_addrs + i++ * ETH_ALEN,
@@ -601,9 +601,9 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
 +			memcpy(__skb_put(skb, ETH_ALEN), ha->dmi_addr, ETH_ALEN);
 +			memcpy(__skb_put(skb, ETH_ALEN), ha->dmi_addr, ETH_ALEN);
 +#endif
+ 
+ 			i++;
  		}
- 		r->len = htons(skb->len - len);
- 	}
 --- a/net/mac80211/driver-ops.h
 +++ b/net/mac80211/driver-ops.h
 @@ -90,14 +90,28 @@ static inline void drv_bss_info_changed(
-- 
1.7.0.4

