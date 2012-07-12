Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:53665 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2GLJXT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 05:23:19 -0400
Subject: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 12:13:12 +0300
Message-ID: <20120712091311.9751.60082.stgit@localhost6.localdomain6> (sfid-20120712_112331_396010_222B61EB)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl was incorrectly assuming that IEEE80211_NUM_BANDS will always be 2
and used that also in the firmware WMI interface definitions. But after
the support for 60 GHz was added to cfg80211 IEEE80211_NUM_BANDS changed to 3
and this can cause all sort of problems, possibly even memory corruption.
I only found this during code review and didn't notice any bugs, but I'm
sure there are a few lurking somewhere.

To fix this rename unused A_NUM_BANDS to ATH6KL_NUM_BANDS, which is
always defined to be 2, and use that in WMI.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |   12 ++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.h |    4 ++--
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3629e86..b3d5576 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2636,11 +2636,13 @@ static int ath6kl_set_bitrate_mask64(struct wmi *wmi, u8 if_idx,
 {
 	struct sk_buff *skb;
 	int ret, mode, band;
-	u64 mcsrate, ratemask[IEEE80211_NUM_BANDS];
+	u64 mcsrate, ratemask[ATH6KL_NUM_BANDS];
 	struct wmi_set_tx_select_rates64_cmd *cmd;
 
 	memset(&ratemask, 0, sizeof(ratemask));
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+
+	/* only check 2.4 and 5 GHz bands, skip the rest */
+	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
 		/* copy legacy rate mask */
 		ratemask[band] = mask->control[band].legacy;
 		if (band == IEEE80211_BAND_5GHZ)
@@ -2686,11 +2688,13 @@ static int ath6kl_set_bitrate_mask32(struct wmi *wmi, u8 if_idx,
 {
 	struct sk_buff *skb;
 	int ret, mode, band;
-	u32 mcsrate, ratemask[IEEE80211_NUM_BANDS];
+	u32 mcsrate, ratemask[ATH6KL_NUM_BANDS];
 	struct wmi_set_tx_select_rates32_cmd *cmd;
 
 	memset(&ratemask, 0, sizeof(ratemask));
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+
+	/* only check 2.4 and 5 GHz bands, skip the rest */
+	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
 		/* copy legacy rate mask */
 		ratemask[band] = mask->control[band].legacy;
 		if (band == IEEE80211_BAND_5GHZ)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b5deaff..c8f94e1 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -48,7 +48,7 @@
 
 #define A_BAND_24GHZ           0
 #define A_BAND_5GHZ            1
-#define A_NUM_BANDS            2
+#define ATH6KL_NUM_BANDS       2
 
 /* in ms */
 #define WMI_IMPLICIT_PSTREAM_INACTIVITY_INT 5000
@@ -847,7 +847,7 @@ struct wmi_begin_scan_cmd {
 	u8 scan_type;
 
 	/* Supported rates to advertise in the probe request frames */
-	struct wmi_supp_rates supp_rates[IEEE80211_NUM_BANDS];
+	struct wmi_supp_rates supp_rates[ATH6KL_NUM_BANDS];
 
 	/* how many channels follow */
 	u8 num_ch;

