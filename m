Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:11045 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbEDSZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 14:25:46 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: increase relay buffer size of spectral scan
Date: Mon, 4 May 2015 11:21:24 -0700
Message-ID: <1430763684-1630-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150504_202549_601536_AA44521B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spectral scan supported by ath10k has capability to monitor and report
through whole bands and channels, but current buffer size is too small
to save reported spectral scan data.
This results in dropping 5G channel reports at all when dual band card
is used, so that users are not able to analyze spectral environments.
Hence increase the buffer size to fix the problem.

A spectral data size is vary based on the number of bins, so the unit
buffer size, 1140, is chose to minimize relay buffer fragmentation.

The total buffer size is also chose in tradeoff with spectral scan
support vs. kernel memory consumption.
Since theoretical maximum buffer size, 9.5MB, can be consumed with
512 bins in dual bands, we target to cover up to 128 bins for all
channels in dual bands and due to the buffer size limitation,
spectral scan with bin number bigger than 128 needs to be run on
single band each.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index d22addf..8dcd424 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -519,9 +519,12 @@ int ath10k_spectral_vif_stop(struct ath10k_vif *arvif)
 
 int ath10k_spectral_create(struct ath10k *ar)
 {
+	/* The buffer size covers whole channels in dual bands up to 128 bins.
+	 * Scan with bigger than 128 bins needs to be run on single band each.
+	 */
 	ar->spectral.rfs_chan_spec_scan = relay_open("spectral_scan",
 						     ar->debug.debugfs_phy,
-						     1024, 256,
+						     1140, 2500,
 						     &rfs_spec_scan_cb, NULL);
 	debugfs_create_file("spectral_scan_ctl",
 			    S_IRUSR | S_IWUSR,
-- 
1.9.1

