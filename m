Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:35663 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbaCROqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:17 -0400
Received: by mail-ee0-f51.google.com with SMTP id c13so5497905eek.10
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:16 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/35] iwlwifi: mvm: rs: fix search cycle rules
Date: Tue, 18 Mar 2014 16:45:22 +0200
Message-Id: <1395153939-23897-18-git-send-email-egrumbach@gmail.com> (sfid-20140318_154729_592848_1E3E355A)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

We should explore all possible columns when searching to be
as resilient as possible to changing conditions. This fixes
for example a scenario where even after a sudden creation of
rssi difference between the 2 antennas we would keep doing MIMO
at a low rate instead of switching to SISO at a higher rate using
the better antenna which was the optimal configuration.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 36 +++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index ad83342..4e16d7c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -211,9 +211,9 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.next_columns = {
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_MIMO2_SGI,
 		},
 	},
 	[RS_COLUMN_LEGACY_ANT_B] = {
@@ -221,10 +221,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.ant = ANT_B,
 		.next_columns = {
 			RS_COLUMN_LEGACY_ANT_A,
+			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_MIMO2_SGI,
 		},
 	},
 	[RS_COLUMN_SISO_ANT_A] = {
@@ -234,8 +234,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_SISO_ANT_B_SGI,
+			RS_COLUMN_MIMO2_SGI,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -248,8 +248,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_B_SGI,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_MIMO2_SGI,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -263,8 +263,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_MIMO2,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -279,8 +279,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_MIMO2,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -292,10 +292,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.ant = ANT_AB,
 		.next_columns = {
 			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -307,10 +307,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.sgi = true,
 		.next_columns = {
 			RS_COLUMN_SISO_ANT_A_SGI,
+			RS_COLUMN_SISO_ANT_B_SGI,
+			RS_COLUMN_SISO_ANT_A,
+			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
-			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_mimo_allow,
-- 
1.8.3.2

