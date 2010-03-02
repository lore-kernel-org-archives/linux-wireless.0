Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:36555 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753558Ab0CBH6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:58:52 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0351416730
	for <linux-wireless@vger.kernel.org>; Tue,  2 Mar 2010 16:58:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 4/4] ath5k: remove ah_gpio_npins
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 02 Mar 2010 16:58:48 +0900
Message-ID: <20100302075848.20555.55385.stgit@void>
In-Reply-To: <20100302075526.20555.14622.stgit@void>
References: <20100302075526.20555.14622.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

it's never used and we have a newer implementation in gpio.c.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---

 drivers/net/wireless/ath/ath5k/ath5k.h |    2 --
 drivers/net/wireless/ath/ath5k/caps.c  |    3 ---
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 54f35ae..7721d7d 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1068,8 +1068,6 @@ struct ath5k_hw {
 	u8			ah_def_ant;
 	bool			ah_software_retry;
 
-	int			ah_gpio_npins;
-
 	struct ath5k_capabilities ah_capabilities;
 
 	struct ath5k_txq_info	ah_txq[AR5K_NUM_TX_QUEUES];
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 367a6c7..e618e71 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -102,9 +102,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 		}
 	}
 
-	/* GPIO */
-	ah->ah_gpio_npins = AR5K_NUM_GPIO;
-
 	/* Set number of supported TX queues */
 	if (ah->ah_version == AR5K_AR5210)
 		ah->ah_capabilities.cap_queues.q_tx_num =

