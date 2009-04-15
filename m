Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3420 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/5] ath5k: fix initvals errors
Date: Wed, 15 Apr 2009 07:57:32 -0400
Message-Id: <1239796656-20646-2-git-send-email-me@bobcopeland.com> (sfid-20090415_135846_747732_97D76862)
In-Reply-To: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects a few errors in the initvals tables to match those
in the HAL tables.  Namely, remove a couple of repetitions, fix some
turbo mode errors, and correct a register for the CCK rate power table.

Changes-licensed-under: ISC

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/initvals.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 61fb621..18eb519 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -537,8 +537,6 @@ static const struct ath5k_ini ar5212_ini_common_start[] = {
 	{ AR5K_DCU_TX_FILTER_1(15), 0x00000000 },
 	{ AR5K_DCU_TX_FILTER_CLR, 0x00000000 },
 	{ AR5K_DCU_TX_FILTER_SET, 0x00000000 },
-	{ AR5K_DCU_TX_FILTER_CLR, 0x00000000 },
-	{ AR5K_DCU_TX_FILTER_SET, 0x00000000 },
 	{ AR5K_STA_ID1,		0x00000000 },
 	{ AR5K_BSS_ID0,		0x00000000 },
 	{ AR5K_BSS_ID1,		0x00000000 },
@@ -669,7 +667,7 @@ static const struct ath5k_ini ar5212_ini_common_start[] = {
 	/*{ AR5K_PHY(650), 0x000001b5 },*/
 	{ AR5K_PHY(651),	0x00000000 },
 	{ AR5K_PHY_TXPOWER_RATE3, 0x20202020 },
-	{ AR5K_PHY_TXPOWER_RATE2, 0x20202020 },
+	{ AR5K_PHY_TXPOWER_RATE4, 0x20202020 },
 	/*{ AR5K_PHY(655), 0x13c889af },*/
 	{ AR5K_PHY(656),	0x38490a20 },
 	{ AR5K_PHY(657),	0x00007bb6 },
@@ -718,7 +716,7 @@ static const struct ath5k_ini_mode ar5212_ini_mode_start[] = {
 	{ AR5K_PHY_SETTLING,
 	   { 0x1372161c, 0x13721c25, 0x13721722, 0x137216a2, 0x13721c25 } },
 	{ AR5K_PHY_AGCCTL,
-	   { 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d18, 0x00009d18 } },
+	   { 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d18, 0x00009d10 } },
 	{ AR5K_PHY_NF,
 	   { 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
 	{ AR5K_PHY_WEAK_OFDM_HIGH_THR,
@@ -799,7 +797,7 @@ static const struct ath5k_ini_mode rf5112_ini_mode_end[] = {
 	{ AR5K_PHY_DESIRED_SIZE,
 	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
 	{ AR5K_PHY_SIG,
-	   { 0x7e800d2e, 0x7e800d2e, 0x7ee80d2e, 0x7ee80d2e, 0x7ee80d2e } },
+	   { 0x7e800d2e, 0x7e800d2e, 0x7ee80d2e, 0x7ee80d2e, 0x7e800d2e } },
 	{ AR5K_PHY_AGCCOARSE,
 	   { 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-- 
1.6.0.6


