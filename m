Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49141 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668AbaJUQE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 12:04:57 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 3/8] iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
Date: Tue, 21 Oct 2014 19:04:34 +0300
Message-Id: <1413907479-9073-3-git-send-email-egrumbach@gmail.com> (sfid-20141021_180511_417240_719AA6BD)
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Cc: <stable@vger.kernel.org> [3.16+]
Fixes: 2adc8949efab ("iwlwifi: mvm: BT Coex - fix boost register / LUT values")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 8df2021..da2ffb7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -303,8 +303,8 @@ static const __le64 iwl_ci_mask[][3] = {
 };
 
 static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x28412201),
-	cpu_to_le32(0x11118451),
+	cpu_to_le32(0x2e402280),
+	cpu_to_le32(0x7711a751),
 };
 
 struct corunning_block_luts {
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 585c0ab..8a1d2f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -291,8 +291,8 @@ static const __le64 iwl_ci_mask[][3] = {
 };
 
 static const __le32 iwl_bt_mprio_lut[BT_COEX_MULTI_PRIO_LUT_SIZE] = {
-	cpu_to_le32(0x28412201),
-	cpu_to_le32(0x11118451),
+	cpu_to_le32(0x2e402280),
+	cpu_to_le32(0x7711a751),
 };
 
 struct corunning_block_luts {
-- 
1.9.1

