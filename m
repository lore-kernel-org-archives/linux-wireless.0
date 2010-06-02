Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51357 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932570Ab0FBWus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 18:50:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 15:50:48 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix bug in rate table
Date: Wed, 2 Jun 2010 15:50:46 -0700
Message-ID: <1275519046-8709-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commit added an entry in 11na and 11ng rate
table but missed to update its rate count field.

	Author: Vasanthakumar Thiagarajan <vasanth@atheros.com>
	Date:   Thu May 13 18:42:38 2010 -0700

    	ath9k: Enable Short GI in 20 Mhz for ar9287 and later chips

    	This patch enables short GI rx at all rates and tx at mcs15
    	for 20 Mhz channel width also.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index f5180d3..02b6052 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -20,7 +20,7 @@
 #include "ath9k.h"
 
 static const struct ath_rate_table ar5416_11na_ratetable = {
-	42,
+	43,
 	8, /* MCS start */
 	{
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
@@ -118,7 +118,7 @@ static const struct ath_rate_table ar5416_11na_ratetable = {
  * for HT are the 64K max aggregate limit */
 
 static const struct ath_rate_table ar5416_11ng_ratetable = {
-	46,
+	47,
 	12, /* MCS start */
 	{
 		{ VALID_ALL, VALID_ALL, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
-- 
1.7.0.4

