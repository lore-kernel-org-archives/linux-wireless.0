Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5330 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1IUOAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 10:00:31 -0400
Date: Wed, 21 Sep 2011 16:57:29 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Report PMKSA candidate events through cfg80211
Message-ID: <20110921135729.GA26105@jouni.qca.qualcomm.com> (sfid-20110921_160037_776540_B5172DC5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows RSN pre-authentication to be used when roaming decisions are
done in the target.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h |   10 ++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

Please note that this depends on a recent change in wireless-testing.git
for cfg80211_pmksa_candidate_notify(). This commit
c9df56b48e4ff003eaebd680ec7a45342dcd03ea is not yet in ath6kl.git.


diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index dbddb91..c3d91ba 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1342,6 +1342,35 @@ static int ath6kl_wmi_scan_complete_rx(struct wmi *wmi, u8 *datap, int len)
 	return 0;
 }
 
+static int ath6kl_wmi_neighbor_report_event_rx(struct wmi *wmi, u8 *datap,
+					       int len)
+{
+	struct wmi_neighbor_report_event *ev;
+	u8 i;
+
+	if (len < sizeof(*ev))
+		return -EINVAL;
+	ev = (struct wmi_neighbor_report_event *) datap;
+	if (sizeof(*ev) + ev->num_neighbors * sizeof(struct wmi_neighbor_info)
+	    > len) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "truncated neighbor event "
+			   "(num=%d len=%d)\n", ev->num_neighbors, len);
+		return -EINVAL;
+	}
+	for (i = 0; i < ev->num_neighbors; i++) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "neighbor %d/%d - %pM 0x%x\n",
+			   i + 1, ev->num_neighbors, ev->neighbor[i].bssid,
+			   ev->neighbor[i].bss_flags);
+		cfg80211_pmksa_candidate_notify(wmi->parent_dev->net_dev, i,
+						ev->neighbor[i].bssid,
+						!!(ev->neighbor[i].bss_flags &
+						   WMI_PREAUTH_CAPABLE_BSS),
+						GFP_ATOMIC);
+	}
+
+	return 0;
+}
+
 /*
  * Target is reporting a programming error.  This is for
  * developer aid only.  Target only checks a few common violations
@@ -3153,6 +3182,7 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		break;
 	case WMI_NEIGHBOR_REPORT_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_NEIGHBOR_REPORT_EVENTID\n");
+		ret = ath6kl_wmi_neighbor_report_event_rx(wmi, datap, len);
 		break;
 	case WMI_SCAN_COMPLETE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SCAN_COMPLETE_EVENTID\n");
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index f036e78..4c99a2e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1458,6 +1458,16 @@ enum wmi_bss_flags {
 	WMI_PMKID_VALID_BSS = 0x02,
 };
 
+struct wmi_neighbor_info {
+	u8 bssid[ETH_ALEN];
+	u8 bss_flags; /* enum wmi_bss_flags */
+} __packed;
+
+struct wmi_neighbor_report_event {
+	u8 num_neighbors;
+	struct wmi_neighbor_info neighbor[0];
+} __packed;
+
 /* TKIP MIC Error Event */
 struct wmi_tkip_micerr_event {
 	u8 key_id;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
