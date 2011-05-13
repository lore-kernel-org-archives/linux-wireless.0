Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3416 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab1EMKAF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 29/32] staging: brcm80211: cfg80211 up/down routines in
 brcmfmac driver are fixed
Date: Fri, 13 May 2011 11:59:49 +0200
Message-ID: <1305280792-9475-29-git-send-email-arend@broadcom.com> (sfid-20110513_120127_194776_CBB8150D)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

'__wl_cfg80211_up' & '__wl_cfg80211_down' routines are updated to correctly
set the 'wl->status' variable.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   27 ++++++---------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index eb7f611..03f6c20 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3391,7 +3391,6 @@ s32 wl_cfg80211_attach(struct net_device *ndev, void *data)
 		goto cfg80211_attach_out;
 	}
 	wl_set_drvdata(wl_cfg80211_dev, ci);
-	set_bit(WL_STATUS_READY, &wl->status);
 
 	return err;
 
@@ -4021,6 +4020,8 @@ static s32 __wl_cfg80211_up(struct wl_priv *wl)
 {
 	s32 err = 0;
 
+	set_bit(WL_STATUS_READY, &wl->status);
+
 	wl_debugfs_add_netdev_params(wl);
 
 	err = wl_config_dongle(wl, false);
@@ -4028,41 +4029,29 @@ static s32 __wl_cfg80211_up(struct wl_priv *wl)
 		return err;
 
 	wl_invoke_iscan(wl);
-	set_bit(WL_STATUS_READY, &wl->status);
+
 	return err;
 }
 
 static s32 __wl_cfg80211_down(struct wl_priv *wl)
 {
-	s32 err = 0;
-
-	/* Check if cfg80211 interface is already down */
-	if (!test_bit(WL_STATUS_READY, &wl->status))
-		return err;	/* it is even not ready */
-
 	set_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
 	wl_term_iscan(wl);
 	if (wl->scan_request) {
-		cfg80211_scan_done(wl->scan_request, true);	/* true
-								 means abort */
-		/* wl_set_mpc(wl_to_ndev(wl), 1); */	/* BUG
-						* this operation cannot help
-						* but here because sdio
-						* is already down through
-						* rmmod process.
-						* Need to figure out how to
-						* address this issue
-						*/
+		cfg80211_scan_done(wl->scan_request, true);
+		/* May need to perform this to cover rmmod */
+		/* wl_set_mpc(wl_to_ndev(wl), 1); */
 		wl->scan_request = NULL;
 	}
 	clear_bit(WL_STATUS_READY, &wl->status);
 	clear_bit(WL_STATUS_SCANNING, &wl->status);
 	clear_bit(WL_STATUS_SCAN_ABORTING, &wl->status);
+	clear_bit(WL_STATUS_CONNECTING, &wl->status);
 	clear_bit(WL_STATUS_CONNECTED, &wl->status);
 
 	wl_debugfs_remove_netdev(wl);
 
-	return err;
+	return 0;
 }
 
 s32 wl_cfg80211_up(void)
-- 
1.7.4.1


