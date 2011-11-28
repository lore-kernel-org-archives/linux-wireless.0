Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52889 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1VjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:39:02 -0500
Received: by mail-vx0-f174.google.com with SMTP id fk14so4064537vcb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:39:02 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 3/5] brcm80211: fix usage of set tx power
Date: Mon, 28 Nov 2011 16:38:48 -0500
Message-Id: <1322516330-4007-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223906_096708_FAFEA168)
In-Reply-To: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mBm is passed but dBm was assumed...

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index cc19a73..fc98981 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1429,7 +1429,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 static s32
 brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
-			 enum nl80211_tx_power_setting type, s32 dbm)
+			    enum nl80211_tx_power_setting type, s32 mbm)
 {
 
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
@@ -1437,6 +1437,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	u16 txpwrmw;
 	s32 err = 0;
 	s32 disable = 0;
+	s32 dbm = MBM_TO_DBM(mbm);
 
 	WL_TRACE("Enter\n");
 	if (!check_sys_up(wiphy))
-- 
1.7.4.15.g7811d

