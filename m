Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:48320 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab3CVL6e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 07:58:34 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	simon.wunderlich@s2003.tu-chemnitz.de,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: trivial: change spectral relayfs buffering
Date: Fri, 22 Mar 2013 12:58:23 +0100
Message-Id: <1363953503-21865-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20130322_125838_505136_DF893536)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spectral data provided via relay-fs introduces a buffering
latency given by the subbuf_size. To meet the requirements for
delay-sensitive applications (like real-time spectral plotter),
reduce subbuf_size and increase n_subbufs.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 67a2a4b..e6307b8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -2072,7 +2072,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_modal_eeprom);
 	sc->rfs_chan_spec_scan = relay_open("spectral_scan",
 					    sc->debug.debugfs_phy,
-					    262144, 4, &rfs_spec_scan_cb,
+					    1024, 256, &rfs_spec_scan_cb,
 					    NULL);
 	debugfs_create_file("spectral_scan_ctl", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc,
-- 
1.7.4.1

