Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34167 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab1AFRQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 12:16:59 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again.
Date: Thu,  6 Jan 2011 18:16:51 +0100
Message-Id: <1294334212-20530-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/25-multicast-list_head.patch |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/patches/25-multicast-list_head.patch b/patches/25-multicast-list_head.patch
index bee189d..95bab2e 100644
--- a/patches/25-multicast-list_head.patch
+++ b/patches/25-multicast-list_head.patch
@@ -160,16 +160,16 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  
  	return mchash;
  }
---- a/drivers/net/wireless/ath/ath5k/base.c
-+++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -3135,20 +3135,42 @@ unlock:
- }
+--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
++++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+@@ -331,20 +331,42 @@ ath5k_bss_info_changed(struct ieee80211_
  
- static u64 ath5k_prepare_multicast(struct ieee80211_hw *hw,
+ static u64
+ ath5k_prepare_multicast(struct ieee80211_hw *hw,
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
- 				   struct netdev_hw_addr_list *mc_list)
+ 			struct netdev_hw_addr_list *mc_list)
 +#else
-+				   int mc_count, struct dev_addr_list *ha)
++			int mc_count, struct dev_addr_list *ha)
 +#endif
  {
  	u32 mfilt[2], val;
@@ -205,7 +205,7 @@ This also backport commit 2f787b0b76bf5de2eaa3ca3a29d89123ae03c856
  		pos ^= (val >> 18) ^ (val >> 12) ^ (val >> 6) ^ val;
  		pos &= 0x3f;
  		mfilt[pos / 32] |= (1 << (pos % 32));
-@@ -3157,6 +3179,9 @@ static u64 ath5k_prepare_multicast(struc
+@@ -353,6 +375,9 @@ ath5k_prepare_multicast(struct ieee80211
  		* neet to inform below to not reset the mcast */
  		/* ath5k_hw_set_mcast_filterindex(ah,
  		 *      ha->addr[5]); */
-- 
1.7.1

