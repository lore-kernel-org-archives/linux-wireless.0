Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3466 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab1IPT20 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 15:28:26 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/19] staging: brcm80211: fixed sparse endianness
 warnings on fullmac scb pars
Date: Fri, 16 Sep 2011 12:28:00 -0700
Message-ID: <1316201288-29635-12-git-send-email-frankyl@broadcom.com> (sfid-20110916_212846_287210_0B9F9CF8)
In-Reply-To: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
References: <1316201288-29635-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structure that is sent to the dongle has been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    4 ++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index c34cc7b..af0ad1f 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -535,8 +535,8 @@ struct brcmf_wsec_key_le {
 };
 
 /* Used to get specific STA parameters */
-struct brcmf_scb_val {
-	u32 val;
+struct brcmf_scb_val_le {
+	__le32 val;
 	u8 ea[ETH_ALEN];
 };
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 67955d3..3b0c1a3 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1327,7 +1327,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 		       u16 reason_code)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct brcmf_scb_val scbval;
+	struct brcmf_scb_val_le scbval;
 	s32 err = 0;
 
 	WL_TRACE("Enter. Reason code = %d\n", reason_code);
@@ -1336,11 +1336,10 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 
 	clear_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 
-	scbval.val = reason_code;
 	memcpy(&scbval.ea, brcmf_read_prof(cfg_priv, WL_PROF_BSSID), ETH_ALEN);
-	scbval.val = cpu_to_le32(scbval.val);
+	scbval.val = cpu_to_le32(reason_code);
 	err = brcmf_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
-			sizeof(struct brcmf_scb_val));
+			      sizeof(struct brcmf_scb_val_le));
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -1771,7 +1770,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 			u8 *mac, struct station_info *sinfo)
 {
 	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
-	struct brcmf_scb_val scb_val;
+	struct brcmf_scb_val_le scb_val;
 	int rssi;
 	s32 rate;
 	s32 err = 0;
@@ -1803,9 +1802,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
-		scb_val.val = 0;
+		scb_val.val = cpu_to_le32(0);
 		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
-				sizeof(struct brcmf_scb_val));
+				      sizeof(struct brcmf_scb_val_le));
 		if (unlikely(err))
 			WL_ERR("Could not get rssi (%d)\n", err);
 
-- 
1.7.1


