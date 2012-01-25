Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:38335 "HELO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753307Ab2AYEx6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 23:53:58 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: update BSS parameters in dump_station_info()
Date: Tue, 24 Jan 2012 20:50:25 -0800
Message-Id: <1327467025-5190-2-git-send-email-bzhao@marvell.com> (sfid-20120125_055400_931718_441663E4)
In-Reply-To: <1327467025-5190-1-git-send-email-bzhao@marvell.com>
References: <1327467025-5190-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This enables user to check beacon interval, DTIM period, short slot
time and short preamble information using "iw dev mlan0 link" command
when station is in connected state.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   17 +++++++++++++++++
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/scan.c     |    6 ++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 00f1005..6fef492 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -557,6 +557,23 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 	/* bit rate is in 500 kb/s units. Convert it to 100kb/s units */
 	sinfo->txrate.legacy = rate.rate * 5;
 
+	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+		sinfo->filled |= STATION_INFO_BSS_PARAM;
+		sinfo->bss_param.flags = 0;
+		if (priv->curr_bss_params.bss_descriptor.cap_info_bitmap &
+						WLAN_CAPABILITY_SHORT_PREAMBLE)
+			sinfo->bss_param.flags |=
+					BSS_PARAM_FLAGS_SHORT_PREAMBLE;
+		if (priv->curr_bss_params.bss_descriptor.cap_info_bitmap &
+						WLAN_CAPABILITY_SHORT_SLOT_TIME)
+			sinfo->bss_param.flags |=
+					BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
+		sinfo->bss_param.dtim_period =
+			priv->curr_bss_params.bss_descriptor.dtim_period;
+		sinfo->bss_param.beacon_interval =
+			priv->curr_bss_params.bss_descriptor.beacon_period;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6712ea8..3dc0f72 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -249,6 +249,7 @@ struct mwifiex_bssdescriptor {
 	u32 channel;
 	u32 freq;
 	u16 beacon_period;
+	u8 dtim_period;
 	u8 erp_flags;
 	u32 bss_mode;
 	u8 supported_rates[MWIFIEX_SUPPORTED_RATES];
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 98f1ca9..1352085 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1086,6 +1086,7 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 	struct ieee_types_vendor_specific *vendor_ie;
 	const u8 wpa_oui[4] = { 0x00, 0x50, 0xf2, 0x01 };
 	const u8 wmm_oui[4] = { 0x00, 0x50, 0xf2, 0x02 };
+	struct ieee80211_tim_ie *tim_ie;
 
 	found_data_rate_ie = false;
 	rate_size = 0;
@@ -1258,6 +1259,11 @@ mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
+		case WLAN_EID_TIM:
+			tim_ie = (void *) (current_ptr +
+					 sizeof(struct ieee_types_header));
+			bss_entry->dtim_period = tim_ie->dtim_period;
+			break;
 		default:
 			break;
 		}
-- 
1.7.0.2

