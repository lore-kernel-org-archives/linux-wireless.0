Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:44837 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbbLIKW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:56 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/13] brcmfmac: Cleanup pmksa cache handling code.
Date: Wed, 9 Dec 2015 11:22:43 +0100
Message-ID: <1449656572-16158-5-git-send-email-arend@broadcom.com> (sfid-20151209_112402_938853_D0A88D2D)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Change-Id: Ib5026eec9652dfdfd184c2fa97e1588f9f9cb4d8
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5512
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 131 +++++++++------------
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   9 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  24 ++++
 .../broadcom/brcm80211/include/brcmu_wifi.h        |  23 ----
 4 files changed, 82 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 5432c46..564e533 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3223,26 +3223,22 @@ exit:
 }
 
 static __used s32
-brcmf_update_pmklist(struct net_device *ndev,
-		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
+brcmf_update_pmklist(struct brcmf_cfg80211_info *cfg, struct brcmf_if *ifp)
 {
-	int i, j;
-	u32 pmkid_len;
+	struct brcmf_pmk_list_le *pmk_list;
+	int i;
+	u32 npmk;
+	s32 err;
 
-	pmkid_len = le32_to_cpu(pmk_list->pmkids.npmkid);
+	pmk_list = &cfg->pmk_list;
+	npmk = le32_to_cpu(pmk_list->npmk);
 
-	brcmf_dbg(CONN, "No of elements %d\n", pmkid_len);
-	for (i = 0; i < pmkid_len; i++) {
-		brcmf_dbg(CONN, "PMKID[%d]: %pM =\n", i,
-			  &pmk_list->pmkids.pmkid[i].BSSID);
-		for (j = 0; j < WLAN_PMKID_LEN; j++)
-			brcmf_dbg(CONN, "%02x\n",
-				  pmk_list->pmkids.pmkid[i].PMKID[j]);
-	}
+	brcmf_dbg(CONN, "No of elements %d\n", npmk);
+	for (i = 0; i < npmk; i++)
+		brcmf_dbg(CONN, "PMK[%d]: %pM\n", i, &pmk_list->pmk[i].bssid);
 
-	if (!err)
-		brcmf_fil_iovar_data_set(netdev_priv(ndev), "pmkid_info",
-					 (char *)pmk_list, sizeof(*pmk_list));
+	err = brcmf_fil_iovar_data_set(ifp, "pmkid_info", pmk_list,
+				       sizeof(*pmk_list));
 
 	return err;
 }
@@ -3253,34 +3249,37 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct pmkid_list *pmkids = &cfg->pmk_list->pmkids;
-	s32 err = 0;
-	u32 pmkid_len, i;
+	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	s32 err;
+	u32 npmk, i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	pmkid_len = le32_to_cpu(pmkids->npmkid);
-	for (i = 0; i < pmkid_len; i++)
-		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
+	npmk = le32_to_cpu(cfg->pmk_list.npmk);
+	for (i = 0; i < npmk; i++)
+		if (!memcmp(pmksa->bssid, pmk[i].bssid, ETH_ALEN))
 			break;
-	if (i < WL_NUM_PMKIDS_MAX) {
-		memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
-		memcpy(pmkids->pmkid[i].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
-		if (i == pmkid_len) {
-			pmkid_len++;
-			pmkids->npmkid = cpu_to_le32(pmkid_len);
+	if (i < BRCMF_MAXPMKID) {
+		memcpy(pmk[i].bssid, pmksa->bssid, ETH_ALEN);
+		memcpy(pmk[i].pmkid, pmksa->pmkid, WLAN_PMKID_LEN);
+		if (i == npmk) {
+			npmk++;
+			cfg->pmk_list.npmk = cpu_to_le32(npmk);
 		}
-	} else
-		err = -EINVAL;
+	} else {
+		brcmf_err("Too many PMKSA entries cached %d\n", npmk);
+		return -EINVAL;
+	}
 
-	brcmf_dbg(CONN, "set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-		  pmkids->pmkid[pmkid_len].BSSID);
-	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		brcmf_dbg(CONN, "%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
+	brcmf_dbg(CONN, "set_pmksa - PMK bssid: %pM =\n", pmk[npmk].bssid);
+	for (i = 0; i < WLAN_PMKID_LEN; i += 4)
+		brcmf_dbg(CONN, "%02x %02x %02x %02x\n", pmk[npmk].pmkid[i],
+			  pmk[npmk].pmkid[i + 1], pmk[npmk].pmkid[i + 2],
+			  pmk[npmk].pmkid[i + 3]);
 
-	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
+	err = brcmf_update_pmklist(cfg, ifp);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -3288,50 +3287,39 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 
 static s32
 brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
-		      struct cfg80211_pmksa *pmksa)
+			 struct cfg80211_pmksa *pmksa)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	struct pmkid_list pmkid;
-	s32 err = 0;
-	u32 pmkid_len, i;
+	struct brcmf_pmksa *pmk = &cfg->pmk_list.pmk[0];
+	s32 err;
+	u32 npmk, i;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	memcpy(&pmkid.pmkid[0].BSSID, pmksa->bssid, ETH_ALEN);
-	memcpy(&pmkid.pmkid[0].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
+	brcmf_dbg(CONN, "del_pmksa - PMK bssid = %pM\n", &pmksa->bssid);
 
-	brcmf_dbg(CONN, "del_pmksa,IW_PMKSA_REMOVE - PMKID: %pM =\n",
-		  &pmkid.pmkid[0].BSSID);
-	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		brcmf_dbg(CONN, "%02x\n", pmkid.pmkid[0].PMKID[i]);
-
-	pmkid_len = le32_to_cpu(cfg->pmk_list->pmkids.npmkid);
-	for (i = 0; i < pmkid_len; i++)
-		if (!memcmp
-		    (pmksa->bssid, &cfg->pmk_list->pmkids.pmkid[i].BSSID,
-		     ETH_ALEN))
+	npmk = le32_to_cpu(cfg->pmk_list.npmk);
+	for (i = 0; i < npmk; i++)
+		if (!memcmp(&pmksa->bssid, &pmk[i].bssid, ETH_ALEN))
 			break;
 
-	if ((pmkid_len > 0)
-	    && (i < pmkid_len)) {
-		memset(&cfg->pmk_list->pmkids.pmkid[i], 0,
-		       sizeof(struct pmkid));
-		for (; i < (pmkid_len - 1); i++) {
-			memcpy(&cfg->pmk_list->pmkids.pmkid[i].BSSID,
-			       &cfg->pmk_list->pmkids.pmkid[i + 1].BSSID,
-			       ETH_ALEN);
-			memcpy(&cfg->pmk_list->pmkids.pmkid[i].PMKID,
-			       &cfg->pmk_list->pmkids.pmkid[i + 1].PMKID,
+	if ((npmk > 0) && (i < npmk)) {
+		for (; i < (npmk - 1); i++) {
+			memcpy(&pmk[i].bssid, &pmk[i + 1].bssid, ETH_ALEN);
+			memcpy(&pmk[i].pmkid, &pmk[i + 1].pmkid,
 			       WLAN_PMKID_LEN);
 		}
-		cfg->pmk_list->pmkids.npmkid = cpu_to_le32(pmkid_len - 1);
-	} else
-		err = -EINVAL;
+		memset(&pmk[i], 0, sizeof(*pmk));
+		cfg->pmk_list.npmk = cpu_to_le32(npmk - 1);
+	} else {
+		brcmf_err("Cache entry not found\n");
+		return -EINVAL;
+	}
 
-	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
+	err = brcmf_update_pmklist(cfg, ifp);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -3343,14 +3331,14 @@ brcmf_cfg80211_flush_pmksa(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
-	s32 err = 0;
+	s32 err;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
 
-	memset(cfg->pmk_list, 0, sizeof(*cfg->pmk_list));
-	err = brcmf_update_pmklist(ndev, cfg->pmk_list, err);
+	memset(&cfg->pmk_list, 0, sizeof(cfg->pmk_list));
+	err = brcmf_update_pmklist(cfg, ifp);
 
 	brcmf_dbg(TRACE, "Exit\n");
 	return err;
@@ -5249,8 +5237,6 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->escan_ioctl_buf = NULL;
 	kfree(cfg->extra_buf);
 	cfg->extra_buf = NULL;
-	kfree(cfg->pmk_list);
-	cfg->pmk_list = NULL;
 }
 
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
@@ -5264,9 +5250,6 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_info *cfg)
 	cfg->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!cfg->extra_buf)
 		goto init_priv_mem_out;
-	cfg->pmk_list = kzalloc(sizeof(*cfg->pmk_list), GFP_KERNEL);
-	if (!cfg->pmk_list)
-		goto init_priv_mem_out;
 
 	return 0;
 
@@ -5971,7 +5954,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 
 	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
 	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
-	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
+	wiphy->max_num_pmkids = BRCMF_MAXPMKID;
 
 	err = brcmf_setup_ifmodes(wiphy, ifp);
 	if (err)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index ec8d1f8..397d41b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -21,7 +21,6 @@
 #include <brcmu_d11.h>
 
 #define WL_NUM_SCAN_MAX			10
-#define WL_NUM_PMKIDS_MAX		MAXPMKID
 #define WL_TLV_INFO_MAX			1024
 #define WL_BSS_INFO_MAX			2048
 #define WL_ASSOC_INFO_MAX		512	/* assoc related fil max buf */
@@ -196,12 +195,6 @@ struct brcmf_cfg80211_assoc_ielen_le {
 	__le32 resp_len;
 };
 
-/* wpa2 pmk list */
-struct brcmf_cfg80211_pmk_list {
-	struct pmkid_list pmkids;
-	struct pmkid foo[MAXPMKID - 1];
-};
-
 /* dongle escan state */
 enum wl_escan_state {
 	WL_ESCAN_STATE_IDLE,
@@ -359,7 +352,7 @@ struct brcmf_cfg80211_info {
 	struct mutex usr_sync;
 	struct wl_cfg80211_bss_info *bss_info;
 	struct brcmf_cfg80211_connect_info conn_info;
-	struct brcmf_cfg80211_pmk_list *pmk_list;
+	struct brcmf_pmk_list_le pmk_list;
 	unsigned long scan_status;
 	struct brcmf_pub *pub;
 	u32 channel;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 18483e7..e56eabc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -126,6 +126,8 @@
 #define BRCMF_TXBF_SU_BFR_CAP		BIT(0)
 #define BRCMF_TXBF_MU_BFR_CAP		BIT(1)
 
+#define	BRCMF_MAXPMKID			16	/* max # PMKID cache entries */
+
 /* join preference types for join_pref iovar */
 enum brcmf_join_pref_types {
 	BRCMF_JOIN_PREF_RSSI = 1,
@@ -646,4 +648,26 @@ struct brcmf_wowl_wakeind_le {
 	__le32 ucode_wakeind;
 };
 
+/**
+ * struct brcmf_pmksa - PMK Security Association
+ *
+ * @bssid: The AP's BSSID.
+ * @pmkid: he PMK material itself.
+ */
+struct brcmf_pmksa {
+	u8 bssid[ETH_ALEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+};
+
+/**
+ * struct brcmf_pmk_list_le - List of pmksa's.
+ *
+ * @npmk: Number of pmksa's.
+ * @pmk: PMK SA information.
+ */
+struct brcmf_pmk_list_le {
+	__le32 npmk;
+	struct brcmf_pmksa pmk[BRCMF_MAXPMKID];
+};
+
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
index 76b5d3a..3f68dd5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_wifi.h
@@ -237,9 +237,6 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 #define WPA2_AUTH_RESERVED4	0x0400
 #define WPA2_AUTH_RESERVED5	0x0800
 
-/* pmkid */
-#define	MAXPMKID		16
-
 #define DOT11_DEFAULT_RTS_LEN		2347
 #define DOT11_DEFAULT_FRAG_LEN		2346
 
@@ -251,24 +248,4 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
 #define HT_CAP_RX_STBC_NO		0x0
 #define HT_CAP_RX_STBC_ONE_STREAM	0x1
 
-struct pmkid {
-	u8 BSSID[ETH_ALEN];
-	u8 PMKID[WLAN_PMKID_LEN];
-};
-
-struct pmkid_list {
-	__le32 npmkid;
-	struct pmkid pmkid[1];
-};
-
-struct pmkid_cand {
-	u8 BSSID[ETH_ALEN];
-	u8 preauth;
-};
-
-struct pmkid_cand_list {
-	u32 npmkid_cand;
-	struct pmkid_cand pmkid_cand[1];
-};
-
 #endif				/* _BRCMU_WIFI_H_ */
-- 
1.9.1

