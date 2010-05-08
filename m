Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:33999 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab0EHQY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:24:56 -0400
Received: by qyk13 with SMTP id 13so3448325qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:24:55 -0700 (PDT)
Date: Sat, 8 May 2010 18:24:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [patch 6/9] ath5k: several off by one range checks
Message-ID: <20100508162438.GR27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several places that use > ARRAY_SIZE() instead of 
>= ARRAY_SIZE().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index 584a328..f2311ab 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -73,7 +73,7 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	const s8 hi[] = { -14, -12 };
 	const s8 fr[] = { -78, -80 };
 #endif
-	if (level < 0 || level > ARRAY_SIZE(sz)) {
+	if (level < 0 || level >= ARRAY_SIZE(sz)) {
 		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
 			"level out of range %d", level);
 		return;
@@ -104,7 +104,7 @@ ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
 {
 	const int val[] = { 2, 4, 6, 8, 10, 12, 14, 16 };
 
-	if (level < 0 || level > ARRAY_SIZE(val) ||
+	if (level < 0 || level >= ARRAY_SIZE(val) ||
 	    level > ah->ah_sc->ani_state.max_spur_level) {
 		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
 			"level out of range %d", level);
@@ -129,7 +129,7 @@ ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level)
 {
 	const int val[] = { 0, 4, 8 };
 
-	if (level < 0 || level > ARRAY_SIZE(val)) {
+	if (level < 0 || level >= ARRAY_SIZE(val)) {
 		ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_ANI,
 			"level out of range %d", level);
 		return;
