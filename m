Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26473 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1C1U5s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:48 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:24 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	<stable@kernel.org>, "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 9/9] ath9k: Fix memory leak due to failed PAPRD frames
Date: Mon, 28 Mar 2011 13:57:15 -0700
Message-ID: <1301345835-11401-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

commit 479600777bb588724d044815415f7d708d06644b upstream

free the skb's when the Tx of PAPRD frames fails and also add a debug
message indicating that.

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1049313..16b8e36 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -384,8 +384,11 @@ void ath_paprd_calibrate(struct work_struct *work)
 		init_completion(&sc->paprd_complete);
 		ar9003_paprd_setup_gain_table(ah, chain);
 		txctl.paprd = BIT(chain);
-		if (ath_tx_start(hw, skb, &txctl) != 0)
+		if (ath_tx_start(hw, skb, &txctl) != 0) {
+			ath_print(common, ATH_DBG_XMIT, "PAPRD TX failed\n");
+			dev_kfree_skb_any(skb);
 			break;
+		}
 
 		time_left = wait_for_completion_timeout(&sc->paprd_complete,
 				msecs_to_jiffies(ATH_PAPRD_TIMEOUT));
-- 
1.7.4.15.g7811d

