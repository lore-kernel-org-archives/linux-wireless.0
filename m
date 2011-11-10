Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3749 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/19] brcm80211: smac: combine promiscuous mode
 functionality
Date: Thu, 10 Nov 2011 20:30:28 +0100
Message-ID: <1320953434-16859-15-git-send-email-arend@broadcom.com> (sfid-20111110_203054_258119_3B97BBF3)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Combined mac configuration for promiscious mode and monitor mode, and
removed unused monitor mode flag in pub structure.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   47 +++++++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h  |    1 -
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 6a679c9..36e3e06 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3583,42 +3583,30 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 	brcms_c_set_phy_chanspec(wlc, chanspec);
 }
 
-static void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
-{
-	if (wlc->bcnmisc_monitor)
-		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
-	else
-		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, 0);
-}
-
-void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
-{
-	wlc->bcnmisc_monitor = promisc;
-	brcms_c_mac_bcn_promisc(wlc);
-}
-
-/* set or clear maccontrol bits MCTL_PROMISC and MCTL_KEEPCONTROL */
+/*
+ * Set or clear maccontrol bits MCTL_PROMISC, MCTL_BCNS_PROMISC and
+ * MCTL_KEEPCONTROL
+ */
 static void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 {
 	u32 promisc_bits = 0;
 
-	/*
-	 * promiscuous mode just sets MCTL_PROMISC
-	 * Note: APs get all BSS traffic without the need to set
-	 * the MCTL_PROMISC bit since all BSS data traffic is
-	 * directed at the AP
-	 */
-	if (wlc->pub->promisc)
-		promisc_bits |= MCTL_PROMISC;
+	if (wlc->bcnmisc_monitor)
+		promisc_bits |= MCTL_BCNS_PROMISC;
 
-	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
-	 * Note: monitor mode also needs MCTL_BCNS_PROMISC, but that is
-	 * handled in brcms_c_mac_bcn_promisc()
-	 */
 	if (wlc->monitor)
-		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
+		promisc_bits |=
+			MCTL_PROMISC | MCTL_BCNS_PROMISC | MCTL_KEEPCONTROL;
 
-	brcms_b_mctrl(wlc->hw, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
+	brcms_b_mctrl(wlc->hw,
+			MCTL_PROMISC | MCTL_BCNS_PROMISC | MCTL_KEEPCONTROL,
+			promisc_bits);
+}
+
+void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
+{
+	wlc->bcnmisc_monitor = promisc;
+	brcms_c_mac_promisc(wlc);
 }
 
 /*
@@ -3650,7 +3638,6 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	}
 
 	/* update the various promisc bits */
-	brcms_c_mac_bcn_promisc(wlc);
 	brcms_c_mac_promisc(wlc);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 8f3da0e..21ccf3a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -381,7 +381,6 @@ struct brcms_pub {
 	uint _nbands;		/* # bands supported */
 	uint now;		/* # elapsed seconds */
 
-	bool promisc;		/* promiscuous destination address */
 	bool delayed_down;	/* down delayed */
 	bool associated;	/* true:part of [I]BSS, false: not */
 	/* (union of stas_associated, aps_associated) */
-- 
1.7.5.4


