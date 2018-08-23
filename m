Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:6039 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726246AbeHWPQl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 11:16:41 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 2/9] wil6210: add support for channel 4
Date: Thu, 23 Aug 2018 14:47:06 +0300
Message-Id: <1535024833-15178-3-git-send-email-merez@codeaurora.org> (sfid-20180823_134749_448488_C36E6697)
In-Reply-To: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
References: <1535024833-15178-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

wil6210 supports channels 1-3 of the 60GHz band.
New FW added support for channel 4. Add support for channel 4 also in
wil6210 driver.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/main.c     |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h  |  2 ++
 drivers/net/wireless/ath/wil6210/wmi.h      |  1 +
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index f79c337..1bdb026 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -48,9 +48,29 @@
 	CHAN60G(1, 0),
 	CHAN60G(2, 0),
 	CHAN60G(3, 0),
-/* channel 4 not supported yet */
+	CHAN60G(4, 0),
 };
 
+static int wil_num_supported_channels(struct wil6210_priv *wil)
+{
+	int num_channels = ARRAY_SIZE(wil_60ghz_channels);
+
+	if (!test_bit(WMI_FW_CAPABILITY_CHANNEL_4, wil->fw_capabilities))
+		num_channels--;
+
+	return num_channels;
+}
+
+void update_supported_bands(struct wil6210_priv *wil)
+{
+	struct wiphy *wiphy = wil_to_wiphy(wil);
+
+	wil_dbg_misc(wil, "update supported bands");
+
+	wiphy->bands[NL80211_BAND_60GHZ]->n_channels =
+						wil_num_supported_channels(wil);
+}
+
 /* Vendor id to be used in vendor specific command and events
  * to user space.
  * NOTE: The authoritative place for definition of QCA_NL80211_VENDOR_ID,
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7debed6..8820cee 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -1154,6 +1154,8 @@ void wil_refresh_fw_capabilities(struct wil6210_priv *wil)
 		wil->max_agg_wsize = WIL_MAX_AGG_WSIZE;
 		wil->max_ampdu_size = WIL_MAX_AMPDU_SIZE;
 	}
+
+	update_supported_bands(wil);
 }
 
 void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 17c294b..85565de 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -1370,4 +1370,6 @@ int wmi_addba_rx_resp_edma(struct wil6210_priv *wil, u8 mid, u8 cid,
 			   u8 tid, u8 token, u16 status, bool amsdu,
 			   u16 agg_wsize, u16 timeout);
 
+void update_supported_bands(struct wil6210_priv *wil);
+
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index 139acb2..f430e1d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -103,6 +103,7 @@ enum wmi_fw_capability {
 	WMI_FW_CAPABILITY_AMSDU				= 23,
 	WMI_FW_CAPABILITY_RAW_MODE			= 24,
 	WMI_FW_CAPABILITY_TX_REQ_EXT			= 25,
+	WMI_FW_CAPABILITY_CHANNEL_4			= 26,
 	WMI_FW_CAPABILITY_MAX,
 };
 
-- 
1.9.1
