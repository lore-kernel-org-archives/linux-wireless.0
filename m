Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45648 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758873AbcINQcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 12:32:46 -0400
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
Subject: [PATCH] ath10k: Fix spinlock use in coverage class hack
Date: Wed, 14 Sep 2016 18:32:31 +0200
Message-Id: <20160914163231.20863-1-benjamin@sipsolutions.net> (sfid-20160914_183249_785182_181A4C1D)
In-Reply-To: <8760q0j8st.fsf@kamboji.qca.qualcomm.com>
References: <8760q0j8st.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k_hw_qca988x_set_coverage_class needs to hold both conf_mutex and
the data_lock spin lock for parts of the function. However, data_lock
is only needed while storing the coverage_class to store the value that
the card is configured to.

Fix the locking issue by only holding data_lock for the required duration.

Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
---

And yes, I fully agree with your points of it being rather fragile. But as
you said, it should be entirely safe if not used. Obviously a firmware
implementation would be preferential.

This locking issue was pretty unnecessary. Lets see if any more issues show
up in a closer review.

 drivers/net/wireless/ath/ath10k/core.h | 2 +-
 drivers/net/wireless/ath/ath10k/hw.c   | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 89b07be..5f8c31f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -915,7 +915,7 @@ struct ath10k {
 	struct work_struct set_coverage_class_work;
 	/* protected by conf_mutex */
 	struct {
-		/* protected by data_lock */
+		/* writing also protected by data_lock */
 		s16 coverage_class;
 
 		u32 reg_phyclk;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index e182f09..bd5ca6a 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -243,7 +243,6 @@ static void ath10k_hw_qca988x_set_coverage_class(struct ath10k *ar,
 	u32 fw_dbglog_level;
 
 	mutex_lock(&ar->conf_mutex);
-	spin_lock_bh(&ar->data_lock);
 
 	/* Only modify registers if the core is started. */
 	if ((ar->state != ATH10K_STATE_ON) &&
@@ -356,12 +355,14 @@ static void ath10k_hw_qca988x_set_coverage_class(struct ath10k *ar,
 
 store_regs:
 	/* After an error we will not retry setting the coverage class. */
+	spin_lock_bh(&ar->data_lock);
 	ar->fw_coverage.coverage_class = value;
+	spin_unlock_bh(&ar->data_lock);
+
 	ar->fw_coverage.reg_slottime_conf = slottime_reg;
 	ar->fw_coverage.reg_ack_cts_timeout_conf = timeout_reg;
 
 unlock:
-	spin_unlock_bh(&ar->data_lock);
 	mutex_unlock(&ar->conf_mutex);
 }
 
-- 
2.9.3
