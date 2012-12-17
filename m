Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:34635 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab2LQVGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 16:06:15 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: fix column header comments for some initval arrays
Date: Mon, 17 Dec 2012 22:06:08 +0100
Message-Id: <1355778368-4507-1-git-send-email-juhosg@openwrt.org> (sfid-20121217_220619_072740_7C40EDED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some 3-column initval arrays have wrong comments. The
column of these arrays is indexed by the 'freqIndex'
variable in 'ar5008_hw_process_ini' which only depends
on the actual band.

The 'initvals' tool from 'qca-swiss-army-knife' prints
the correct comment lines for these arrays, since commit
'atheros-initvals: fix comments for non-fastclock 3-column tables'
however the comments were not refreshed in ath9k.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h |    8 ++++----
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
index f81e7fc..467ccfa 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
@@ -466,7 +466,7 @@ static const u32 ar5416Bank0[][2] = {
 };
 
 static const u32 ar5416BB_RfGain[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x00009a00, 0x00000000, 0x00000000},
 	{0x00009a04, 0x00000040, 0x00000040},
 	{0x00009a08, 0x00000080, 0x00000080},
@@ -546,12 +546,12 @@ static const u32 ar5416Bank2[][2] = {
 };
 
 static const u32 ar5416Bank3[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x000098f0, 0x01400018, 0x01c00018},
 };
 
 static const u32 ar5416Bank6[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
@@ -588,7 +588,7 @@ static const u32 ar5416Bank6[][3] = {
 };
 
 static const u32 ar5416Bank6TPC[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index ea4a230..59524e1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -460,7 +460,7 @@ static const u32 ar5416Common_9100[][2] = {
 };
 
 static const u32 ar5416Bank6_9100[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
@@ -497,7 +497,7 @@ static const u32 ar5416Bank6_9100[][3] = {
 };
 
 static const u32 ar5416Bank6TPC_9100[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
+	/* Addr      5G          2G        */
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
 	{0x0000989c, 0x00000000, 0x00000000},
-- 
1.7.10

