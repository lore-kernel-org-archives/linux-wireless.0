Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52195 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab0LZT5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 14:57:07 -0500
Received: by bwz15 with SMTP id 15so9183391bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 26 Dec 2010 11:57:04 -0800 (PST)
Message-Id: <E1PWwiD-0003TF-Hk@debian64.daheim>
Subject: [PATCH 1/3] carl9170: add missing return-value check
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 26 Dec 2010 18:21:53 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a forgotten bail-out path.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/phy.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 82bc81c..122e75e 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1676,6 +1676,8 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 
 	err = carl9170_write_reg(ar, AR9170_PHY_REG_HEAVY_CLIP_ENABLE,
 				 0x200);
+	if (err)
+		return err;
 
 	err = carl9170_init_rf_bank4_pwr(ar,
 		channel->band == IEEE80211_BAND_5GHZ,
-- 
1.7.2.3

