Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:17912 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbbLJMnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2015 07:43:21 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH V2 07/13] brcmfmac: no interface combination check for single interface
Date: Thu, 10 Dec 2015 13:43:06 +0100
Message-ID: <1449751392-32569-8-git-send-email-arend@broadcom.com> (sfid-20151210_134326_385285_64E0C2A5)
In-Reply-To: <1449751392-32569-1-git-send-email-arend@broadcom.com>
References: <1449751392-32569-1-git-send-email-arend@broadcom.com>
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

