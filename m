Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:29657 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751182Ab0FGELK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:10 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0335373867
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:09 +0900 (JST)
Subject: [PATCH 1/5] ath5k: fix NULL pointer in antenna configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:19 +0900
Message-ID: <20100607041119.18667.32354.stgit@tt-desk>
In-Reply-To: <20100607041012.18667.6859.stgit@tt-desk>
References: <20100607041012.18667.6859.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the channel is not set yet and we configure the antennas just store the
setting. It will be activated during the next reset, when the channel is set.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 2b3f7a7..34ba576 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1793,6 +1793,13 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 	u8 def_ant, tx_ant, ee_mode;
 	u32 sta_id1 = 0;
 
+	/* if channel is not initialized yet we can't set the antennas
+	 * so just store the mode. it will be set on the next reset */
+	if (channel == NULL) {
+		ah->ah_ant_mode = ant_mode;
+		return;
+	}
+
 	def_ant = ah->ah_def_ant;
 
 	switch (channel->hw_value & CHANNEL_MODES) {

