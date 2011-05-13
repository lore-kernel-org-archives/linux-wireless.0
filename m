Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2929 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Sukesh Srikakula" <sukeshs@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 28/32] staging: brcm80211: Removed unused variable from
 brcmfmac driver
Date: Fri, 13 May 2011 11:59:48 +0200
Message-ID: <1305280792-9475-28-git-send-email-arend@broadcom.com> (sfid-20110513_120041_392420_D80027D0)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sukesh Srikakula <sukeshs@broadcom.com>

Removed unused variable from wl_profile structure

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    5 -----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index abdf857..eb7f611 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4107,8 +4107,6 @@ static void *wl_read_prof(struct wl_priv *wl, s32 item)
 	switch (item) {
 	case WL_PROF_SEC:
 		return &wl->profile->sec;
-	case WL_PROF_ACT:
-		return &wl->profile->active;
 	case WL_PROF_BSSID:
 		return &wl->profile->bssid;
 	case WL_PROF_SSID:
@@ -4142,9 +4140,6 @@ wl_update_prof(struct wl_priv *wl, const wl_event_msg_t *e, void *data,
 	case WL_PROF_SEC:
 		memcpy(&wl->profile->sec, data, sizeof(wl->profile->sec));
 		break;
-	case WL_PROF_ACT:
-		wl->profile->active = *(bool *)data;
-		break;
 	case WL_PROF_BEACONINT:
 		wl->profile->beacon_interval = *(u16 *)data;
 		break;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index ced637d..2e8e14d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -235,7 +235,6 @@ struct wl_profile {
 	struct wl_security sec;
 	struct wl_ibss ibss;
 	s32 band;
-	bool active;
 };
 
 /* dongle iscan event loop */
-- 
1.7.4.1


