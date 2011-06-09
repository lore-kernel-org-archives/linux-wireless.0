Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2522 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab1FIOpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 11/21] staging: brcm80211: Fix for suspend issue in
 brcmfmac driver
Date: Thu, 9 Jun 2011 16:44:51 +0200
Message-ID: <1307630701-9170-12-git-send-email-rvossen@broadcom.com> (sfid-20110609_164528_913658_54BBE12E)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Issue with disconnect at the time of suspend is fixed by properly setting
connection status bits maintained by brcmfmac driver.

Signed-off-by: Sukesh Srikakula <sukeshs@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   32 ++++++++++++++++-----
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index e9d19c5..399d7a8 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2110,8 +2110,9 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy)
 	 * While going to suspend if associated with AP disassociate
 	 * from AP to save power while system is in suspended state
 	 */
-	if (test_bit(WL_STATUS_CONNECTED, &wl->status) &&
-		test_bit(WL_STATUS_READY, &wl->status)) {
+	if ((test_bit(WL_STATUS_CONNECTED, &wl->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &wl->status)) &&
+	     test_bit(WL_STATUS_READY, &wl->status)) {
 		WL_INFO("Disassociating from AP"
 			" while entering suspend state\n");
 		wl_link_down(wl);
@@ -2138,8 +2139,6 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy)
 	}
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	clear_bit(WL_STATUS_CONNECTING, &wl->status);
-	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
 	/* Inform SDIO stack not to switch off power to the chip */
 	sdioh_sdio_set_host_pm_flags(MMC_PM_KEEP_POWER);
@@ -2620,10 +2619,12 @@ wl_notify_connect_status(struct wl_priv *wl, struct net_device *ndev,
 	} else if (wl_is_linkdown(wl, e)) {
 		WL_CONN("Linkdown\n");
 		if (wl_is_ibssmode(wl)) {
+			clear_bit(WL_STATUS_CONNECTING, &wl->status);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
 				&wl->status))
 				wl_link_down(wl);
 		} else {
+			wl_bss_connect_done(wl, ndev, e, data, false);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
 				&wl->status)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
@@ -4099,6 +4100,25 @@ static s32 __wl_cfg80211_up(struct wl_priv *wl)
 
 static s32 __wl_cfg80211_down(struct wl_priv *wl)
 {
+	/*
+	 * While going down, if associated with AP disassociate
+	 * from AP to save power
+	 */
+	if ((test_bit(WL_STATUS_CONNECTED, &wl->status) ||
+	     test_bit(WL_STATUS_CONNECTING, &wl->status)) &&
+	     test_bit(WL_STATUS_READY, &wl->status)) {
+		WL_INFO("Disassociating from AP");
+		wl_link_down(wl);
+
+		/* Make sure WPA_Supplicant receives all the event
+		   generated due to DISASSOC call to the fw to keep
+		   the state fw and WPA_Supplicant state consistent
+		 */
+		rtnl_unlock();
+		wl_delay(500);
+		rtnl_lock();
+	}
+
 	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 	wl_term_iscan(wl);
 	if (wl->scan_request) {
@@ -4110,8 +4130,6 @@ static s32 __wl_cfg80211_down(struct wl_priv *wl)
 	clear_bit(WL_STATUS_READY, &wl->status);
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
-	clear_bit(WL_STATUS_CONNECTING, &wl->status);
-	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
 	wl_debugfs_remove_netdev(wl);
 
@@ -4230,14 +4248,12 @@ static __used s32 wl_add_ie(struct wl_priv *wl, u8 t, u8 l, u8 *v)
 	return err;
 }
 
-
 static void wl_link_down(struct wl_priv *wl)
 {
 	struct net_device *dev = NULL;
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
-	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
 	if (wl->link_up) {
 		dev = wl_to_ndev(wl);
-- 
1.7.4.1


