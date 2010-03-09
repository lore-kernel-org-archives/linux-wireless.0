Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:38733 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752226Ab0CIHz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:27 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0898431324
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:24 +0900 (JST)
Subject: [PATCH 02/13] ath5k: use fixed antenna for tx descriptors
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:23 +0900
Message-ID: <20100309075523.30616.63612.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when using a fixed antenna we should use the antenna number in all tx
descriptors, otherwise the hardware will sometimes send the frame out on the
other antenna. it seems like the hardware does not always respect the default
antenna and diversity settings (esp.  AR5K_STA_ID1_DEFAULT_ANTENNA).

also i would like to note that antenna diversity does not always work correctly
on 5414 (at least) when only one antenna is connected: for example all frames
might be received on antenna A but still the HW tries to send on antenna B some
times, causing packet loss.

this is both verified with the antenna statistics output of the previous patch
and a spectrum analyzer.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 72474c0..ffe253a 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1873,7 +1873,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 		break;
 	case AR5K_ANTMODE_FIXED_A:
 		def_ant = 1;
-		tx_ant = 0;
+		tx_ant = 1;
 		use_def_for_tx = true;
 		update_def_on_tx = false;
 		use_def_for_rts = true;
@@ -1882,7 +1882,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 		break;
 	case AR5K_ANTMODE_FIXED_B:
 		def_ant = 2;
-		tx_ant = 0;
+		tx_ant = 2;
 		use_def_for_tx = true;
 		update_def_on_tx = false;
 		use_def_for_rts = true;

