Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54760 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2A3Iyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 03:54:52 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20262.23070.975638.922028@gargle.gargle.HOWL> (sfid-20120130_095455_422880_924314A8)
Date: Mon, 30 Jan 2012 14:21:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Print the correct channel mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

channelFlags doesn't contain the operating HT mode.
Use IS_CHAN_HT40 to determine if the current channel is
in HT40 mode.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4a00806..ec82e92 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -340,9 +340,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
-		hchan->channel, !!(hchan->channelFlags & (CHANNEL_HT40MINUS |
-							  CHANNEL_HT40PLUS)),
-		fastcc);
+		hchan->channel, IS_CHAN_HT40(hchan), fastcc);
 
 	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (r) {
-- 
1.7.9

