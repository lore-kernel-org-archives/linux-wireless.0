Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:19595 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbbJHSd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:33:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/11] brcmfmac: Add dump_station support to cfg80221 ops.
Date: Thu, 8 Oct 2015 20:33:18 +0200
Message-ID: <1444329201-3696-9-git-send-email-arend@broadcom.com> (sfid-20151008_204654_424022_AEDCE005)
In-Reply-To: <1444329201-3696-1-git-send-email-arend@broadcom.com>
References: <1444329201-3696-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

With this feature it becomes possible to request a station
assoc list.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 30 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h |  1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |  1 +
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 13 ++++++++++
 4 files changed, 45 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index ca9d239..1829337 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -2521,6 +2521,35 @@ done:
 	return err;
 }
 
+static int
+brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
+			    int idx, u8 *mac, struct station_info *sinfo)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter, idx %d\n", idx);
+
+	if (idx == 0) {
+		cfg->assoclist.count = cpu_to_le32(BRCMF_MAX_ASSOCLIST);
+		err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_ASSOCLIST,
+					     &cfg->assoclist,
+					     sizeof(cfg->assoclist));
+		if (err) {
+			brcmf_err("BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
+				  err);
+			cfg->assoclist.count = 0;
+			return -EOPNOTSUPP;
+		}
+	}
+	if (idx < le32_to_cpu(cfg->assoclist.count)) {
+		memcpy(mac, cfg->assoclist.mac[idx], ETH_ALEN);
+		return brcmf_cfg80211_get_station(wiphy, ndev, mac, sinfo);
+	}
+	return -ENOENT;
+}
+
 static s32
 brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 			   bool enabled, s32 timeout)
@@ -4620,6 +4649,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.join_ibss = brcmf_cfg80211_join_ibss,
 	.leave_ibss = brcmf_cfg80211_leave_ibss,
 	.get_station = brcmf_cfg80211_get_station,
+	.dump_station = brcmf_cfg80211_dump_station,
 	.set_tx_power = brcmf_cfg80211_set_tx_power,
 	.get_tx_power = brcmf_cfg80211_get_tx_power,
 	.add_key = brcmf_cfg80211_add_key,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index 3f5e550..4d95c6e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -407,6 +407,7 @@ struct brcmf_cfg80211_info {
 	struct brcmu_d11inf d11inf;
 	bool wowl_enabled;
 	u32 pre_wowl_pmmode;
+	struct brcmf_assoclist_le assoclist;
 };
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
index 5434dcf..b20fc0f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -72,6 +72,7 @@
 #define BRCMF_C_GET_BSS_INFO			136
 #define BRCMF_C_GET_BANDLIST			140
 #define BRCMF_C_SET_SCB_TIMEOUT			158
+#define BRCMF_C_GET_ASSOCLIST			159
 #define BRCMF_C_GET_PHYLIST			180
 #define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
 #define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 297911f..daa427b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -119,6 +119,8 @@
 #define BRCMF_COUNTRY_BUF_SZ		4
 #define BRCMF_ANT_MAX			4
 
+#define BRCMF_MAX_ASSOCLIST		128
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
@@ -621,4 +623,15 @@ struct brcmf_rev_info_le {
 	__le32 nvramrev;
 };
 
+/**
+ * struct brcmf_assoclist_le - request assoc list.
+ *
+ * @count: indicates number of stations.
+ * @mac: MAC addresses of stations.
+ */
+struct brcmf_assoclist_le {
+	__le32 count;
+	u8 mac[BRCMF_MAX_ASSOCLIST][ETH_ALEN];
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1

