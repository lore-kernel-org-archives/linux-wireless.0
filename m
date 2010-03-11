Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57766 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab0CKV4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 16:56:04 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath9k: configure the beacon only if the STA is associated
Date: Thu, 11 Mar 2010 16:55:58 -0500
Message-Id: <1268344558-13835-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
References: <1268344558-13835-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Senthil Balasubramanian <senthilkumar@atheros.com>

commit 1a20034a73a40b8056731f9db0c535cec2961eb7 upstream.

beacons configuration SHOULD be done only if the STA is associated.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 1660ef1..9b73282 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -576,6 +576,13 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	u64 tsf;
 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
 
+	/* No need to configure beacon if we are not associated */
+	if (!common->curaid) {
+		ath_print(common, ATH_DBG_BEACON,
+			 "STA is not yet associated..skipping beacon config\n");
+		return;
+	}
+
 	memset(&bs, 0, sizeof(bs));
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 
-- 
1.6.3.3

