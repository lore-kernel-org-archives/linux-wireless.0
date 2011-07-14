Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4280 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932386Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 25/35] staging: brcm80211: brcmfmac: Connect request
 made robust
Date: Thu, 14 Jul 2011 14:29:21 -0700
Message-ID: <1310678971-28952-26-git-send-email-frankyl@broadcom.com> (sfid-20110714_233238_955568_61BEA501)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Connect request made robust by passing broadcast bssid to the
FW in SET_SSID request. This fix helps STA to connect
to any available AP in ESS instead of sticking to one
unresponsive AP.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index a915b6e..2e8fd6e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1420,11 +1420,6 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	brcmf_update_prof(cfg_priv, NULL, sme->bssid, WL_PROF_BSSID);
-	/*
-	 **  Join with specific BSSID and cached SSID
-	 **  If SSID is zero join based on BSSID only
-	 */
 	memset(&join_params, 0, sizeof(join_params));
 	join_params_size = sizeof(join_params.ssid);
 
@@ -1433,10 +1428,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	join_params.ssid.SSID_len = cpu_to_le32(join_params.ssid.SSID_len);
 	brcmf_update_prof(cfg_priv, NULL, &join_params.ssid, WL_PROF_SSID);
 
-	if (sme->bssid)
-		memcpy(join_params.params.bssid, sme->bssid, ETH_ALEN);
-	else
-		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
+	memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 
 	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
 		WL_CONN("ssid \"%s\", len (%d)\n",
-- 
1.7.1


