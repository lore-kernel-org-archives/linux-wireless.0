Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab1LIBZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:04 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	stable@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 13/15] iwlagn: fix TID use bug
Date: Thu,  8 Dec 2011 16:26:20 -0800
Message-Id: <1323390382-1678-14-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022524_099333_299A7AFC)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The driver everywhere uses max TID count as 9,
which is wrong, it should be 8.

I think the reason it uses 9 here is off-by-one
confusion by whoever wrote this. We do use the
value IWL_MAX_TID_COUNT for "not QoS/no TID"
but that is completely correct even if it is 8
and not 9 since 0-7 are only valid.

As a side effect, this fixes the following bug:

 Open BA session requested for 00:23:cd:16:8a:7e tid 8
 ------------[ cut here ]------------
 kernel BUG at drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h:350!
 ...

when you do
echo "tx start 8" > /sys/kernel/debug/ieee80211/*/*/*/*/agg_status

Cc: stable@vger.kernel.org
Reported-by: Nikolay Martynov <mar.kolya@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 87bfdf6..265de39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -814,7 +814,7 @@ struct iwl_qosparam_cmd {
 #define	IWLAGN_STATION_COUNT	16
 
 #define	IWL_INVALID_STATION 	255
-#define IWL_MAX_TID_COUNT	9
+#define IWL_MAX_TID_COUNT	8
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)
-- 
1.7.0.4

