Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42644 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3GPHjJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:09 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 06/10] ath10k: move free_vdev_map initialization
Date: Tue, 16 Jul 2013 09:38:55 +0200
Message-ID: <1373960339-8525-7-git-send-email-michal.kazior@tieto.com> (sfid-20130716_100606_850536_FD48AFFB)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is necessary for hw reconfiguration to work.
Since mac80211 is not calling remove_interface()
is such case we must reset free_vdev_map.

Also use a define instead of a hardcoded value for
vdev map initialization.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 01c1d82..0e4a704 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -458,8 +458,6 @@ struct ath10k *ath10k_core_create(void *hif_priv, struct device *dev,
 	ar->hif.priv = hif_priv;
 	ar->hif.ops = hif_ops;
 
-	ar->free_vdev_map = 0xFF; /* 8 vdevs */
-
 	init_completion(&ar->scan.started);
 	init_completion(&ar->scan.completed);
 	init_completion(&ar->scan.on_channel);
@@ -590,6 +588,8 @@ int ath10k_core_start(struct ath10k *ar)
 	if (status)
 		goto err_disconnect_htc;
 
+	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+
 	return 0;
 
 err_disconnect_htc:
-- 
1.7.9.5

