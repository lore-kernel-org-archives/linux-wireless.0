Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61419 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab1KWQI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 11:08:28 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so608166vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 08:08:28 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFC 3/5] brcm80211: fix usage of set tx power
Date: Wed, 23 Nov 2011 11:08:22 -0500
Message-Id: <1322064502-16465-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_170831_550968_546A7703)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mBm is passed but dBm was assumed...

Cc: Arend van Spriel <arend@broadcom.com>
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

