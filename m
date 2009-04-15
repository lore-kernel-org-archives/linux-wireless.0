Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3421 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/5] ath5k: use bool for modparams
Date: Wed, 15 Apr 2009 07:57:34 -0400
Message-Id: <1239796656-20646-4-git-send-email-me@bobcopeland.com> (sfid-20090415_135846_622757_BED6B254)
In-Reply-To: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
References: <1239796656-20646-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code uses int types, but both modparams are boolean values.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ef8523e..3bde18f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -61,11 +61,11 @@
 
 static int ath5k_calinterval = 10; /* Calibrate PHY every 10 secs (TODO: Fixme) */
 static int modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static int modparam_all_channels;
-module_param_named(all_channels, modparam_all_channels, int, 0444);
+module_param_named(all_channels, modparam_all_channels, bool, S_IRUGO);
 MODULE_PARM_DESC(all_channels, "Expose all channels the device can use.");
 
 
-- 
1.6.0.6


