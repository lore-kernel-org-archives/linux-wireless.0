Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:20161 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbbLIKW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 05:22:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 07/13] brcmfmac: no interface combination check for single interface
Date: Wed, 9 Dec 2015 11:22:46 +0100
Message-ID: <1449656572-16158-8-git-send-email-arend@broadcom.com> (sfid-20151209_112334_256750_F6905C3B)
In-Reply-To: <1449656572-16158-1-git-send-email-arend@broadcom.com>
References: <1449656572-16158-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interface combinations are intended for use-case in which the driver
handles multiple interface concurrently. This means that the combinations
do not need to be checked when there is only a single interface active.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Change-Id: Id8aa05f91f8643ae34848170d1e3f2180e90bd26
Reviewed-on: http://hnd-swgit.sj.broadcom.com:8080/5521
Reviewed-by: brcm80211 ci <brcm80211-ci@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 8557566..3ac5cf7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -396,15 +396,23 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 {
 	int iftype_num[NUM_NL80211_IFTYPES];
 	struct brcmf_cfg80211_vif *pos;
+	bool check_combos = false;
+	int ret = 0;
 
 	memset(&iftype_num[0], 0, sizeof(iftype_num));
 	list_for_each_entry(pos, &cfg->vif_list, list)
-		if (pos == vif)
+		if (pos == vif) {
 			iftype_num[new_type]++;
-		else
+		} else {
+			/* concurrent interfaces so need check combinations */
+			check_combos = true;
 			iftype_num[pos->wdev.iftype]++;
+		}
 
-	return cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+	if (check_combos)
+		ret = cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+
+	return ret;
 }
 
 static int brcmf_vif_add_validate(struct brcmf_cfg80211_info *cfg,
-- 
1.9.1

