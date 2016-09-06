Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8534 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935521AbcIFTGj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 15:06:39 -0400
From: Thomas Pedersen <twp@qca.qualcomm.com>
To: ath10k <ath10k@lists.infradead.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <twp@qca.qualcomm.com>
Subject: [PATCH] ath10k: enable peer stats by default
Date: Tue, 6 Sep 2016 12:05:28 -0700
Message-ID: <1473188728-14995-1-git-send-email-twp@qca.qualcomm.com> (sfid-20160906_210650_900403_4F287E18)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IFTYPE_MESH_POINT need to rely on these for accurate path
selection metrics. Other modes will probably also find
them useful. Enabling peer stats has the side effect of
reducing max number of STAs from 128 to 118. There should
be negligible performance impact.

If users really need 128 STAs and don't mind losing out on
peer stats, they can still disable them:

echo 0 > debugfs/ieee80211/phyn/ath10k/peer_stats

Signed-off-by: Thomas Pedersen <twp@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c9d163e..c0ab4f4 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2145,6 +2145,9 @@ static void ath10k_core_register_work(struct work_struct *work)
 	struct ath10k *ar = container_of(work, struct ath10k, register_work);
 	int status;
 
+	/* peer stats are enabled by default */
+	set_bit(ATH10K_FLAG_PEER_STATS, &ar->dev_flags);
+
 	status = ath10k_core_probe_fw(ar);
 	if (status) {
 		ath10k_err(ar, "could not probe fw (%d)\n", status);
-- 
2.1.4
