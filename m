Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758552Ab2DXXv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/11] iwlwifi: add loose coex lut
Date: Tue, 24 Apr 2012 16:46:01 -0700
Message-Id: <1335311164-10252-9-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015202_300218_678E9C4C)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the Loose coex LUT and will use later for better bt coex tpt

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 9fb4c7d..01dc442 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -186,7 +186,8 @@ done:
 /*
  * BT coex
  */
-static const __le32 iwlagn_def_3w_lookup[12] = {
+/* Notmal TDM */
+static const __le32 iwlagn_def_3w_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
 	cpu_to_le32(0xaaaaaaaa),
 	cpu_to_le32(0xaaaaaaaa),
 	cpu_to_le32(0xaeaaaaaa),
@@ -201,7 +202,25 @@ static const __le32 iwlagn_def_3w_lookup[12] = {
 	cpu_to_le32(0xf0005000),
 };
 
-static const __le32 iwlagn_concurrent_lookup[12] = {
+
+/* Loose Coex */
+static const __le32 iwlagn_loose_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaeaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xcc00ff28),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0xcc00aaaa),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0xf0005000),
+	cpu_to_le32(0xf0005000),
+};
+
+/* Full concurrency */
+static const __le32 iwlagn_concurrent_lookup[IWLAGN_BT_DECISION_LUT_SIZE] = {
 	cpu_to_le32(0xaaaaaaaa),
 	cpu_to_le32(0xaaaaaaaa),
 	cpu_to_le32(0xaaaaaaaa),
-- 
1.7.0.4

