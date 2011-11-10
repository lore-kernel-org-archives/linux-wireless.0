Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4628 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1KJTaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 19/19] brcm80211: fmac: release bss struct returned from
 cfg80211_inform_bss
Date: Thu, 10 Nov 2011 20:30:34 +0100
Message-ID: <1320953434-16859-21-git-send-email-arend@broadcom.com> (sfid-20111110_203119_789239_AE98CCE1)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Referenced struct returned by cfg80211_inform_bss must be released with
cfg80211_put_bss to avoid memory leak.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 73be2c8..cc19a73 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2049,10 +2049,10 @@ static s32 brcmf_inform_single_bss(struct brcmf_cfg80211_priv *cfg_priv,
 		notify_timestamp, notify_capability, notify_interval, notify_ie,
 		notify_ielen, notify_signal, GFP_KERNEL);
 
-	if (!bss) {
-		WL_ERR("cfg80211_inform_bss_frame error\n");
-		return -EINVAL;
-	}
+	if (!bss)
+		return -ENOMEM;
+
+	cfg80211_put_bss(bss);
 
 	return err;
 }
@@ -2096,6 +2096,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 	struct ieee80211_channel *notify_channel;
 	struct brcmf_bss_info_le *bi = NULL;
 	struct ieee80211_supported_band *band;
+	struct cfg80211_bss *bss;
 	u8 *buf = NULL;
 	s32 err = 0;
 	u16 channel;
@@ -2149,10 +2150,17 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 	WL_CONN("signal: %d\n", notify_signal);
 	WL_CONN("notify_timestamp: %#018llx\n", notify_timestamp);
 
-	cfg80211_inform_bss(wiphy, notify_channel, bssid,
+	bss = cfg80211_inform_bss(wiphy, notify_channel, bssid,
 		notify_timestamp, notify_capability, notify_interval,
 		notify_ie, notify_ielen, notify_signal, GFP_KERNEL);
 
+	if (!bss) {
+		err = -ENOMEM;
+		goto CleanUp;
+	}
+
+	cfg80211_put_bss(bss);
+
 CleanUp:
 
 	kfree(buf);
-- 
1.7.5.4


