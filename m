Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1911 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 002/119] staging:brcm80211:brcmfmac: CONNECTING status
 bit is set at appropriate location
Date: Wed, 29 Jun 2011 16:46:26 -0700
Message-ID: <1309391303-22741-3-git-send-email-frankyl@broadcom.com> (sfid-20110630_014841_660282_A603C312)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

'WL_STATUS_CONNECTING' status bit is  set at appropriate step in bss/ibss
connect requests.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   48 ++++++++++++++--------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index afafa57..52c1782 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -975,6 +975,8 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	set_bit(WL_STATUS_CONNECTING, &wl->status);
+
 	if (params->bssid)
 		WL_CONN("BSSID: %02X %02X %02X %02X %02X %02X\n",
 		params->bssid[0], params->bssid[1], params->bssid[2],
@@ -1088,9 +1090,9 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	set_bit(WL_STATUS_CONNECTING, &wl->status);
-
 done:
+	if (err)
+		clear_bit(WL_STATUS_CONNECTING, &wl->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -1380,6 +1382,8 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EOPNOTSUPP;
 	}
 
+	set_bit(WL_STATUS_CONNECTING, &wl->status);
+
 	if (chan) {
 		wl->channel =
 			ieee80211_frequency_to_channel(chan->center_freq);
@@ -1391,24 +1395,34 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	WL_INFO("ie (%p), ie_len (%zd)\n", sme->ie, sme->ie_len);
 
 	err = wl_set_wpa_version(dev, sme);
-	if (unlikely(err))
-		return err;
+	if (err) {
+		WL_ERR("wl_set_wpa_version failed (%d)\n", err);
+		goto done;
+	}
 
 	err = wl_set_auth_type(dev, sme);
-	if (unlikely(err))
-		return err;
+	if (err) {
+		WL_ERR("wl_set_auth_type failed (%d)\n", err);
+		goto done;
+	}
 
 	err = wl_set_set_cipher(dev, sme);
-	if (unlikely(err))
-		return err;
+	if (err) {
+		WL_ERR("wl_set_set_cipher failed (%d)\n", err);
+		goto done;
+	}
 
 	err = wl_set_key_mgmt(dev, sme);
-	if (unlikely(err))
-		return err;
+	if (err) {
+		WL_ERR("wl_set_key_mgmt failed (%d)\n", err);
+		goto done;
+	}
 
 	err = wl_set_set_sharedkey(dev, sme);
-	if (unlikely(err))
-		return err;
+	if (err) {
+		WL_ERR("wl_set_set_sharedkey failed (%d)\n", err);
+		goto done;
+	}
 
 	wl_update_prof(wl, NULL, sme->bssid, WL_PROF_BSSID);
 	/*
@@ -1435,12 +1449,12 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
 	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
-	if (unlikely(err)) {
-		WL_ERR("error (%d)\n", err);
-		return err;
-	}
-	set_bit(WL_STATUS_CONNECTING, &wl->status);
+	if (err)
+		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 
+done:
+	if (err)
+		clear_bit(WL_STATUS_CONNECTING, &wl->status);
 	WL_TRACE("Exit\n");
 	return err;
 }
-- 
1.7.1


