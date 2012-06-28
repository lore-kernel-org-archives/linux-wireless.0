Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41941 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab2F1A0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 20:26:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@qca.qualcomm.com
Subject: [PATCH 10/11] qca-swiss-army-knife: de-duplicate ar9340 initvals
Date: Thu, 28 Jun 2012 02:26:38 +0200
Message-Id: <1340843199-49821-10-git-send-email-nbd@openwrt.org> (sfid-20120628_022654_231731_4EC24BBA)
In-Reply-To: <1340843199-49821-9-git-send-email-nbd@openwrt.org>
References: <1340843199-49821-1-git-send-email-nbd@openwrt.org>
 <1340843199-49821-2-git-send-email-nbd@openwrt.org>
 <1340843199-49821-3-git-send-email-nbd@openwrt.org>
 <1340843199-49821-4-git-send-email-nbd@openwrt.org>
 <1340843199-49821-5-git-send-email-nbd@openwrt.org>
 <1340843199-49821-6-git-send-email-nbd@openwrt.org>
 <1340843199-49821-7-git-send-email-nbd@openwrt.org>
 <1340843199-49821-8-git-send-email-nbd@openwrt.org>
 <1340843199-49821-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 tools/initvals/initvals.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/initvals/initvals.c b/tools/initvals/initvals.c
index abf7b36..a19dca2 100644
--- a/tools/initvals/initvals.c
+++ b/tools/initvals/initvals.c
@@ -630,11 +630,14 @@ static void ar9340_hw_print_initvals(bool check)
 {
 	INI_PRINT(ar9340_1p0_radio_postamble);
 	INI_PRINT(ar9340Modes_lowest_ob_db_tx_gain_table_1p0);
-	INI_PRINT(ar9340Modes_fast_clock_1p0);
+	INI_PRINT_DUP(ar9340Modes_fast_clock_1p0,
+		      ar9300Modes_fast_clock_2p2);
 	INI_PRINT(ar9340_1p0_radio_core);
 	INI_PRINT(ar9340_1p0_radio_core_40M);
-	INI_PRINT(ar9340_1p0_mac_postamble);
-	INI_PRINT(ar9340_1p0_soc_postamble);
+	INI_PRINT_DUP(ar9340_1p0_mac_postamble,
+		      ar9300_2p2_mac_postamble);
+	INI_PRINT_DUP(ar9340_1p0_soc_postamble,
+		      ar9300_2p2_soc_postamble);
 	INI_PRINT(ar9340_1p0_baseband_postamble);
 	INI_PRINT(ar9340_1p0_baseband_core);
 	INI_PRINT(ar9340Modes_high_power_tx_gain_table_1p0);
@@ -644,7 +647,8 @@ static void ar9340_hw_print_initvals(bool check)
 	INI_PRINT(ar9340Modes_low_ob_db_tx_gain_table_1p0);
 	INI_PRINT(ar9340Modes_mixed_ob_db_tx_gain_table_1p0);
 	INI_PRINT(ar9340_1p0_mac_core);
-	INI_PRINT(ar9340Common_wo_xlna_rx_gain_table_1p0);
+	INI_PRINT_DUP(ar9340Common_wo_xlna_rx_gain_table_1p0,
+		      ar9300Common_wo_xlna_rx_gain_table_2p2);
 	INI_PRINT(ar9340_1p0_soc_preamble);
 }
 
-- 
1.7.3.2

