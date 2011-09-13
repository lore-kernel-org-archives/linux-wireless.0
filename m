Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2986 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/17] staging: brcm80211: introduced fullmac function
 get/set u32 to/from dongle
Date: Tue, 13 Sep 2011 09:49:57 +0200
Message-ID: <1315900197-7260-18-git-send-email-rvossen@broadcom.com> (sfid-20110913_095051_910747_A9ED9133)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Avoids repetition of same code fragment.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   62 ++++++++++-----------
 1 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index ce393ac..1f736ea 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -267,6 +267,19 @@ brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len)
 	return err;
 }
 
+/* function for reading/writing a single u32 from/to the dongle */
+static int
+brcmf_dev_ioctl_u32(struct net_device *dev, u32 cmd, u32 *par)
+{
+	int err;
+	__le32 par_le = cpu_to_le32(*par);
+
+	err = brcmf_dev_ioctl(dev, cmd, &par_le, sizeof(__le32));
+	*par = le32_to_cpu(par_le);
+
+	return err;
+}
+
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 				 struct brcmf_wsec_key_le *key_le)
 {
@@ -327,8 +340,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	infra = cpu_to_le32(infra);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		err = -EAGAIN;
@@ -656,8 +668,7 @@ static s32 brcmf_set_retry(struct net_device *dev, u32 retry, bool l)
 	s32 err = 0;
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
-	retry = cpu_to_le32(retry);
-	err = brcmf_dev_ioctl(dev, cmd, &retry, sizeof(retry));
+	err = brcmf_dev_ioctl_u32(dev, cmd, &retry);
 	if (unlikely(err)) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -941,9 +952,9 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		/* set channel for starter */
-		target_channel = cpu_to_le32(cfg_priv->channel);
-		err = brcmf_dev_ioctl(dev, BRCM_SET_CHANNEL,
-			&target_channel, sizeof(target_channel));
+		target_channel = cfg_priv->channel;
+		err = brcmf_dev_ioctl_u32(dev, BRCM_SET_CHANNEL,
+					  &target_channel);
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
@@ -1388,9 +1399,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	}
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
-	disable = cpu_to_le32(disable);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable,
-			      sizeof(disable));
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_RADIO, &disable);
 	if (unlikely(err))
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1440,7 +1449,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 			       u8 key_idx, bool unicast, bool multicast)
 {
 	u32 index;
-	s32 wsec;
+	u32 wsec;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
@@ -1448,19 +1457,16 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
 	}
 
-	wsec = le32_to_cpu(wsec);
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
-		index = (u32) key_idx;
-		index = cpu_to_le32(index);
-		err = brcmf_dev_ioctl(dev, BRCMF_C_SET_KEY_PRIMARY, &index,
-				sizeof(index));
+		index = key_idx;
+		err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_KEY_PRIMARY, &index);
 		if (unlikely(err))
 			WL_ERR("error (%d)\n", err);
 	}
@@ -1637,8 +1643,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	val = 1;		/* assume shared key. otherwise 0 */
-	val = cpu_to_le32(val);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
 	if (unlikely(err))
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
@@ -1699,8 +1704,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	val = 0;		/* assume open key. otherwise 1 */
-	val = cpu_to_le32(val);
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_AUTH, &val);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1729,14 +1733,13 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 
 	memset(&params, 0, sizeof(params));
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_WSEC, &wsec);
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
 		err = -EAGAIN;
 		goto done;
 	}
-	wsec = le32_to_cpu(wsec);
 	switch (wsec) {
 	case WEP_ENABLED:
 		sec = brcmf_read_prof(cfg_priv, WL_PROF_SEC);
@@ -1804,11 +1807,10 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Report the current tx rate */
-	err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RATE, &rate, sizeof(rate));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_GET_RATE, &rate);
 	if (err) {
 		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
-		rate = le32_to_cpu(rate);
 		sinfo->filled |= STATION_INFO_TX_BITRATE;
 		sinfo->txrate.legacy = rate * 5;
 		WL_CONN("Rate %d Mbps\n", rate / 2);
@@ -1858,10 +1860,9 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	pm = enabled ? PM_FAST : PM_OFF;
-	pm = cpu_to_le32(pm);
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_dev_ioctl(dev, BRCMF_C_SET_PM, &pm, sizeof(pm));
+	err = brcmf_dev_ioctl_u32(dev, BRCMF_C_SET_PM, &pm);
 	if (unlikely(err)) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -3491,8 +3492,7 @@ static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 		WL_ERR("invalid type (%d)\n", iftype);
 		return err;
 	}
-	infra = cpu_to_le32(infra);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
@@ -3703,9 +3703,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 		goto default_conf_out;
 
 	power_mode = cfg_priv->pwr_save ? PM_FAST : PM_OFF;
-	power_mode = cpu_to_le32(power_mode);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PM,
-				&power_mode, sizeof(power_mode));
+	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_PM,	&power_mode);
 	if (err)
 		goto default_conf_out;
 	WL_INFO("power save set to %s\n",
-- 
1.7.4.1


