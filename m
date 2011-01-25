Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:10728 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab1AYEPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:40 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0371268939
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:39 +0900 (JST)
Subject: [PATCH 4/6] ath5k: Enable 802.11j 4.9GHz frequencies
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:38 +0900
Message-ID: <20110125041538.6944.31630.stgit@localhost6.localdomain6>
In-Reply-To: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enables 4.9GHz frequencies in ath5k if they are allowed as indicated by
the regulatory domain code. Currently this is MKK9_MKKC (0xfe).

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/caps.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 39baee1..f77e8a7 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -57,9 +57,8 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		 * XXX current ieee80211 implementation because the IEEE
 		 * XXX channel mapping does not support negative channel
 		 * XXX numbers (2312MHz is channel -19). Of course, this
-		 * XXX doesn't matter because these channels are out of range
-		 * XXX but some regulation domains like MKK (Japan) will
-		 * XXX support frequencies somewhere around 4.8GHz.
+		 * XXX doesn't matter because these channels are out of the
+		 * XXX legal range.
 		 */
 
 		/*
@@ -67,8 +66,10 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		 */
 
 		if (AR5K_EEPROM_HDR_11A(ee_header)) {
-			/* 4920 */
-			caps->cap_range.range_5ghz_min = 5005;
+			if (ath_is_49ghz_allowed(caps->cap_eeprom.ee_regdomain))
+				caps->cap_range.range_5ghz_min = 4920;
+			else
+				caps->cap_range.range_5ghz_min = 5005;
 			caps->cap_range.range_5ghz_max = 6100;
 
 			/* Set supported modes */

