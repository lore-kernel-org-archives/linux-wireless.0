Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3967 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab2JJSNW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 14:13:22 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] brcmfmac: set dongle mode accordingly when
 interface up
Date: Wed, 10 Oct 2012 11:13:10 -0700
Message-ID: <1349892792-4792-6-git-send-email-frankyl@broadcom.com> (sfid-20121010_201327_997787_4465B241)
In-Reply-To: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
References: <1349892792-4792-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mode of WiFi dongle should be initialized in brcmf_cfg80211_up
which get called when network interface is brought up. Otherwise
brcmf_cfg80211_get_station would return error.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   38 ++------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a39925a..5e51f15 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5199,41 +5199,6 @@ brcmf_cfg80211_event(struct net_device *ndev,
 		schedule_work(&cfg->event_work);
 }
 
-static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
-{
-	s32 infra = 0;
-	s32 err = 0;
-
-	switch (iftype) {
-	case NL80211_IFTYPE_MONITOR:
-	case NL80211_IFTYPE_WDS:
-		WL_ERR("type (%d) : currently we do not support this mode\n",
-		       iftype);
-		err = -EINVAL;
-		return err;
-	case NL80211_IFTYPE_ADHOC:
-		infra = 0;
-		break;
-	case NL80211_IFTYPE_STATION:
-		infra = 1;
-		break;
-	case NL80211_IFTYPE_AP:
-		infra = 1;
-		break;
-	default:
-		err = -EINVAL;
-		WL_ERR("invalid type (%d)\n", iftype);
-		return err;
-	}
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
-	if (err) {
-		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
-		return err;
-	}
-
-	return 0;
-}
-
 static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 {
 	/* Room for "event_msgs" + '\0' + bitvec */
@@ -5452,7 +5417,8 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 				WL_BEACON_TIMEOUT);
 	if (err)
 		goto default_conf_out;
-	err = brcmf_dongle_mode(ndev, wdev->iftype);
+	err = brcmf_cfg80211_change_iface(wdev->wiphy, ndev, wdev->iftype,
+					  NULL, NULL);
 	if (err && err != -EINPROGRESS)
 		goto default_conf_out;
 	err = brcmf_dongle_probecap(cfg);
-- 
1.7.9.5


