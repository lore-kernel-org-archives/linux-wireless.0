Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4481 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/12] brcmfmac: cleanup brcmf_cfg80211_profile
 structure
Date: Mon, 22 Oct 2012 13:55:35 -0700
Message-ID: <1350939341-17687-7-git-send-email-frankyl@broadcom.com> (sfid-20121022_225614_028937_F0014B31)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

A couple of unused fields have been removed and kernel-doc info has
been added to the structure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 851403f..08ca390 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -214,23 +214,17 @@ struct brcmf_cfg80211_security {
 	u32 wpa_auth;
 };
 
-/* ibss information for currently joined ibss network */
-struct brcmf_cfg80211_ibss {
-	u8 beacon_interval;	/* in millisecond */
-	u8 atim;		/* in millisecond */
-	s8 join_only;
-	u8 band;
-	u8 channel;
-};
-
-/* dongle profile */
+/**
+ * struct brcmf_cfg80211_profile - profile information.
+ *
+ * @ssid: ssid of associated/associating ap.
+ * @bssid: bssid of joined/joining ibss.
+ * @sec: security information.
+ */
 struct brcmf_cfg80211_profile {
-	u32 mode;
 	struct brcmf_ssid ssid;
 	u8 bssid[ETH_ALEN];
 	struct brcmf_cfg80211_security sec;
-	struct brcmf_cfg80211_ibss ibss;
-	s32 band;
 };
 
 /**
-- 
1.7.9.5


