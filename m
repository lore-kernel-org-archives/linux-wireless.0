Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57636 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbYJ2EvS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:51:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:51:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60199.655810.553608@gargle.gargle.HOWL> (sfid-20081029_060857_753450_2FEBC284)
Date: Wed, 29 Oct 2008 10:18:39 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 14/16] ath9k: Clear HT info on starting the driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Doing an interface down/up leaves the old HT assoc
information, clear it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 494d4a0..7b8b3d5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -979,6 +979,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
 		"initial channel: %d MHz\n", __func__, curchan->center_freq);
 
+	memset(&sc->sc_ht_info, 0, sizeof(struct ath_ht_info));
+
 	/* setup initial channel */
 
 	pos = ath_get_channel(sc, curchan);
-- 
1.6.0.3

