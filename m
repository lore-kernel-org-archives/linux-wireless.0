Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34489 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757368Ab3GENPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 11/16] ath10k: rename hif callback
Date: Fri,  5 Jul 2013 16:15:12 +0300
Message-Id: <1373030117-18077-12-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151534_113984_0F339E4E)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

The `set_callbacks` is a more appopriate name for
the function. Let's leave `init` for something
else.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hif.h |   10 +++++-----
 drivers/net/wireless/ath/ath10k/htc.c |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 73a24d4..010e265 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -66,8 +66,8 @@ struct ath10k_hif_ops {
 	 */
 	void (*send_complete_check)(struct ath10k *ar, u8 pipe_id, int force);
 
-	void (*init)(struct ath10k *ar,
-		     struct ath10k_hif_cb *callbacks);
+	void (*set_callbacks)(struct ath10k *ar,
+			      struct ath10k_hif_cb *callbacks);
 
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 };
@@ -122,10 +122,10 @@ static inline void ath10k_hif_send_complete_check(struct ath10k *ar,
 	ar->hif.ops->send_complete_check(ar, pipe_id, force);
 }
 
-static inline void ath10k_hif_init(struct ath10k *ar,
-				   struct ath10k_hif_cb *callbacks)
+static inline void ath10k_hif_set_callbacks(struct ath10k *ar,
+					    struct ath10k_hif_cb *callbacks)
 {
-	ar->hif.ops->init(ar, callbacks);
+	ar->hif.ops->set_callbacks(ar, callbacks);
 }
 
 static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7b5c334..f37a6e1 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -987,7 +987,7 @@ struct ath10k_htc *ath10k_htc_create(struct ath10k *ar,
 	/* Get HIF default pipe for HTC message exchange */
 	ep = &htc->endpoint[ATH10K_HTC_EP_0];
 
-	ath10k_hif_init(ar, &htc_callbacks);
+	ath10k_hif_set_callbacks(ar, &htc_callbacks);
 	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
 
 	init_completion(&htc->ctl_resp);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 0076a63..1a59638 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -744,8 +744,8 @@ static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 	ath10k_ce_per_engine_service(ar, pipe);
 }
 
-static void ath10k_pci_hif_post_init(struct ath10k *ar,
-				     struct ath10k_hif_cb *callbacks)
+static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
+					 struct ath10k_hif_cb *callbacks)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
@@ -1742,7 +1742,7 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.map_service_to_pipe	= ath10k_pci_hif_map_service_to_pipe,
 	.get_default_pipe	= ath10k_pci_hif_get_default_pipe,
 	.send_complete_check	= ath10k_pci_hif_send_complete_check,
-	.init			= ath10k_pci_hif_post_init,
+	.set_callbacks		= ath10k_pci_hif_set_callbacks,
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 };
 
-- 
1.7.9.5

