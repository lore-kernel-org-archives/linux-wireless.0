Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35446 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbaHHJbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:31:39 -0400
Received: by mail-wg0-f49.google.com with SMTP id k14so5245628wgh.8
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 02:31:38 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ben Greear <greearb@candelatech.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/3] ath10k: dont duplicate service-pipe mapping
Date: Fri,  8 Aug 2014 11:22:14 +0200
Message-Id: <1407489735-28091-3-git-send-email-michal.kazior@tieto.com> (sfid-20140808_113149_672043_B03B25AA)
In-Reply-To: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com>
References: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com>
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
index 38a9546..fee875b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1056,68 +1056,57 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 		tasklet_kill(&ar_pci->pipe_info[i].intr);
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
 
 	ath10k_dbg(ATH10K_DBG_PCI, "pci hif map service\n");
 
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

