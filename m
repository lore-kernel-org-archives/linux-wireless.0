Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43241 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 18/24] ath9k: add a debugfs entry for ignoring CCA on the extension channel in HT40
Date: Sat, 12 Jun 2010 00:33:56 -0400
Message-Id: <1276317242-15540-19-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Debugfs requires a u32 for bool knobs though so we turn the
ath9k_hw knob into a u32 as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    4 ++++
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index a6cb48d..54aae93 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -956,6 +956,10 @@ int ath9k_init_debug(struct ath_hw *ah)
 			sc->debug.debugfs_phy, sc, &fops_regval))
 		goto err;
 
+	if (!debugfs_create_bool("ignore_extcca", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, &ah->config.cwm_ignore_extcca))
+		goto err;
+
 	sc->debug.regidx = 0;
 	return 0;
 err:
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ba84ac7..20ec29f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -238,7 +238,7 @@ struct ath9k_ops_config {
 	int sw_beacon_response_time;
 	int additional_swba_backoff;
 	int ack_6mb;
-	int cwm_ignore_extcca;
+	u32 cwm_ignore_extcca;
 	u8 pcie_powersave_enable;
 	u8 pcie_clock_req;
 	u32 pcie_waen;
-- 
1.6.3.3

