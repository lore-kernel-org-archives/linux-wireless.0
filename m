Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3118 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1HHN7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Sukesh Srikakula" <sukeshs@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 26/82] staging: brcm80211: brcmfmac: Connect request
 made robust
Date: Mon, 8 Aug 2011 15:58:10 +0200
Message-ID: <1312811946-16713-27-git-send-email-arend@broadcom.com> (sfid-20110808_160143_895026_C6D3F158)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
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
Signed-off-by: Arend van Spriel <arend@broadcom.com>
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
1.7.4.1


