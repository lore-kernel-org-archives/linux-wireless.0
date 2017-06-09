Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42893 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751650AbdFIMJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Eliad Peller <eliadx.peller@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 1/9] cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK
Date: Fri,  9 Jun 2017 13:08:42 +0100
Message-Id: <1497010130-16186-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140931_627930_5C931789)
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Let drivers advertise support for station-mode 4-way handshake
offloading with a new NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag.

Extend use of NL80211_ATTR_PMK attribute indicating it might be passed
as part of NL80211_CMD_CONNECT command, and contain the PSK (which is
the PMK, hence the name.)

The driver/device is assumed to handle the 4-way handshake by
itself in this case (including key derivations, etc.), instead
of relying on the supplicant.

This patch is somewhat based on this one (by Vladimir Kondratiev):
https://patchwork.kernel.org/patch/1309561/.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[arend.vanspriel@broadcom.com rebase dealing with existing ATTR_PMK]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 V3:
  - added documentation about EAPOL handshake offload for WPA-PSK.
---
 include/linux/ieee80211.h    |  1 +
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 22 ++++++++++++++++++++--
 net/wireless/nl80211.c       |  9 +++++++++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6903335..e97ca3a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2401,6 +2401,7 @@ enum ieee80211_sa_query_action {
 #define WLAN_MAX_KEY_LEN		32
 
 #define WLAN_PMKID_LEN			16
+#define WLAN_PMK_LEN			32
 
 #define WLAN_OUI_WFA			0x506f9a
 #define WLAN_OUI_TYPE_WFA_P2P		9
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa25fbb..1b288ba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -649,6 +649,7 @@ struct survey_info {
  * @wep_keys: static WEP keys, if not NULL points to an array of
  *	CFG80211_MAX_WEP_KEYS WEP keys
  * @wep_tx_key: key index (0..3) of the default TX static WEP key
+ * @psk: PSK (for devices supporting 4-way-handshake offload)
  */
 struct cfg80211_crypto_settings {
 	u32 wpa_versions;
@@ -662,6 +663,7 @@ struct cfg80211_crypto_settings {
 	bool control_port_no_encrypt;
 	struct key_params *wep_keys;
 	int wep_tx_key;
+	const u8 *psk;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b8c44b9..fc244c3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -173,6 +173,18 @@
  */
 
 /**
+ * DOC: WPA/WPA2 EAPOL handshake offload
+ *
+ * By setting @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag drivers
+ * can indicate they support offloading EAPOL handshakes for WPA/WPA2
+ * preshared key authentication. In %NL80211_CMD_CONNECT the preshared
+ * key should be specified using %NL80211_ATTR_PMK. Drivers supporting
+ * this offload may reject the %NL80211_CMD_CONNECT when no preshared
+ * key material is provided, for example when that driver does not
+ * support setting the temporal keys through %CMD_NEW_KEY.
+ */
+
+/**
  * DOC: FILS shared key authentication offload
  *
  * FILS shared key authentication offload can be advertized by drivers by
@@ -2080,8 +2092,10 @@ enum nl80211_commands {
  *	identifying the scope of PMKSAs. This is used with
  *	@NL80211_CMD_SET_PMKSA and @NL80211_CMD_DEL_PMKSA.
  *
- * @NL80211_ATTR_PMK: PMK for the PMKSA identified by %NL80211_ATTR_PMKID.
- *	This is used with @NL80211_CMD_SET_PMKSA.
+ * @NL80211_ATTR_PMK: attribute for passing PMK key material. Used with
+ *	%NL80211_CMD_SET_PMKSA for the PMKSA identified by %NL80211_ATTR_PMKID.
+ *	For %NL80211_CMD_CONNECT it is used to provide PSK for offloading 4-way
+ *	handshake for WPA/WPA2-PSK networks.
  *
  * @NL80211_ATTR_SCHED_SCAN_MULTI: flag attribute which user-space shall use to
  *	indicate that it supports multiple active scheduled scan requests.
@@ -4852,6 +4866,9 @@ enum nl80211_feature_flags {
  *	RSSI threshold values to monitor rather than exactly one threshold.
  * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS shared key
  *	authentication with %NL80211_CMD_CONNECT.
+ * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK: Device supports doing 4-way
+ *	handshake with PSK in station mode (PSK is passed as part of the connect
+ *	and associate commands).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4872,6 +4889,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
 	NL80211_EXT_FEATURE_FILS_SK_OFFLOAD,
+	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9eb5919..2c6863a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8168,6 +8168,15 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 		memcpy(settings->akm_suites, data, len);
 	}
 
+	if (info->attrs[NL80211_ATTR_PMK]) {
+		if (nla_len(info->attrs[NL80211_ATTR_PMK]) != WLAN_PMK_LEN)
+			return -EINVAL;
+		if (!wiphy_ext_feature_isset(&rdev->wiphy,
+					     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK))
+			return -EINVAL;
+		settings->psk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+	}
+
 	return 0;
 }
 
-- 
1.9.1
