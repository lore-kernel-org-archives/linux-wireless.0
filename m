Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53163 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbHTUGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 16:06:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V3 3/6] brcmfmac: make use of cfg80211_check_combinations()
Date: Thu, 20 Aug 2015 22:06:05 +0200
Message-ID: <1440101168-2252-4-git-send-email-arend@broadcom.com> (sfid-20150820_220621_317634_42693BC9)
In-Reply-To: <1440101168-2252-1-git-send-email-arend@broadcom.com>
References: <1440101168-2252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use cfg80211_check_combinations() so we can bail out early when an
interface add or change results in an invalid combination.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 44 +++++++++++++++++++++-
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 17cf1bc..9c7c061 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -469,6 +469,36 @@ brcmf_find_wpsie(const u8 *parse, u32 len)
 	return NULL;
 }
 
+static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
+				     struct brcmf_cfg80211_vif *vif,
+				     enum nl80211_iftype new_type)
+{
+	int iftype_num[NUM_NL80211_IFTYPES];
+	struct brcmf_cfg80211_vif *pos;
+
+	memset(&iftype_num[0], 0, sizeof(iftype_num));
+	list_for_each_entry(pos, &cfg->vif_list, list)
+		if (pos == vif)
+			iftype_num[new_type]++;
+		else
+			iftype_num[pos->wdev.iftype]++;
+
+	return cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+}
+
+static int brcmf_vif_add_validate(struct brcmf_cfg80211_info *cfg,
+				  enum nl80211_iftype new_type)
+{
+	int iftype_num[NUM_NL80211_IFTYPES];
+	struct brcmf_cfg80211_vif *pos;
+
+	memset(&iftype_num[0], 0, sizeof(iftype_num));
+	list_for_each_entry(pos, &cfg->vif_list, list)
+		iftype_num[pos->wdev.iftype]++;
+
+	iftype_num[new_type]++;
+	return cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+}
 
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 				 struct brcmf_wsec_key_le *key_le)
@@ -663,8 +693,14 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     struct vif_params *params)
 {
 	struct wireless_dev *wdev;
+	int err;
 
 	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
+	err = brcmf_vif_add_validate(wiphy_to_cfg(wiphy), type);
+	if (err) {
+		brcmf_err("iface validation failed: err=%d\n", err);
+		return ERR_PTR(err);
+	}
 	switch (type) {
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_STATION:
@@ -823,8 +859,12 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	s32 ap = 0;
 	s32 err = 0;
 
-	brcmf_dbg(TRACE, "Enter, ndev=%p, type=%d\n", ndev, type);
-
+	brcmf_dbg(TRACE, "Enter, idx=%d, type=%d\n", ifp->bssidx, type);
+	err = brcmf_vif_change_validate(wiphy_to_cfg(wiphy), vif, type);
+	if (err) {
+		brcmf_err("iface validation failed: err=%d\n", err);
+		return err;
+	}
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_WDS:
-- 
1.9.1

