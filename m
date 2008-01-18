Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30047 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757892AbYARMvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:51:14 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 3/4] ath5k: use 3 instead of 0x00000003
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 18 Jan 2008 21:51:19 +0900
Message-ID: <20080118125119.6342.99381.stgit@one> (sfid-20080118_125117_502249_B0E006F2)
In-Reply-To: <20080118125018.6342.94435.stgit@one>
References: <20080118125018.6342.94435.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reviewed beacon timer initialization with register traces from madwifi: what we
are doing is correct :). one minor fix: use 3 instead of 0x00000003 - it's more
readable.

drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/hw.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index eb00818..3a4bf40 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -2605,10 +2605,8 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 		break;
 
 	default:
-		timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) <<
-		    0x00000003;
-		timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) <<
-		    0x00000003;
+		timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) << 3;
+		timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) << 3;
 	}
 
 	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);

