Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45696 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbeACAvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 19:51:08 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Support use of channel 173
Date: Tue,  2 Jan 2018 16:51:01 -0800
Message-Id: <1514940661-13590-1-git-send-email-greearb@candelatech.com> (sfid-20180103_015112_591855_0345B73E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The India regulatory domain allows CH 173, so add that to the
available channel list.  I verified basic connectivity between
a 9880 and 9984 NIC.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 3 ++-
 drivers/net/wireless/ath/ath10k/mac.c  | 3 +++
 drivers/net/wireless/ath/ath10k/wmi.c  | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index bcee3ec..cdcdff1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -46,7 +46,8 @@
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5 * HZ)
 #define ATH10K_CONNECTION_LOSS_HZ (3 * HZ)
-#define ATH10K_NUM_CHANS 40
+#define ATH10K_NUM_CHANS 41
+#define ATH10K_MAX_5G_CHAN 173
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c715ba1..3c03edf 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -8540,6 +8540,9 @@ static const struct ieee80211_channel ath10k_5ghz_channels[] = {
 	CHAN5G(161, 5805, 0),
 	CHAN5G(165, 5825, 0),
 	CHAN5G(169, 5845, 0),
+	CHAN5G(173, 5865, 0),
+	/* If you add more, you may need to change ATH10K_MAX_5G_CHAN */
+	/* And you will definitely need to change ATH10K_NUM_CHANS in core.h */
 };
 
 struct ath10k *ath10k_mac_create(size_t priv_size)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f29ce83..905af93 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2398,7 +2398,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	 */
 	if (channel >= 1 && channel <= 14) {
 		status->band = NL80211_BAND_2GHZ;
-	} else if (channel >= 36 && channel <= 169) {
+	} else if (channel >= 36 && channel <= ATH10K_MAX_5G_CHAN) {
 		status->band = NL80211_BAND_5GHZ;
 	} else {
 		/* Shouldn't happen unless list of advertised channels to
-- 
2.4.11
