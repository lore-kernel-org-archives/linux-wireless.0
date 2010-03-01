Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:32436 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192Ab0CAL7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 06:59:18 -0500
Received: from vs30p.wh2.ocn.ne.jp (125.206.180.218)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0294474756
	for <linux-wireless@vger.kernel.org>; Mon,  1 Mar 2010 20:59:16 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 3/5] ath5k: use fixed antenna for tx descriptors
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 01 Mar 2010 20:59:16 +0900
Message-ID: <20100301115916.13996.10586.stgit@void>
In-Reply-To: <20100301115903.13996.95024.stgit@void>
References: <20100301115903.13996.95024.stgit@void>
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

