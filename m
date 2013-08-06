Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3HFJNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 05:13:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] brcmfmac: use CFG80211_TESTMODE_CMD
Date: Tue,  6 Aug 2013 11:13:19 +0200
Message-Id: <1375780399-1120-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_111326_956917_F4D949F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is essentially the same, but written shorter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index b7d8850..f393828 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4163,9 +4163,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.stop_p2p_device = brcmf_p2p_stop_device,
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
-#ifdef CONFIG_NL80211_TESTMODE
-	.testmode_cmd = brcmf_cfg80211_testmode
-#endif
+	CFG80211_TESTMODE_CMD(brcmf_cfg80211_testmode)
 };
 
 static s32 brcmf_nl80211_iftype_to_mode(enum nl80211_iftype type)
-- 
1.8.0

