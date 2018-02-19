Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50004 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752655AbeBSMas (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:30:48 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] brcmfmac: reject too long PSK
Date: Mon, 19 Feb 2018 13:30:45 +0100
Message-Id: <20180219123045.8818-1-johannes@sipsolutions.net> (sfid-20180219_133052_280431_60CC11DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

nl80211 already allows specifying 48 bytes, but brcmfmac
only supports 32. Reject keys that are too long.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 15fa00d79fc6..74a83020c073 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5124,6 +5124,9 @@ static int brcmf_cfg80211_set_pmk(struct wiphy *wiphy, struct net_device *dev,
 	if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
 		return -EINVAL;
 
+	if (conf->pmk_len > BRCMF_WSEC_MAX_PSK_LEN)
+		return -ERANGE;
+
 	return brcmf_set_pmk(ifp, conf->pmk, conf->pmk_len);
 }
 
-- 
2.15.1
