Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45334 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727495AbeHaMiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:38:03 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:09 +0300
Message-Id: <20180831083130.15525-8-luca@coelho.fi> (sfid-20180831_103154_397184_7F8E0F3B)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 07/28] ieee80211: remove redundant leading zeroes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

The defines of IEEE80211_HE_OPERATION_VHT_OPER_INFO and
IEEE80211_HE_OPERATION_MULTI_BSSID_AP have leading zeroes
that makes the number look like it is bigger than 32 bit.
This is misleading, remove it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/linux/ieee80211.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 9c03a7d5e400..17ea51d088ae 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1963,8 +1963,8 @@ ieee80211_he_ppe_size(u8 ppe_thres_hdr, const u8 *phy_cap_info)
 #define IEEE80211_HE_OPERATION_TWT_REQUIRED			0x00000200
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK		0x000ffc00
 #define IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET		10
-#define IEEE80211_HE_OPERATION_PARTIAL_BSS_COLOR		0x000100000
-#define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x000200000
+#define IEEE80211_HE_OPERATION_PARTIAL_BSS_COLOR		0x00100000
+#define IEEE80211_HE_OPERATION_VHT_OPER_INFO			0x00200000
 #define IEEE80211_HE_OPERATION_MULTI_BSSID_AP			0x10000000
 #define IEEE80211_HE_OPERATION_TX_BSSID_INDICATOR		0x20000000
 #define IEEE80211_HE_OPERATION_BSS_COLOR_DISABLED		0x40000000
-- 
2.18.0
