Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4692 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933611Ab1JYOJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:09:05 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 29/31] ath6kl: Add a modparam to enable multi normal interface support
Date: Tue, 25 Oct 2011 19:34:24 +0530
Message-ID: <1319551466-29070-30-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160911_742663_71B61841)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This option lets operate more than one vif in normal mode (AP/STA/IBSS)
when support for multiple vif is enabled. This modparam needs to be used
as

modprobe ath6kl multi_norm_if_support=1

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   23 ++++++++++++++++++++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    1 +
 drivers/net/wireless/ath/ath6kl/init.c     |   24 +++++++++++++-----------
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 7713ab4..ae58d9a 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -21,8 +21,10 @@
 #include "testmode.h"
 
 static unsigned int ath6kl_p2p;
+static unsigned int multi_norm_if_support;
 
 module_param(ath6kl_p2p, uint, 0644);
+module_param(multi_norm_if_support, uint, 0644);
 
 #define RATETAB_ENT(_rate, _rateid, _flags) {   \
 	.bitrate    = (_rate),                  \
@@ -341,6 +343,16 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
 		}
 	}
 
+	if (type == NL80211_IFTYPE_P2P_CLIENT ||
+	    type == NL80211_IFTYPE_P2P_GO) {
+		for (i = ar->max_norm_iface; i < MAX_NUM_VIF; i++) {
+			if ((ar->avail_idx_map >> i) & BIT(0)) {
+				*if_idx = i;
+				return true;
+			}
+		}
+	}
+
 	return false;
 }
 
@@ -2094,10 +2106,19 @@ struct ath6kl *ath6kl_core_alloc(struct device *dev)
 	}
 
 	ar = wiphy_priv(wiphy);
-	ar->p2p = !!ath6kl_p2p;
+	if (!multi_norm_if_support)
+		ar->p2p = !!ath6kl_p2p;
 	ar->wiphy = wiphy;
 	ar->dev = dev;
 
+	if (multi_norm_if_support)
+		ar->max_norm_iface = 2;
+	else
+		ar->max_norm_iface = 1;
+
+	/* FIXME: Remove this once the multivif support is enabled */
+	ar->max_norm_iface = 1;
+
 	spin_lock_init(&ar->lock);
 	spin_lock_init(&ar->mcastpsq_lock);
 	spin_lock_init(&ar->list_lock);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6933fb6..427db08 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -461,6 +461,7 @@ struct ath6kl {
 	/* Lock to avoid race in vif_list entries among add/del/traverse */
 	spinlock_t list_lock;
 	u8 num_vif;
+	u8 max_norm_iface;
 	u8 avail_idx_map;
 	spinlock_t lock;
 	struct semaphore sem;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 2780170..6f5bdff 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -428,7 +428,7 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
 int ath6kl_configure_target(struct ath6kl *ar)
 {
 	u32 param, ram_reserved_size;
-	u8 fw_iftype, fw_mode = 0, fw_submode;
+	u8 fw_iftype, fw_mode = 0, fw_submode = 0;
 	int i;
 
 	/*
@@ -445,15 +445,19 @@ int ath6kl_configure_target(struct ath6kl *ar)
 		fw_mode |= fw_iftype << (i * HI_OPTION_FW_MODE_BITS);
 
 	/*
-	 * submodes : vif[0] - AP/STA/IBSS
-	 *	      vif[1] - "P2P dev"/"P2P GO"/"P2P Client"
-	 *	      vif[2] - "P2P dev"/"P2P GO"/"P2P Client"
+	 * By default, submodes :
+	 *		vif[0] - AP/STA/IBSS
+	 *		vif[1] - "P2P dev"/"P2P GO"/"P2P Client"
+	 *		vif[2] - "P2P dev"/"P2P GO"/"P2P Client"
 	 */
-	fw_submode = HI_OPTION_FW_SUBMODE_NONE |
-		     (HI_OPTION_FW_SUBMODE_P2PDEV <<
-		      (1 * HI_OPTION_FW_SUBMODE_BITS)) |
-		      (HI_OPTION_FW_SUBMODE_P2PDEV <<
-		      (2 * HI_OPTION_FW_SUBMODE_BITS));
+
+	for (i = 0; i < ar->max_norm_iface; i++)
+		fw_submode |= HI_OPTION_FW_SUBMODE_NONE <<
+			      (i * HI_OPTION_FW_SUBMODE_BITS);
+
+	for (i = ar->max_norm_iface; i < MAX_NUM_VIF; i++)
+		fw_submode |= HI_OPTION_FW_SUBMODE_P2PDEV <<
+			      (i * HI_OPTION_FW_SUBMODE_BITS);
 
 	/*
 	 * FIXME: This needs to be removed once the multivif
@@ -461,8 +465,6 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	 */
 	if (ar->p2p)
 		fw_submode = HI_OPTION_FW_SUBMODE_P2PDEV;
-	else
-		fw_submode = HI_OPTION_FW_SUBMODE_NONE;
 
 	param = HTC_PROTOCOL_VERSION;
 	if (ath6kl_bmi_write(ar,
-- 
1.7.0.4

