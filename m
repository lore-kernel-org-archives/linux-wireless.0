Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58597 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758049AbcILOLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 10:11:20 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "ath10k @ lists . infradead . org" <ath10k@lists.infradead.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        michal.kazior@tieto.com,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: [PATCH] ath10k: Add missing CONFIG_ATH10K_DEBUGFS check
Date: Mon, 12 Sep 2016 16:11:05 +0200
Message-Id: <20160912141105.24085-1-benjamin@sipsolutions.net> (sfid-20160912_161127_888907_D93318F7)
In-Reply-To: <871t0tp1ad.fsf@kamboji.qca.qualcomm.com>
References: <871t0tp1ad.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "ath10k: allow setting coverage class" was missing a check for
CONFIG_ATH10K_DEBUGFS so it would try to use non-existing struct elements
in some configurations. Fix this by adding the appropriate ifdef.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
---

Sorry, so turns out the kbuild test robot is correct and I forgot the ifdef
to check for CONFIG_ATH10K_DEBUGFS, so here a fixup commit for it.

Other than that everything looks good to me in the pending branch.

Benjamin


 drivers/net/wireless/ath/ath10k/hw.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index c52b5f4..e182f09 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -338,8 +338,13 @@ static void ath10k_hw_qca988x_set_coverage_class(struct ath10k *ar,
 	 * set the registers again if the firmware does an internal reset and
 	 * this way we will be notified of the event.
 	 */
+#ifdef CONFIG_ATH10K_DEBUGFS
 	fw_dbglog_mask = ar->debug.fw_dbglog_mask;
 	fw_dbglog_level = ar->debug.fw_dbglog_level;
+#else
+	fw_dbglog_mask = 0;
+	fw_dbglog_level = 0;
+#endif
 
 	if (value > 0) {
 		if (fw_dbglog_level > ATH10K_DBGLOG_LEVEL_WARN)
-- 
2.9.3
