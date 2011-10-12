Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4992 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/22] brcm80211: use endian annotation for pmk related
 structure
Date: Wed, 12 Oct 2011 20:51:20 +0200
Message-ID: <1318445492-24207-11-git-send-email-arend@broadcom.com> (sfid-20111012_205202_614995_0BF26345)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pairwise master key configuration is sent to the device. The
structure has been annotated for endianess checking.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   34 ++++++++++++-------
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |    2 +-
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 1218ed7..9e69cd7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2467,9 +2467,12 @@ brcmf_update_pmklist(struct net_device *ndev,
 		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
 {
 	int i, j;
+	int pmkid_len;
 
-	WL_CONN("No of elements %d\n", pmk_list->pmkids.npmkid);
-	for (i = 0; i < pmk_list->pmkids.npmkid; i++) {
+	pmkid_len = le32_to_cpu(pmk_list->pmkids.npmkid);
+
+	WL_CONN("No of elements %d\n", pmkid_len);
+	for (i = 0; i < pmkid_len; i++) {
 		WL_CONN("PMKID[%d]: %pM =\n", i,
 			&pmk_list->pmkids.pmkid[i].BSSID);
 		for (j = 0; j < WLAN_PMKID_LEN; j++)
@@ -2491,26 +2494,30 @@ brcmf_cfg80211_set_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct pmkid_list *pmkids = &cfg_priv->pmk_list->pmkids;
 	s32 err = 0;
 	int i;
+	int pmkid_len;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	for (i = 0; i < pmkids->npmkid; i++)
+	pmkid_len = le32_to_cpu(pmkids->npmkid);
+	for (i = 0; i < pmkid_len; i++)
 		if (!memcmp(pmksa->bssid, pmkids->pmkid[i].BSSID, ETH_ALEN))
 			break;
 	if (i < WL_NUM_PMKIDS_MAX) {
 		memcpy(pmkids->pmkid[i].BSSID, pmksa->bssid, ETH_ALEN);
 		memcpy(pmkids->pmkid[i].PMKID, pmksa->pmkid, WLAN_PMKID_LEN);
-		if (i == pmkids->npmkid)
-			pmkids->npmkid++;
+		if (i == pmkid_len) {
+			pmkid_len++;
+			pmkids->npmkid = cpu_to_le32(pmkid_len);
+		}
 	} else
 		err = -EINVAL;
 
 	WL_CONN("set_pmksa,IW_PMKSA_ADD - PMKID: %pM =\n",
-		pmkids->pmkid[pmkids->npmkid].BSSID);
+		pmkids->pmkid[pmkid_len].BSSID);
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
-		WL_CONN("%02x\n", pmkids->pmkid[pmkids->npmkid].PMKID[i]);
+		WL_CONN("%02x\n", pmkids->pmkid[pmkid_len].PMKID[i]);
 
 	err = brcmf_update_pmklist(ndev, cfg_priv->pmk_list, err);
 
@@ -2525,7 +2532,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 	struct pmkid_list pmkid;
 	s32 err = 0;
-	int i;
+	int i, pmkid_len;
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
@@ -2539,17 +2546,18 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 	for (i = 0; i < WLAN_PMKID_LEN; i++)
 		WL_CONN("%02x\n", pmkid.pmkid[0].PMKID[i]);
 
-	for (i = 0; i < cfg_priv->pmk_list->pmkids.npmkid; i++)
+	pmkid_len = le32_to_cpu(cfg_priv->pmk_list->pmkids.npmkid);
+	for (i = 0; i < pmkid_len; i++)
 		if (!memcmp
 		    (pmksa->bssid, &cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
 		     ETH_ALEN))
 			break;
 
-	if ((cfg_priv->pmk_list->pmkids.npmkid > 0)
-	    && (i < cfg_priv->pmk_list->pmkids.npmkid)) {
+	if ((pmkid_len > 0)
+	    && (i < pmkid_len)) {
 		memset(&cfg_priv->pmk_list->pmkids.pmkid[i], 0,
 		       sizeof(struct pmkid));
-		for (; i < (cfg_priv->pmk_list->pmkids.npmkid - 1); i++) {
+		for (; i < (pmkid_len - 1); i++) {
 			memcpy(&cfg_priv->pmk_list->pmkids.pmkid[i].BSSID,
 			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].BSSID,
 			       ETH_ALEN);
@@ -2557,7 +2565,7 @@ brcmf_cfg80211_del_pmksa(struct wiphy *wiphy, struct net_device *ndev,
 			       &cfg_priv->pmk_list->pmkids.pmkid[i + 1].PMKID,
 			       WLAN_PMKID_LEN);
 		}
-		cfg_priv->pmk_list->pmkids.npmkid--;
+		cfg_priv->pmk_list->pmkids.npmkid = cpu_to_le32(pmkid_len - 1);
 	} else
 		err = -EINVAL;
 
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index e98ed50..452bd42 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -258,7 +258,7 @@ struct pmkid {
 };
 
 struct pmkid_list {
-	u32 npmkid;
+	__le32 npmkid;
 	struct pmkid pmkid[1];
 };
 
-- 
1.7.4.1


