Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:39784 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFtx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:53 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0353216192
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:52 +0900 (JST)
Subject: [PATCH 09/10] ath5k: add capability flag for phyerror counters
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:47 +0900
Message-ID: <20100325054947.10697.26504.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chipsets since revision AR5213A (0x59) have hardware counters for PHY errors
which we can read directly from the registers. Older hardware has to use the RX
descriptor status to get a count of PHY errors. This will be used in several
places in the ANI implementation, so a flag is useful.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath/ath5k/caps.c  |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ec62690..f578c1e 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -982,6 +982,8 @@ struct ath5k_capabilities {
 	struct {
 		u8	q_tx_num;
 	} cap_queues;
+
+	bool cap_has_phyerr_counters;
 };
 
 /* size of noise floor history (keep it a power of two) */
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index e618e71..74f0071 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -109,6 +109,12 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 	else
 		ah->ah_capabilities.cap_queues.q_tx_num = AR5K_NUM_TX_QUEUES;
 
+	/* newer hardware has PHY error counters */
+	if (ah->ah_mac_srev >= AR5K_SREV_AR5213A)
+		ah->ah_capabilities.cap_has_phyerr_counters = true;
+	else
+		ah->ah_capabilities.cap_has_phyerr_counters = false;
+
 	return 0;
 }
 

