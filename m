Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52755 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934314AbcKWK1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:27:04 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: fix scheduled scan result handling for newer chips
Date: Wed, 23 Nov 2016 10:25:31 +0000
Message-Id: <1479896731-5091-13-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_112731_402756_8449C93A)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan results for scheduled scan as retrieved from the device
have changed. A field has been added which is not needed. However,
the appended info is. Luckily they are versioned so check that to
find out the location of the appended data.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 24 +++++++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  7 +++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 38b1563..23795f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3257,6 +3257,28 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 	return 0;
 }
 
+static struct brcmf_pno_net_info_le *
+brcmf_get_netinfo_array(struct brcmf_pno_scanresults_le *pfn_v1)
+{
+	struct brcmf_pno_scanresults_v2_le *pfn_v2;
+	struct brcmf_pno_net_info_le *netinfo;
+
+	switch (pfn_v1->version) {
+	default:
+		WARN_ON(1);
+		/* fall-thru */
+	case cpu_to_le32(1):
+		netinfo = (struct brcmf_pno_net_info_le *)(pfn_v1 + 1);
+		break;
+	case cpu_to_le32(2):
+		pfn_v2 = (struct brcmf_pno_scanresults_v2_le *)pfn_v1;
+		netinfo = (struct brcmf_pno_net_info_le *)(pfn_v2 + 1);
+		break;
+	}
+
+	return netinfo;
+}
+
 /* PFN result doesn't have all the info which are required by the supplicant
  * (For e.g IEs) Do a target Escan so that sched scan results are reported
  * via wl_inform_single_bss in the required format. Escan does require the
@@ -3309,7 +3331,7 @@ static int brcmf_start_internal_escan(struct brcmf_if *ifp,
 	}
 
 	data += sizeof(struct brcmf_pno_scanresults_le);
-	netinfo_start = (struct brcmf_pno_net_info_le *)data;
+	netinfo_start = brcmf_get_netinfo_array(pfn_result);
 
 	for (i = 0; i < result_count; i++) {
 		netinfo = &netinfo_start[i];
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 64aed2d..9a1eb5a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -785,6 +785,13 @@ struct brcmf_pno_scanresults_le {
 	__le32 count;
 };
 
+struct brcmf_pno_scanresults_v2_le {
+	__le32 version;
+	__le32 status;
+	__le32 count;
+	__le32 scan_ch_bucket;
+};
+
 /**
  * struct brcmf_pno_macaddr_le - to configure PNO macaddr randomization.
  *
-- 
1.9.1
