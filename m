Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45076 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab2IZQoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:44:06 -0400
Received: from localhost.localdomain (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q8QHGT3f006006
	for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 18:16:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] RFC ath5k: missing break
To: linux-wireless@vger.kernel.org
Date: Wed, 26 Sep 2012 18:02:58 +0100
Message-ID: <20120926170242.8585.7010.stgit@localhost.localdomain> (sfid-20120926_184410_524232_CB79D99F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

This code seems to make no sense otherwise for 5MHz mode as it always
recomputes the values in the fall through.

[ath5k_hw_set_opmode looks suspicious too btw]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/wireless/ath/ath5k/phy.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 01c90ed..ab363f3 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1975,11 +1975,13 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			spur_delta_phase = (spur_offset << 18) / 25;
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 2;
+			break;
 		case AR5K_BWMODE_5MHZ:
 			/* Both sample_freq and chip_freq are 10MHz (?) */
 			spur_delta_phase = (spur_offset << 19) / 25;
 			spur_freq_sigma_delta = (spur_delta_phase >> 10);
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz / 4;
+			break;
 		default:
 			if (channel->band == IEEE80211_BAND_5GHZ) {
 				/* Both sample_freq and chip_freq are 40MHz */

