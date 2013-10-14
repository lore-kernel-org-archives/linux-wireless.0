Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53674 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083Ab3JNUAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 16:00:05 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] rt2x00: rt2800lib: autodetect 5GHz band support
Date: Mon, 14 Oct 2013 21:59:52 +0200
Message-Id: <1381780792-28894-3-git-send-email-juhosg@openwrt.org> (sfid-20131014_220012_914468_1D9CBB8D)
In-Reply-To: <1381780792-28894-1-git-send-email-juhosg@openwrt.org>
References: <1381780792-28894-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the RF chip supports more than 14 channels that
indirectly means that it supports the 5GHz band.
Use this fact to enable 5GHz band support instead
of setting SUPPORT_BAND_5GHZ separately for each
RF chip.

Also move the setup code of the 2GHz band to the
same place.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f143075..c5738f1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -7501,7 +7501,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize hw_mode information.
 	 */
-	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
 	switch (rt2x00dev->chip.rf) {
@@ -7513,7 +7512,6 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	case RF2750:
 	case RF2850:
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals);
 		spec->channels = rf_vals;
 		break;
@@ -7537,13 +7535,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	case RF3052:
 	case RF3053:
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		spec->num_channels = ARRAY_SIZE(rf_vals_3x);
 		spec->channels = rf_vals_3x;
 		break;
 
 	case RF5592:
-		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 		rt2800_register_read(rt2x00dev, MAC_DEBUG_INDEX, &reg);
 		if (rt2x00_get_field32(reg, MAC_DEBUG_INDEX_XTAL)) {
 			spec->num_channels = ARRAY_SIZE(rf_vals_5592_xtal40);
@@ -7558,6 +7554,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	if (WARN_ON_ONCE(!spec->channels))
 		return -ENODEV;
 
+	spec->supported_bands = SUPPORT_BAND_2GHZ;
+	if (spec->num_channels > 14)
+		spec->supported_bands |= SUPPORT_BAND_5GHZ;
+
 	/*
 	 * Initialize HT information.
 	 */
-- 
1.7.10
