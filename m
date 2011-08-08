Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2803 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Sukesh Srikakula" <sukeshs@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 24/82] staging: brcm80211: power save issue fixed in
 brcmfmac driver
Date: Mon, 8 Aug 2011 15:58:08 +0200
Message-ID: <1312811946-16713-25-git-send-email-arend@broadcom.com> (sfid-20110808_160223_404562_F592A04B)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

brcmfmac driver is getting request for enabling power save
before the interface is up. With the earlier implementation,
this request used to fail resulting out of sync power save
state between cfg80211 & brcmfmac driver. With this fix,
power save state is stored in configuration parameters and
will be used while initializing the adapter.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |    5 ---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   34 ++++++++++++++++++++--
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 4412893..62b7591 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1099,7 +1099,6 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 				 "event_msgs" + '\0' + bitvec  */
 	uint up = 0;
 	char buf[128], *ptr;
-	uint power_mode = PM_FAST;
 	u32 dongle_align = BRCMF_SDALIGN;
 	u32 glom = 0;
 	uint bcn_timeout = 3;
@@ -1128,10 +1127,6 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	/* Print fw version info */
 	BRCMF_ERROR(("Firmware version = %s\n", buf));
 
-	/* Set PowerSave mode */
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_PM, (char *)&power_mode,
-			 sizeof(power_mode));
-
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index a69fa93..d4d7c52 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1974,9 +1974,24 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 {
 	s32 pm;
 	s32 err = 0;
+	struct brcmf_cfg80211_priv *cfg_priv = wiphy_to_cfg(wiphy);
 
 	WL_TRACE("Enter\n");
-	CHECK_SYS_UP();
+
+	/*
+	 * Powersave enable/disable request is coming from the
+	 * cfg80211 even before the interface is up. In that
+	 * scenario, driver will be storing the power save
+	 * preference in cfg_priv struct to apply this to
+	 * FW later while initializing the dongle
+	 */
+	cfg_priv->pwr_save = enabled;
+	if (!test_bit(WL_STATUS_READY, &cfg_priv->status)) {
+
+		WL_INFO("Device is not ready,"
+			"storing the value in cfg_priv struct\n");
+		goto done;
+	}
 
 	pm = enabled ? PM_FAST : PM_OFF;
 	pm = cpu_to_le32(pm);
@@ -1989,6 +2004,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		else
 			WL_ERR("error (%d)\n", err);
 	}
+done:
 	WL_TRACE("Exit\n");
 	return err;
 }
@@ -3390,11 +3406,12 @@ static s32 brcmf_init_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 
 static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
 	s32 err = 0;
 
 	cfg_priv->scan_request = NULL;
-	cfg_priv->pwr_save = !!(wiphy->flags & WIPHY_FLAG_PS_ON_BY_DEFAULT);
+#ifndef WL_POWERSAVE_DISABLED
+	cfg_priv->pwr_save = true;
+#endif /* WL_POWERSAVE_DISABLED */
 	cfg_priv->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
 	cfg_priv->roam_on = false;	/* roam on & off switch.
@@ -3811,6 +3828,7 @@ s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv, bool need_lock)
 {
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
+	s32 power_mode;
 	s32 err = 0;
 
 	if (cfg_priv->dongle_up)
@@ -3827,6 +3845,16 @@ s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv, bool need_lock)
 	err = brcmf_dongle_eventmsg(ndev);
 	if (unlikely(err))
 		goto default_conf_out;
+
+	power_mode = cfg_priv->pwr_save ? PM_FAST : PM_OFF;
+	power_mode = cpu_to_le32(power_mode);
+	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PM,
+				&power_mode, sizeof(power_mode));
+	if (err)
+		goto default_conf_out;
+	WL_INFO("power save set to %s\n",
+		(power_mode ? "enabled" : "disabled"));
+
 	err = brcmf_dongle_roam(ndev, (cfg_priv->roam_on ? 0 : 1),
 				WL_BEACON_TIMEOUT);
 	if (unlikely(err))
-- 
1.7.4.1


