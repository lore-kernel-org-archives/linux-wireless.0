Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48370 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaEORFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:20 -0400
Received: by mail-wg0-f47.google.com with SMTP id x12so3703138wgg.6
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:18 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/24] iwlwifi: mvm: BT Coex - fix boost register / LUT values
Date: Thu, 15 May 2014 20:04:33 +0300
Message-Id: <1400173481-9047-16-git-send-email-egrumbach@gmail.com> (sfid-20140515_190531_051817_0A9AF2F0)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These values are used to give preference to WiFi according
to a certain pattern.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 2b87a77..3833f2c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -124,10 +124,10 @@ const u32 iwl_bt_cts_kill_msk[BT_KILL_MSK_MAX] = {
 };
 
 static const __le32 iwl_bt_prio_boost[BT_COEX_BOOST_SIZE] = {
-	cpu_to_le32(0xf0f0f0f0),
-	cpu_to_le32(0xc0c0c0c0),
-	cpu_to_le32(0xfcfcfcfc),
-	cpu_to_le32(0xff00ff00),
+	cpu_to_le32(0xf0f0f0f0), /* 50% */
+	cpu_to_le32(0xc0c0c0c0), /* 25% */
+	cpu_to_le32(0xfcfcfcfc), /* 75% */
+	cpu_to_le32(0xfefefefe), /* 87.5% */
 };
 
 static const __le32 iwl_single_shared_ant[BT_COEX_MAX_LUT][BT_COEX_LUT_SIZE] = {
@@ -300,8 +300,8 @@ static const __le64 iwl_ci_mask[][3] = {
 };
 
 static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x22002200),
-	cpu_to_le32(0x33113311),
+	cpu_to_le32(0x28412201),
+	cpu_to_le32(0x11118451),
 };
 
 struct corunning_block_luts {
-- 
1.8.3.2

