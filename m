Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46728 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbZAPQL5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:11:57 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:11:57 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45308.437535.808225@gargle.gargle.HOWL> (sfid-20090116_171202_512443_A90765A8)
Date: Fri, 16 Jan 2009 21:38:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/9] ath9k: rateCodeToIndex is not used, remove it
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculation of rate indices from ratecode is done in recv.c
in a straightforward manner for both HT and legacy rates.
This variable is not needed anymore.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |   13 -------------
 drivers/net/wireless/ath9k/rc.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 0686a7c..182884a 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -19,7 +19,6 @@
 
 static struct ath_rate_table ar5416_11na_ratetable = {
 	42,
-	{0},
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
@@ -158,7 +157,6 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 
 static struct ath_rate_table ar5416_11ng_ratetable = {
 	46,
-	{0},
 	{
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
@@ -306,7 +304,6 @@ static struct ath_rate_table ar5416_11ng_ratetable = {
 
 static struct ath_rate_table ar5416_11a_ratetable = {
 	8,
-	{0},
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, (0x80|12),
@@ -340,7 +337,6 @@ static struct ath_rate_table ar5416_11a_ratetable = {
 
 static struct ath_rate_table ar5416_11g_ratetable = {
 	12,
-	{0},
 	{
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b, 0x00, 2,
@@ -386,7 +382,6 @@ static struct ath_rate_table ar5416_11g_ratetable = {
 
 static struct ath_rate_table ar5416_11b_ratetable = {
 	4,
-	{0},
 	{
 		{ VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
 			900, 0x1b,  0x00, (0x80|2),
@@ -1607,16 +1602,8 @@ static void ath_setup_rate_table(struct ath_softc *sc,
 {
 	int i;
 
-	for (i = 0; i < 256; i++)
-		rate_table->rateCodeToIndex[i] = (u8)-1;
-
 	for (i = 0; i < rate_table->rate_cnt; i++) {
-		u8 code = rate_table->info[i].ratecode;
 		u8 cix = rate_table->info[i].ctrl_rate;
-		u8 sh = rate_table->info[i].short_preamble;
-
-		rate_table->rateCodeToIndex[code] = i;
-		rate_table->rateCodeToIndex[code | sh] = i;
 
 		rate_table->info[i].lpAckDuration =
 			ath9k_hw_computetxtime(sc->sc_ah, rate_table,
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 97c60d1..a987cb9 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -90,7 +90,6 @@ struct ath_softc;
  */
 struct ath_rate_table {
 	int rate_cnt;
-	u8 rateCodeToIndex[256];
 	struct {
 		int valid;
 		int valid_single_stream;
-- 
1.6.0.3

