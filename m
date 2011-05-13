Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2948 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 27/32] staging: brcm80211: Fixed scan notification
 functionality in brcmfmac driver
Date: Fri, 13 May 2011 11:59:47 +0200
Message-ID: <1305280792-9475-27-git-send-email-arend@broadcom.com> (sfid-20110513_120041_920345_04CDA5DB)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Earlier brcmfmac driver used to report success even for an aborted scan. This
functionality is now fixed with this patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   56 ++++++++++++---------
 1 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 450e072..abdf857 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -768,26 +768,25 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		       (int)wl->status);
 		return -EAGAIN;
 	}
+	if (test_bit(WL_STATUS_CONNECTING, &wl->status)) {
+		WL_ERR("Connecting : status (%d)\n",
+		       (int)wl->status);
+		return -EAGAIN;
+	}
 
 	iscan_req = false;
 	spec_scan = false;
-	if (request) {		/* scan bss */
+	if (request) {
+		/* scan bss */
 		ssids = request->ssids;
-		if (wl->iscan_on && (!ssids || !ssids->ssid_len)) {	/* for
-							 * specific scan,
-							 * ssids->ssid_len has
-							 * non-zero(ssid string)
-							 * length.
-							 * Otherwise this is 0.
-							 * we do not iscan for
-							 * specific scan request
-							 */
+		if (wl->iscan_on && (!ssids || !ssids->ssid_len))
 			iscan_req = true;
-		}
-	} else {		/* scan in ibss */
+	} else {
+		/* scan in ibss */
 		/* we don't do iscan in ibss */
 		ssids = this_ssid;
 	}
+
 	wl->scan_request = request;
 	set_bit(WL_STATUS_SCANNING, &wl->status);
 	if (iscan_req) {
@@ -2883,21 +2882,23 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	struct wl_scan_results *bss_list;
 	u32 len = WL_SCAN_BUF_MAX;
 	s32 err = 0;
+	bool scan_abort = false;
 
 	if (wl->iscan_on && wl->iscan_kickstart)
 		return wl_wakeup_iscan(wl_to_iscan(wl));
 
 	if (unlikely(!test_and_clear_bit(WL_STATUS_SCANNING, &wl->status))) {
 		WL_ERR("Scan complete while device not scanning\n");
-		return -EINVAL;
-	}
-	if (unlikely(!wl->scan_request)) {
+		scan_abort = true;
+		err = -EINVAL;
+		goto scan_done_out;
 	}
-	rtnl_lock();
+
 	err = wl_dev_ioctl(ndev, WLC_GET_CHANNEL, &channel_inform,
 			sizeof(channel_inform));
 	if (unlikely(err)) {
 		WL_ERR("scan busy (%d)\n", err);
+		scan_abort = true;
 		goto scan_done_out;
 	}
 	channel_inform.scan_channel = le32_to_cpu(channel_inform.scan_channel);
@@ -2910,10 +2911,12 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	bss_list = wl->bss_list;
 	memset(bss_list, 0, len);
 	bss_list->buflen = cpu_to_le32(len);
+
 	err = wl_dev_ioctl(ndev, WLC_SCAN_RESULTS, bss_list, len);
 	if (unlikely(err)) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
+		scan_abort = true;
 		goto scan_done_out;
 	}
 	bss_list->buflen = le32_to_cpu(bss_list->buflen);
@@ -2921,16 +2924,18 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	bss_list->count = le32_to_cpu(bss_list->count);
 
 	err = wl_inform_bss(wl);
-	if (err)
+	if (err) {
+		scan_abort = true;
 		goto scan_done_out;
+	}
 
 scan_done_out:
 	if (wl->scan_request) {
-		cfg80211_scan_done(wl->scan_request, false);
+		WL_DBG("calling cfg80211_scan_done\n");
+		cfg80211_scan_done(wl->scan_request, scan_abort);
 		wl_set_mpc(ndev, 1);
 		wl->scan_request = NULL;
 	}
-	rtnl_unlock();
 	return err;
 }
 
@@ -4336,13 +4341,16 @@ s8 *wl_cfg80211_get_nvramname(void)
 static void wl_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
+	struct wl_priv *wl = ndev_to_wl(ndev);
 
-	err = wl_dev_intvar_set(ndev, "mpc", mpc);
-	if (unlikely(err)) {
-		WL_ERR("fail to set mpc\n");
-		return;
+	if (test_bit(WL_STATUS_READY, &wl->status)) {
+		err = wl_dev_intvar_set(ndev, "mpc", mpc);
+		if (unlikely(err)) {
+			WL_ERR("fail to set mpc\n");
+			return;
+		}
+		WL_INFO("MPC : %d\n", mpc);
 	}
-	WL_DBG("MPC : %d\n", mpc);
 }
 
 static int wl_debugfs_add_netdev_params(struct wl_priv *wl)
-- 
1.7.4.1


