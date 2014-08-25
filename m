Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:35921 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaHYK3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 06:29:13 -0400
Received: by mail-la0-f50.google.com with SMTP id pi18so12461629lab.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 03:29:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/3] ath10k: dont duplicate service-pipe mapping
Date: Mon, 25 Aug 2014 12:19:22 +0200
Message-Id: <1408961963-3682-3-git-send-email-michal.kazior@tieto.com> (sfid-20140825_122916_302142_55E3D56E)
In-Reply-To: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
References: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mapping is already defined in a structure. It
makes little sense to duplicate information stored
in it within a function.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 77 +++++++++++++++--------------------
 1 file changed, 33 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 71ac018..fa0e245 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1094,68 +1094,57 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 	del_timer_sync(&ar_pci->rx_post_retry);
 }
 
-/* TODO - temporary mapping while we have too few CE's */
 static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 					      u16 service_id, u8 *ul_pipe,
 					      u8 *dl_pipe, int *ul_is_polled,
 					      int *dl_is_polled)
 {
-	int ret = 0;
+	const struct service_to_pipe *entry;
+	bool ul_set = false, dl_set = false;
+	int i;
 
 	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif map service\n");
 
 	/* polling for received messages not supported */
 	*dl_is_polled = 0;
 
-	switch (service_id) {
-	case ATH10K_HTC_SVC_ID_HTT_DATA_MSG:
-		/*
-		 * Host->target HTT gets its own pipe, so it can be polled
-		 * while other pipes are interrupt driven.
-		 */
-		*ul_pipe = 4;
-		/*
-		 * Use the same target->host pipe for HTC ctrl, HTC raw
-		 * streams, and HTT.
-		 */
-		*dl_pipe = 1;
-		break;
-
-	case ATH10K_HTC_SVC_ID_RSVD_CTRL:
-	case ATH10K_HTC_SVC_ID_TEST_RAW_STREAMS:
-		/*
-		 * Note: HTC_RAW_STREAMS_SVC is currently unused, and
-		 * HTC_CTRL_RSVD_SVC could share the same pipe as the
-		 * WMI services.  So, if another CE is needed, change
-		 * this to *ul_pipe = 3, which frees up CE 0.
-		 */
-		/* *ul_pipe = 3; */
-		*ul_pipe = 0;
-		*dl_pipe = 1;
-		break;
+	for (i = 0; i < ARRAY_SIZE(target_service_to_ce_map_wlan); i++) {
+		entry = &target_service_to_ce_map_wlan[i];
 
-	case ATH10K_HTC_SVC_ID_WMI_DATA_BK:
-	case ATH10K_HTC_SVC_ID_WMI_DATA_BE:
-	case ATH10K_HTC_SVC_ID_WMI_DATA_VI:
-	case ATH10K_HTC_SVC_ID_WMI_DATA_VO:
+		if (entry->service_id != service_id)
+			continue;
 
-	case ATH10K_HTC_SVC_ID_WMI_CONTROL:
-		*ul_pipe = 3;
-		*dl_pipe = 2;
-		break;
+		switch (entry->pipedir) {
+		case PIPEDIR_NONE:
+			break;
+		case PIPEDIR_IN:
+			WARN_ON(dl_set);
+			*dl_pipe = entry->pipenum;
+			dl_set = true;
+			break;
+		case PIPEDIR_OUT:
+			WARN_ON(ul_set);
+			*ul_pipe = entry->pipenum;
+			ul_set = true;
+			break;
+		case PIPEDIR_INOUT:
+			WARN_ON(dl_set);
+			WARN_ON(ul_set);
+			*dl_pipe = entry->pipenum;
+			*ul_pipe = entry->pipenum;
+			dl_set = true;
+			ul_set = true;
+			break;
+		}
+	}
 
-		/* pipe 5 unused   */
-		/* pipe 6 reserved */
-		/* pipe 7 reserved */
+	if (WARN_ON(!ul_set || !dl_set))
+		return -ENOENT;
 
-	default:
-		ret = -1;
-		break;
-	}
 	*ul_is_polled =
 		(host_ce_config_wlan[*ul_pipe].flags & CE_ATTR_DIS_INTR) != 0;
 
-	return ret;
+	return 0;
 }
 
 static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
-- 
1.8.5.3

