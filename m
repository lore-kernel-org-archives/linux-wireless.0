Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:43643 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbaDMNDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:03:04 -0400
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>, <stable@vger.kernel.org>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/13] iwlwifi: mvm: avoid searching unnecessary columns
Date: Sun, 13 Apr 2014 16:02:01 +0300
Message-Id: <1397394123-25102-11-git-send-email-egrumbach@gmail.com> (sfid-20140413_150514_089263_80CE457D)
In-Reply-To: <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
References: <534A8A49.2030100@gmail.com>
 <1397394123-25102-1-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Don't search columns which are unlikely to succeed as previous
columns searched with less aggressive modulation failed.

Cc: <stable@vger.kernel.org> [3.14]
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index b007db9..5cab26e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -212,8 +212,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_MIMO2,
-			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
@@ -225,8 +225,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_MIMO2,
-			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
@@ -239,9 +239,9 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
-			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -255,9 +255,9 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
-- 
1.8.3.2

