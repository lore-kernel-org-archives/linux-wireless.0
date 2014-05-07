Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62762 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEGTxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 15:53:39 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so1500072wev.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 12:53:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/23] iwlwifi: mvm: rs: revert changes to search cycle rules
Date: Wed,  7 May 2014 22:52:41 +0300
Message-Id: <1399492380-12050-4-git-send-email-egrumbach@gmail.com> (sfid-20140507_215402_591183_733FA83F)
In-Reply-To: <536A8EE3.2050906@gmail.com>
References: <536A8EE3.2050906@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Adding more options in the search cycle causes longer
search cycles with additional wondering off to non optimal Tx
configurations. Reduce the Tx configurations searched to
improve throughput in non optimal attenuations.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 857ddaf..f9aab15 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -211,7 +211,7 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.next_columns = {
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_MIMO2,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
@@ -223,8 +223,8 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.ant = ANT_B,
 		.next_columns = {
 			RS_COLUMN_LEGACY_ANT_A,
-			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
+			RS_COLUMN_MIMO2,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
@@ -238,10 +238,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -254,10 +254,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_B_SGI,
-			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -271,10 +271,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_MIMO2,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -289,10 +289,10 @@ static const struct rs_tx_column rs_tx_columns[] = {
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_MIMO2,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -304,12 +304,12 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.ant = ANT_AB,
 		.next_columns = {
 			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_mimo_allow,
@@ -321,12 +321,12 @@ static const struct rs_tx_column rs_tx_columns[] = {
 		.sgi = true,
 		.next_columns = {
 			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_SISO_ANT_B_SGI,
-			RS_COLUMN_SISO_ANT_A,
-			RS_COLUMN_SISO_ANT_B,
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_mimo_allow,
-- 
1.8.3.2

