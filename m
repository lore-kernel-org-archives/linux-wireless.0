Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:35037 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab2CYOP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 10:15:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: [PATCH v2 6/9] ath6kl: remove void pointer from ath6kl_credit_setup()
Date: Sun, 25 Mar 2012 17:15:26 +0300
Message-Id: <1332684929-6405-7-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120325_161626_153873_D9FBCC6D)
In-Reply-To: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1332684929-6405-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Void pointers are bad.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    4 ++--
 drivers/net/wireless/ath/ath6kl/htc.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 187f449..9d55541 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -130,7 +130,7 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 }
 
 /* initialize and setup credit distribution */
-int ath6kl_credit_setup(void *htc_handle,
+int ath6kl_credit_setup(struct htc_target *htc_target,
 			struct ath6kl_htc_credit_info *cred_info)
 {
 	u16 servicepriority[5];
@@ -144,7 +144,7 @@ int ath6kl_credit_setup(void *htc_handle,
 	servicepriority[4] = WMI_DATA_BK_SVC; /* lowest */
 
 	/* set priority list */
-	ath6kl_htc_set_credit_dist(htc_handle, cred_info, servicepriority, 5);
+	ath6kl_htc_set_credit_dist(htc_target, cred_info, servicepriority, 5);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index e97ebc3..0ba8deb 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -594,7 +594,7 @@ int ath6kl_htc_add_rxbuf_multiple(struct htc_target *target,
 int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 				     u32 msg_look_ahead, int *n_pkts);
 
-int ath6kl_credit_setup(void *htc_handle,
+int ath6kl_credit_setup(struct htc_target *htc_target,
 			struct ath6kl_htc_credit_info *cred_info);
 
 static inline void set_htc_pkt_info(struct htc_packet *packet, void *context,
-- 
1.7.1

