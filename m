Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34491 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbbESMKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 08:10:09 -0400
Received: by wicmc15 with SMTP id mc15so114392420wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 05:10:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: add new 4addr related fw_feature
Date: Tue, 19 May 2015 14:09:34 +0200
Message-Id: <1432037374-26339-1-git-send-email-michal.kazior@tieto.com> (sfid-20150519_141013_153680_5CF29987)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some firmware revisions pad 4th hw address in
Native Wifi Rx decap. This is the case with 10.x
and it was assumed that this is true for all
firmware images.

However QCA988X with 999.999.0.636 and QCA61X4
with WLAN.RM.2.0-00088 don't have the padding.
Hence add a feature flag indicating that the
padding isn't present so firmware images can
advertise it appropriately. This way driver will
behave as it was before with old firmware blobs
and doesn't cause any regressions from user
perspective.

Effectively this patch enables QCA988X with
999.999.0.636 and QCA61X4 with WLAN.RM.2.0-00088
to set up client bridging provided user has an
updated firmware blob.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  5 +++++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 ++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 827b3d79ed0c..70fcdc9c2758 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -463,6 +463,11 @@ enum ath10k_fw_features {
 	/* Don't trust error code from otp.bin */
 	ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
 
+	/* Some firmware revisions pad 4th hw address to 4 byte boundary making
+	 * it 8 bytes long in Native Wifi Rx decap.
+	 */
+	ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index b26e32f42656..89eb16b30fc4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -965,10 +965,16 @@ static void ath10k_process_rx(struct ath10k *ar,
 	ieee80211_rx(ar->hw, skb);
 }
 
-static int ath10k_htt_rx_nwifi_hdrlen(struct ieee80211_hdr *hdr)
+static int ath10k_htt_rx_nwifi_hdrlen(struct ath10k *ar,
+				      struct ieee80211_hdr *hdr)
 {
-	/* nwifi header is padded to 4 bytes. this fixes 4addr rx */
-	return round_up(ieee80211_hdrlen(hdr->frame_control), 4);
+	int len = ieee80211_hdrlen(hdr->frame_control);
+
+	if (!test_bit(ATH10K_FW_FEATURE_NO_NWIFI_DECAP_4ADDR_PADDING,
+		      ar->fw_features))
+		len = round_up(len, 4);
+
+	return len;
 }
 
 static void ath10k_htt_rx_h_undecap_raw(struct ath10k *ar,
@@ -1067,7 +1073,7 @@ static void ath10k_htt_rx_h_undecap_nwifi(struct ath10k *ar,
 
 	/* pull decapped header and copy SA & DA */
 	hdr = (struct ieee80211_hdr *)msdu->data;
-	hdr_len = ath10k_htt_rx_nwifi_hdrlen(hdr);
+	hdr_len = ath10k_htt_rx_nwifi_hdrlen(ar, hdr);
 	ether_addr_copy(da, ieee80211_get_DA(hdr));
 	ether_addr_copy(sa, ieee80211_get_SA(hdr));
 	skb_pull(msdu, hdr_len);
-- 
2.1.4

