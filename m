Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53374 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753757AbdCWNay (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 09:30:54 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH v2 2/3] ath10k: add support for channels in licensed bands
Date: Thu, 23 Mar 2017 14:30:47 +0100
Message-Id: <20170323133048.30062-3-sw@simonwunderlich.de> (sfid-20170323_143103_391729_474DF3A9)
In-Reply-To: <20170323133048.30062-1-sw@simonwunderlich.de>
References: <20170323133048.30062-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many chips support channels in licensed bands. Add support for those,
along with a corresponding kernel config option to disable them by
default. Note that these channels are not selectable even if the
option has been compiled unless the user modifies the regulatory
database to explicitly enable the corresponding channels.

NOTE:  These channels must not be used in most regulatory
domains unless you have a license from the FCC or similar!

This patch also re-introduces the phy_mode_to_band function to allow
selecting the band in a more clean way.

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
---
Changes to PATCHv1:
     * re-introduce and clean up phy to mode conversion (thanks Sebastian)
---
 drivers/net/wireless/ath/ath10k/Kconfig | 20 +++++++++++++
 drivers/net/wireless/ath/ath10k/core.h  |  4 +++
 drivers/net/wireless/ath/ath10k/mac.c   | 10 +++++++
 drivers/net/wireless/ath/ath10k/wmi.c   | 53 +++++++++++++++++++++++----------
 4 files changed, 71 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index b4241cf9b7ed..13a23ed33f91 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -53,3 +53,23 @@ config ATH10K_DFS_CERTIFIED
 	---help---
 	This option enables DFS support for initiating radiation on
 	ath10k.
+
+config ATH10K_LICENSED_CHAN
+	bool "Support channels in licensed bands"
+	depends on ATH10K && CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  This option enables support for licensed channels on such as
+          4.9 GHz (public safety).
+
+	  These are PUBLIC SAFETY CHANNELS and MUST NOT BE USED in most
+	  regulatory domains UNLESS YOU HAVE A FULL LICENSE for their use from
+	  your local radio regulator, e.g. the FCC or equivalent. Using these
+	  channels without proper authorisation may result in serious legal
+	  consequences.
+
+	  You will also have to build a regulatory database with these channels
+	  enabled to actually use them.
+
+	  If you are a distro kernel builder or have any doubt whatsoever about
+	  your legal ability to use these channels, say N.
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d4b9a0ec1bdc..7674641537b4 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -46,7 +46,11 @@
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5 * HZ)
 #define ATH10K_CONNECTION_LOSS_HZ (3 * HZ)
+#ifdef CONFIG_ATH10K_LICENSED_CHAN
+#define ATH10K_NUM_CHANS 47
+#else
 #define ATH10K_NUM_CHANS 40
+#endif
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index d60086cdc584..81848e0a3a5e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7669,6 +7669,16 @@ static const struct ieee80211_channel ath10k_5ghz_channels[] = {
 	CHAN5G(161, 5805, 0),
 	CHAN5G(165, 5825, 0),
 	CHAN5G(169, 5845, 0),
+#ifdef CONFIG_ATH10K_LICENSED_CHAN
+	CHAN5G(184, 4920, 0),
+	CHAN5G(188, 4940, 0),
+	CHAN5G(192, 4960, 0),
+	CHAN5G(196, 4980, 0),
+	CHAN5G(8,   5040, 0),
+	CHAN5G(12,  5060, 0),
+	CHAN5G(16,  5080, 0),
+#endif
+
 };
 
 struct ath10k *ath10k_mac_create(size_t priv_size)
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4e60caec7ab4..d78c778eae4c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2271,6 +2271,41 @@ static bool ath10k_wmi_rx_is_decrypted(struct ath10k *ar,
 	return true;
 }
 
+static inline enum nl80211_band phy_mode_to_band(u32 phy_mode, u32 channel)
+{
+	enum nl80211_band band;
+
+	switch (phy_mode) {
+	case MODE_11A:
+	case MODE_11NA_HT20:
+	case MODE_11NA_HT40:
+	case MODE_11AC_VHT20:
+	case MODE_11AC_VHT40:
+	case MODE_11AC_VHT80:
+		band = NL80211_BAND_5GHZ;
+	break;
+	case MODE_11B:
+		/* Hardware can Rx CCK rates on 5GHz. In that case phy_mode is
+		 * set to MODE_11B.
+		 */
+		if (channel < 1 || channel > 14) {
+			band = NL80211_BAND_5GHZ;
+			break;
+		}
+	case MODE_11G:
+	case MODE_11GONLY:
+	case MODE_11NG_HT20:
+	case MODE_11NG_HT40:
+	case MODE_11AC_VHT20_2G:
+	case MODE_11AC_VHT40_2G:
+	case MODE_11AC_VHT80_2G:
+	default:
+		band = NL80211_BAND_2GHZ;
+	}
+
+	return band;
+}
+
 int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_mgmt_rx_ev_arg arg = {};
@@ -2320,22 +2355,8 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 			__le64_to_cpu(arg.ext_info.rx_mac_timestamp);
 		status->flag |= RX_FLAG_MACTIME_END;
 	}
-	/* Hardware can Rx CCK rates on 5GHz. In that case phy_mode is set to
-	 * MODE_11B. This means phy_mode is not a reliable source for the band
-	 * of mgmt rx.
-	 */
-	if (channel >= 1 && channel <= 14) {
-		status->band = NL80211_BAND_2GHZ;
-	} else if (channel >= 36 && channel <= 169) {
-		status->band = NL80211_BAND_5GHZ;
-	} else {
-		/* Shouldn't happen unless list of advertised channels to
-		 * mac80211 has been changed.
-		 */
-		WARN_ON_ONCE(1);
-		dev_kfree_skb(skb);
-		return 0;
-	}
+
+	status->band = phy_mode_to_band(phy_mode, channel);
 
 	if (phy_mode == MODE_11B && status->band == NL80211_BAND_5GHZ)
 		ath10k_dbg(ar, ATH10K_DBG_MGMT, "wmi mgmt rx 11b (CCK) on 5GHz\n");
-- 
2.11.0
